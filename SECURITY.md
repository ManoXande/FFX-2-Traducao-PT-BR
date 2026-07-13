# Segurança e verificação de downloads

## Fonte oficial

Os arquivos de instalação devem ser obtidos somente pela página de Releases deste repositório:

https://github.com/ManoXande/FFX-2-Traducao-PT-BR/releases

Enquanto não existir uma Release publicada, não há instalador ou pacote manual oficialmente distribuído pelo projeto.

## Verificação SHA-256

Cada Release deve informar:

- nome exato do arquivo;
- tamanho;
- hash SHA-256;
- data de compilação;
- versão do External File Loader incluída.

No Windows, o hash pode ser conferido pelo PowerShell:

```powershell
Get-FileHash ".\FFX2-Traducao-PTBR-Setup.exe" -Algorithm SHA256
```

No Linux ou Steam Deck:

```bash
sha256sum FFX-2-Traducao-PT-BR-v1.0.zip
```

Não execute o arquivo se o resultado não for idêntico ao publicado na Release oficial.

## SmartScreen e assinatura digital

O instalador ainda não possui assinatura digital. Por isso, o Windows pode exibir um aviso do SmartScreen. A ausência de assinatura não comprova que um arquivo seja seguro.

Antes de executar:

1. confirme que o download veio da Release oficial;
2. verifique o hash SHA-256;
3. prefira a instalação manual pelo ZIP caso não queira executar um instalador não assinado.

## Comportamento esperado

O instalador:

- tenta localizar a biblioteca da Steam;
- valida a presença de `FFX-2.exe` e `FFX2_Data.vbf`;
- adiciona os arquivos do loader e da tradução à pasta do jogo;
- cria uma entrada de desinstalação no Windows;
- não deve substituir `FFX2_Data.vbf`.

## Reporte responsável

Não publique dados pessoais, chaves, credenciais ou arquivos do jogo ao relatar um problema. Abra uma Issue com:

- sistema operacional;
- versão do pacote;
- origem do download;
- hash SHA-256 do arquivo;
- mensagem de erro;
- trecho relevante de `hook.log`, removendo caminhos ou dados pessoais.

Problemas críticos de segurança devem ser descritos de forma objetiva, sem anexar arquivos proprietários do jogo.
