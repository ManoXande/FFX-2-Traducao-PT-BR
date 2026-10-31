"""
Atualiza o ff10-file-loader.dll (External File Loader, de ffgriever) para a
build da Steam de FFX.exe / FFX-2.exe compilada em 2026-09-10.

O loader usa offsets fixos (RVA) e bytes originais para localizar as funções
de abertura de arquivos VBF. Na atualização de 10/09/2026 o código dessas
funções ficou idêntico, apenas deslocado:
  FFX-2.exe: -0x100 (OpenVBF/CheckExists), +0x80 (CheckVBF), alvos -0x1A0
  FFX.exe:   -0x1C0 (OpenVBF/CheckExists/alvos), -0x1B0 (CheckVBF)
Sem esta correção o hook.log mostra "Invalid game version" e nenhum arquivo
de data/mods é carregado.

Uso: python patch-ff10-file-loader.py ff10-file-loader.dll saida.dll
DLL original (2024-11-08) sha256: c9348472e725dc7641fa1191f660683f801bed480ff3dbfc2c6c4cfec326f089
DLL corrigida               sha256: a9ff3a657d15e0dcdaa8c05fd274a70f9e0df595c6a799244de9740f0acb207a
"""
import sys, struct, hashlib
src, dst = sys.argv[1], sys.argv[2]
d = bytearray(open(src,'rb').read())
def off(va): return va - 0x10000c00
P = [  # (instr VA, imm offset, old, new)
 # FFX.exe (build 2026-09-10)
 (0x1000113e,4,0x2081b3,0x207ff3),(0x10001163,4,0x20805f,0x207e9f),(0x10001173,4,0x013f9ce8,0x013f9ce8),
 (0x100011d6,3,0x2081af,0x207fef),(0x100011fc,3,0x013f1ce8,0x013f1ce8),(0x10001227,3,0x2081b8,0x207ff8),
 (0x1000126b,3,0x2797ae,0x2795fe),(0x1000379d,1,0x21c0d0,0x21bf10),(0x100040fd,1,0x21c000,0x21be40),
 # FFX-2.exe (build 2026-09-10)
 (0x1000131e,4,0x491353,0x491253),(0x10001343,4,0x4911ef,0x4910ef),(0x10001353,4,0x0b18dce8,0x0b183ce8),
 (0x100013b6,3,0x49134f,0x49124f),(0x100013dc,3,0x0b184ce8,0x0b17ace8),(0x10001407,3,0x491358,0x491258),
 (0x1000144b,3,0x094c6e,0x094cee),(0x100037ab,1,0x542ba0,0x542a00),(0x10004108,1,0x542ad0,0x542930),
]
for va,io,old,new in P:
    o=off(va)+io; cur=struct.unpack_from('<I',d,o)[0]
    assert cur in (old,new), (hex(va),hex(cur))
    struct.pack_into('<I',d,o,new)
open(dst,'wb').write(d)
print('ok', hashlib.sha256(d).hexdigest())
