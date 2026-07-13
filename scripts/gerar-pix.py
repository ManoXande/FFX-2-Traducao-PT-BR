# -*- coding: utf-8 -*-
"""
Gerador do código PIX (BR Code / EMV-MPM) da página de doações.

Uso:
    python scripts/gerar-pix.py SUA_CHAVE_PIX

Saídas:
    - imprime o payload "copia e cola" (validado campo a campo + CRC16)
    - grava o QR Code em docs/assets/img/pix-qr.svg

Depois de rodar, cole o payload impresso na const PIX_PAYLOAD no topo de
docs/assets/js/main.js para ativar a seção de doações do site.

Requer: pip install segno
"""
import os
import sys

NOME = "Carlos Alexandre de Olive"   # máx. 25 chars (padrão BR Code)
CIDADE = "BRASIL"                    # máx. 15 chars
TXID = "***"                         # QR estático de valor livre
GUI = "br.gov.bcb.pix"

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SVG_OUT = os.path.join(REPO, "docs", "assets", "img", "pix-qr.svg")


def campo(tag: str, valor: str) -> str:
    if len(valor) > 99:
        raise ValueError(f"Campo {tag} longo demais: {valor!r}")
    return f"{tag}{len(valor):02d}{valor}"


def crc16_ccitt(dados: bytes) -> int:
    """CRC16/CCITT-FALSE (poly 0x1021, init 0xFFFF), exigido pelo BR Code."""
    crc = 0xFFFF
    for b in dados:
        crc ^= b << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) if (crc & 0x8000) else (crc << 1)
            crc &= 0xFFFF
    return crc


def montar_payload(chave: str) -> str:
    if not chave or any(c.isspace() for c in chave.strip()) and "@" not in chave:
        raise ValueError("Chave PIX inválida (vazia ou com espaços).")
    chave = chave.strip()
    mai = campo("00", GUI) + campo("01", chave)
    corpo = (
        campo("00", "01")            # Payload Format Indicator
        + campo("26", mai)           # Merchant Account Information (PIX)
        + campo("52", "0000")        # MCC
        + campo("53", "986")         # moeda BRL
        + campo("58", "BR")
        + campo("59", NOME[:25])
        + campo("60", CIDADE[:15])
        + campo("62", campo("05", TXID))
    )
    base = corpo + "6304"
    return base + f"{crc16_ccitt(base.encode('utf-8')):04X}"


def decodificar(payload: str) -> dict:
    """Decodifica TLV de volta, para autovalidação."""
    campos, i = {}, 0
    while i < len(payload):
        tag, ln = payload[i:i + 2], int(payload[i + 2:i + 4])
        campos[tag] = payload[i + 4:i + 4 + ln]
        i += 4 + ln
    return campos


def validar(payload: str, chave: str) -> None:
    c = decodificar(payload)
    assert c["00"] == "01", "Payload Format Indicator errado"
    mai = decodificar(c["26"])
    assert mai["00"] == GUI, "GUI do PIX errado"
    assert mai["01"] == chave.strip(), "Chave não confere"
    assert c["53"] == "986" and c["58"] == "BR", "Moeda/país errados"
    assert c["59"] == NOME[:25] and c["60"] == CIDADE[:15], "Nome/cidade não conferem"
    assert decodificar(c["62"])["05"] == TXID, "txid errado"
    base = payload[:-4]
    assert payload[-4:] == f"{crc16_ccitt(base.encode('utf-8')):04X}", "CRC16 inválido"


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit("Uso: python scripts/gerar-pix.py SUA_CHAVE_PIX")
    chave = sys.argv[1]
    payload = montar_payload(chave)
    validar(payload, chave)

    import segno
    qr = segno.make(payload, error="m")
    qr.save(SVG_OUT, kind="svg", scale=8, border=3,
            dark="#1d3140", light="#f2ede2")

    print("Payload validado (campo a campo + CRC16):\n")
    print(payload)
    print(f"\nQR gravado em: {SVG_OUT}")
    print("\nPróximos passos:")
    print("1. Cole o payload acima em PIX_PAYLOAD no topo de docs/assets/js/main.js")
    print("2. Teste escaneando o QR com o app do banco ANTES de publicar")


if __name__ == "__main__":
    main()
