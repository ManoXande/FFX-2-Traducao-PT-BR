<h1 align="center">Final Fantasy X-2 HD Remaster — Tradução PT-BR</h1>

<p align="center">
  Projeto gratuito e não oficial de tradução em português do Brasil do
  <strong>FINAL FANTASY X-2 HD Remaster</strong> para Steam, Windows e Steam Deck / Linux.
</p>

<p align="center">
  <a href="https://manoxande.github.io/FFX-2-Traducao-PT-BR/"><strong>Site do projeto e tutorial</strong></a>
</p>

> **Aviso:** este projeto não possui vínculo, autorização, patrocínio ou endosso da Square Enix.
> O jogo original e atualizado da Steam é obrigatório.

## Situação do lançamento

A versão 1.0 já está publicada, com instalador para Windows e pacote manual (ZIP). A versão 1.1, com correções em rótulos de telas de menu, está em preparação para uma próxima Release.

Baixe somente pela página de [Releases](https://github.com/ManoXande/FFX-2-Traducao-PT-BR/releases) — o tamanho e o hash SHA-256 de cada arquivo são informados na própria Release.

## O que está traduzido

- Roteiro e diálogos dos eventos, com cerca de 35 mil falas
- Falas, popups e tutoriais de batalha
- Menus e descrições de itens, habilidades, acessórios e Grade de Vestes
- Bestiário e telas de sistema do remaster
- DLC Last Mission
- Fonte ajustada para ã e õ nos diálogos

Alguns nomes, rótulos do menu principal e elementos com limitações técnicas permanecem em inglês. Consulte o `LEIA-ME.txt` para os detalhes.

## Como funciona

O jogo verifica a integridade de seus arquivos originais. Este pacote não substitui o arquivo `FFX2_Data.vbf`.

A tradução utiliza o [External File Loader de ffgriever](https://www.nexusmods.com/finalfantasyxx2hdremaster/mods/150), que permite carregar arquivos adicionais a partir de `data/mods`. O pacote adiciona o loader, arquivos de configuração e conteúdos traduzidos.

## Segurança e verificação

- Baixe apenas pela Release oficial deste repositório
- Confira o hash SHA-256 antes de executar
- O instalador do Windows ainda não possui assinatura digital
- Faça backup dos saves antes de instalar qualquer mod
- Consulte [`SECURITY.md`](SECURITY.md) para orientações de verificação e reporte de problemas

## Estrutura do repositório

- `docs/` — site do projeto publicado pelo GitHub Pages
- `instalador/` — código-fonte do instalador Inno Setup
- `scripts/` — utilitários próprios de desenvolvimento e empacotamento
- `LEIA-ME.txt` — instruções completas de instalação, remoção e compatibilidade
- `arquivos-do-jogo/` — área atualmente usada para preparar o pacote; os artefatos derivados e binários serão retirados do histórico público antes da publicação definitiva

## Licenciamento

A licença deste repositório abrange **somente o código original** criado para o site, instalador e scripts próprios.

Ela não concede direitos sobre:

- FINAL FANTASY X-2 ou materiais pertencentes à Square Enix e demais titulares
- textos, personagens, imagens, marcas e arquivos derivados do jogo
- External File Loader e outros componentes de terceiros
- a tradução como obra derivada do roteiro original

Consulte [`LICENSE`](LICENSE) e [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md).

## Créditos

- **External File Loader:** ffgriever
- **Terminologia:** inspirada na tradução do FFX da [Central de Traduções](https://www.centraldetraducoes.net.br/2017/04/traducao-do-final-fantasy-x-hd-remaster-pc.html)
- **Tradução PT-BR:** Carlos Alexandre de Oliveira
- **Processo de trabalho:** engenharia reversa de formatos, ferramentas de tradução assistida por inteligência artificial e revisão humana

## Aviso legal

FINAL FANTASY X-2, seus personagens, textos, imagens e marcas pertencem aos respectivos titulares. Este é um projeto de fã gratuito e não comercial. Não inclui o jogo, não vende acesso e não aceita pagamento condicionado ao download.
