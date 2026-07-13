# CLAUDE.md

Este arquivo orienta agentes e ferramentas que trabalhem neste repositório.

## Escopo do repositório

O repositório contém:

- o site público em `docs/`;
- o código-fonte do instalador em `instalador/`;
- scripts e documentação próprios;
- uma área local de empacotamento em `arquivos-do-jogo/`.

O objetivo de distribuição é manter no histórico público apenas código e documentação próprios. Binários de terceiros e conteúdos derivados do jogo devem ser preparados fora do histórico Git e anexados somente à Release final quando houver base para redistribuição.

## Funcionamento técnico

O pacote usa o External File Loader de ffgriever, um loader de terceiros baseado em `dinput8.dll`. Ele permite carregar arquivos adicionais de `data/mods` sem substituir o arquivo original `FFX2_Data.vbf`.

Evite linguagem como "burlar", "quebrar", "bypass" ou "contornar proteção". Descreva o comportamento de forma técnica e neutra:

- carregamento de arquivos adicionais;
- sobreposição de conteúdo por pasta separada;
- preservação dos arquivos originais;
- remoção reversível dos arquivos adicionados.

## Regras de conteúdo

- Não adicionar ROMs, executáveis do jogo, músicas, vídeos ou arquivos originais completos.
- Não apresentar o projeto como oficial, autorizado ou endossado.
- Não adicionar PIX, Patreon, cobrança, venda ou acesso condicionado a pagamento.
- Não aplicar a licença MIT a traduções, arquivos derivados do jogo ou componentes de terceiros.
- Preservar `LICENSE`, `THIRD-PARTY-NOTICES.md` e os créditos.
- Não publicar links de download até a Release existir e ter hashes SHA-256 conferidos.

## Site

A fonte principal é `docs/index.html`.

Antes de publicar:

- conferir se não existem links 404;
- conferir título, descrição, Open Graph e JSON-LD;
- manter o aviso não oficial próximo ao primeiro CTA;
- evitar promessas absolutas de segurança ou compatibilidade;
- publicar capturas reais da tradução quando disponíveis;
- não expor chaves, códigos PIX ou dados pessoais desnecessários.

## Instalador

O código-fonte está em `instalador/instalador.iss`.

O build depende de uma pasta local `arquivos-do-jogo/` preenchida com os componentes necessários. Esses artefatos não devem ser tratados como código licenciado pelo repositório.

Ao preparar uma Release:

1. revisar o conteúdo do pacote;
2. compilar o instalador;
3. gerar o ZIP manual;
4. calcular SHA-256;
5. registrar tamanhos, hashes e versões;
6. analisar os arquivos antes da publicação;
7. testar instalação e remoção em ambiente limpo.

## Documentação

`LEIA-ME.txt` é a referência para instalação, remoção, compatibilidade e avisos. Atualize-o sempre que o comportamento do pacote mudar.
