# Checklist de lançamento da tradução 1.0

Este documento separa o que pode permanecer no repositório público do que deve ser preparado localmente e anexado somente à Release.

## 1. Antes de incorporar o PR

- [ ] Revisar os textos jurídicos e técnicos do site
- [ ] Confirmar que o projeto continuará gratuito e não comercial
- [ ] Confirmar que não haverá PIX, Patreon, venda ou download condicionado a pagamento
- [ ] Fazer backup privado da pasta local `arquivos-do-jogo/`

## 2. Limpar o repositório público

O `.gitignore` impede novos commits, mas não remove arquivos já registrados no histórico.

Antes da divulgação ampla, reescreva o histórico para retirar:

- `arquivos-do-jogo/data/mods/`
- `arquivos-do-jogo/modules/`
- `arquivos-do-jogo/*.dll`
- `docs/assets/img/pix-qr.svg`
- `scripts/gerar-pix.py`

Ferramentas possíveis: `git filter-repo` ou BFG Repo-Cleaner. Faça primeiro um clone espelho e um backup completo. A reescrita altera os hashes dos commits e exige push forçado coordenado.

Depois da limpeza:

- [ ] Verificar que os caminhos não aparecem mais em commits antigos
- [ ] Invalidar forks ou clones antigos usados para divulgação
- [ ] Manter somente código, documentação e imagens estritamente necessárias

## 3. Revisar os componentes do pacote

- [ ] Confirmar que o pacote não contém executáveis, músicas, vídeos ou arquivos originais completos do jogo
- [ ] Confirmar que `FFX2_Data.vbf` não é incluído nem substituído
- [ ] Confirmar os termos de redistribuição do External File Loader
- [ ] Preservar os créditos de ffgriever no ZIP, instalador e página
- [ ] Listar exatamente todos os arquivos adicionados à pasta do jogo

## 4. Testar instalação e remoção

Testar em ambiente limpo:

- [ ] Windows com instalação padrão da Steam
- [ ] Windows com biblioteca Steam em outro disco
- [ ] Steam Deck ou Linux via Proton
- [ ] Instalação manual por ZIP
- [ ] Desinstalação pelo Windows
- [ ] Remoção manual
- [ ] Verificação de integridade pela Steam após remoção
- [ ] Saves existentes antes e depois da instalação
- [ ] Conflito com outros mods que usam `dinput8.dll`

## 5. Preparar os arquivos da Release

Gerar localmente:

- `FFX2-Traducao-PTBR-Setup.exe`
- `FFX-2-Traducao-PT-BR-v1.0.zip`

Para cada arquivo:

- [ ] Registrar nome exato
- [ ] Registrar tamanho em bytes
- [ ] Calcular SHA-256
- [ ] Registrar data de compilação
- [ ] Registrar versão do External File Loader
- [ ] Realizar análise antimalware
- [ ] Guardar os resultados da análise

Comandos sugeridos:

```powershell
Get-FileHash ".\FFX2-Traducao-PTBR-Setup.exe" -Algorithm SHA256
Get-FileHash ".\FFX-2-Traducao-PT-BR-v1.0.zip" -Algorithm SHA256
```

```bash
sha256sum FFX2-Traducao-PTBR-Setup.exe
sha256sum FFX-2-Traducao-PT-BR-v1.0.zip
```

## 6. Assinatura e confiança

- [ ] Avaliar assinatura digital do instalador
- [ ] Enquanto não houver assinatura, manter o aviso do SmartScreen
- [ ] Não instruir o usuário a ignorar o alerta sem verificar o hash
- [ ] Oferecer o ZIP manual como alternativa ao instalador

## 7. Atualizar o site para lançamento

Somente depois que a Release existir:

- [ ] Trocar “Download em preparação” por “Baixar a tradução”
- [ ] Inserir os links exatos dos dois arquivos publicados
- [ ] Atualizar o JSON-LD com `downloadUrl`
- [ ] Publicar tamanho e SHA-256 na página
- [ ] Informar data de lançamento e versão
- [ ] Testar todos os links em janela anônima
- [ ] Substituir imagens genéricas por capturas reais da tradução
- [ ] Incluir capturas de diálogo, batalha, menus, bestiário e Last Mission

## 8. Texto sugerido da Release

A descrição deve informar:

- projeto gratuito, não oficial e não comercial;
- exigência do jogo original da Steam;
- plataformas compatíveis;
- limitações conhecidas;
- nomes, tamanhos e hashes SHA-256;
- arquivos adicionados pelo pacote;
- procedimento de instalação e remoção;
- créditos e componentes de terceiros;
- ausência de assinatura digital, se ainda aplicável.

## 9. Procedimento caso haja reclamação

- [ ] Preservar a notificação recebida
- [ ] Retirar temporariamente os downloads, se necessário
- [ ] Não discutir publicamente de forma hostil
- [ ] Identificar se a reclamação atinge imagens, textos, binários, marca ou o projeto inteiro
- [ ] Não enviar contranotificação sem orientação jurídica específica
