"""
Audita os arquivos de texto da tradução contra o FFX2_Data.vbf do jogo instalado.

Verifica, para cada arquivo em arquivos-do-jogo/data/mods:
  - tabelas de texto de evento/batalha: quantidade de falas, flags e se cada
    ponteiro aponta para o início de uma frase;
  - tabelas do kernel (battle/kernel, lastmiss/kernel): se cada ponteiro de
    texto aponta para o início de uma frase;
  - códigos de controle ({12 30}, {19 xx}, {20 xx}, cores...) iguais aos do inglês.

Ponteiros quebrados ou códigos alterados causam "Message error!" nas janelas
e podem travar o jogo (ex.: baú de gil em Kilika).

Uso: python scripts/auditar-traducao.py "<pasta do jogo>\\data\\FFX2_Data.vbf" arquivos-do-jogo/data/mods
"""
import os, struct, sys, zlib, collections

class VBF:
    def __init__(s, path):
        s.f = open(path, 'rb'); _, hl, n = struct.unpack('<4sIQ', s.f.read(16))
        s.f.seek(0); h = s.f.read(hl); base = 16 + n * 16
        s.ent = [struct.unpack_from('<IIQQQ', h, base + i * 32) for i in range(n)]
        e = base + n * 32; ns = struct.unpack_from('<I', h, e)[0]; names = h[e + 4:e + 4 + ns]
        s.blocks = struct.unpack_from('<%dH' % ((hl - e - ns) // 2), h, e + ns)
        s.idx = {names[x[4]:names.index(b'\0', x[4])].decode(): i for i, x in enumerate(s.ent)}
    def read(s, name):
        bi, _, size, off, _ = s.ent[s.idx[name]]; out = bytearray(); s.f.seek(off)
        for k in range((size + 0xffff) // 0x10000):
            cs = s.blocks[bi + k] or 0x10000; want = min(0x10000, size - len(out)); d = s.f.read(cs)
            out += d if cs == want else zlib.decompress(d)
        return bytes(out)

def starts(d, pool):
    return {0} | {i - pool for i in range(pool + 1, len(d)) if d[i - 1] == 0}
def toks(s):
    t = []; i = 0
    while i < len(s):
        if s[i] < 0x30 and s[i] != 0x03: t.append((s[i], s[i + 1] if i + 1 < len(s) else None)); i += 2
        else: i += 1
    return collections.Counter(t)
def sget(d, pool, v):
    e = d.find(b'\0', pool + v); return d[pool + v:e if e >= 0 else len(d)]

def text_table(d):
    mask = 0xffff if d[2] & 0x80 else 0xffffff
    n = (struct.unpack_from('<I', d, 0)[0] & mask) // 8; hs = n * 8; s = starts(d, hs); out = []
    for i in range(n):
        a, b = struct.unpack_from('<II', d, i * 8)
        out.append(((a >> 24, b >> 24), (a & mask) - hs in s and (b & mask) - hs in s, sget(d, 0, a & mask)))
    return out

def audit(o, m):
    errs = []
    if struct.unpack_from('<I', o, 0)[0] == 1:  # kernel
        _, rs, tot, st = struct.unpack_from('<4I', o, 0x10); n = tot // rs; po = st + tot
        so, sm = starts(o, po), starts(m, po)
        for k in range(0, rs, 2):
            vo = [struct.unpack_from('<H', o, st + r * rs + k)[0] for r in range(n)]
            vm = [struct.unpack_from('<H', m, st + r * rs + k)[0] for r in range(n)]
            if vo == vm or not all(v in so for v in vo): continue
            for r in range(n):
                if vm[r] not in sm or po + vm[r] >= len(m): errs.append('registro %d campo %d: ponteiro fora de frase' % (r, k))
                elif toks(sget(o, po, vo[r])) != toks(sget(m, po, vm[r])): errs.append('registro %d campo %d: códigos diferentes do inglês' % (r, k))
                elif sget(o, po, vo[r]) and not sget(m, po, vm[r]): errs.append('registro %d campo %d: texto vazio' % (r, k))
    else:
        to, tm = text_table(o), text_table(m)
        if len(to) != len(tm): return ['quantidade de falas %d != %d' % (len(tm), len(to))]
        for i, (x, y) in enumerate(zip(to, tm)):
            if x[0] != y[0]: errs.append('fala %d: flags diferentes' % i)
            if x[1] and not y[1]: errs.append('fala %d: ponteiro fora de frase' % i)
            if toks(x[2]) != toks(y[2]): errs.append('fala %d: códigos diferentes do inglês' % i)
    return errs

if __name__ == '__main__':
    vbf, mods = VBF(sys.argv[1]), sys.argv[2]; total = 0
    for root, _, files in os.walk(mods):
        for fn in files:
            if not fn.endswith('.bin') or 'lockit' in root: continue
            p = os.path.join(root, fn); rel = os.path.relpath(p, mods).replace('\\', '/')
            if rel.endswith('monlist.bin'): continue  # entradas vazias no inglês preenchidas na tradução
            errs = audit(vbf.read(rel), open(p, 'rb').read())
            for e in errs: print(rel + ': ' + e)
            total += len(errs)
    print('Problemas encontrados: %d' % total)
    sys.exit(1 if total else 0)
