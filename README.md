<h1 align="center">Final Fantasy X-2 HD Remaster — Tradução PT-BR</h1>

<p align="center">
  A primeira tradução em português do Brasil do <strong>FINAL FANTASY X-2 HD Remaster</strong> (Steam).<br>
  Gratuita, para PC (Windows) e Steam Deck / Linux, sem modificar nenhum arquivo original do jogo.
</p>

<p align="center">
  <a href="https://manoxande.github.io/FFX-2-Traducao-PT-BR/"><strong>➡ Site do projeto: download e tutorial passo a passo</strong></a>
</p>

---

## Baixar

Tudo pela aba **[Releases](https://github.com/ManoXande/FFX-2-Traducao-PT-BR/releases)**:

- **Windows:** `FFX2-Traducao-PTBR-Setup.exe` — o instalador acha a pasta do jogo sozinho e faz tudo.
- **Steam Deck / Linux (ou instalação manual):** `FFX-2-Traducao-PT-BR-v1.0.zip`.

O passo a passo completo, com o passo extra do Steam Deck (`WINEDLLOVERRIDES`), está no
[site](https://manoxande.github.io/FFX-2-Traducao-PT-BR/#tutorial) e no `LEIA-ME.txt`.

## Antes de instalar, você precisa de

- O jogo **FINAL FANTASY X/X-2 HD Remaster** original da Steam, atualizado.
- Windows, ou Steam Deck / Linux rodando com Proton.
- Cerca de 7 MB de espaço livre.

## O que está traduzido

- Todo o roteiro e os diálogos dos eventos (cerca de 35 mil falas)
- Falas, popups e tutoriais de batalha
- Menus e descrições de itens, habilidades, acessórios e da Grade de Vestes
- Bestiário completo (descrições do Scan) e as telas de sistema do remaster
- A DLC Last Mission inteira, e a fonte corrigida com ã e õ nos diálogos

Nomes de itens, habilidades e lugares ficam em inglês de propósito, seguindo o padrão da
tradução clássica do FFX.

## Por que é seguro

O FFX-2 HD Remaster trava com "Broken game data" se qualquer arquivo original for modificado.
Esta tradução nunca toca neles: usa o **External File Loader** de ffgriever
([Nexus Mods #150](https://www.nexusmods.com/finalfantasyxx2hdremaster/mods/150)), que serve os
textos traduzidos de `data/mods` por cima dos originais, em memória. Seus saves ficam intactos e
a desinstalação restaura o jogo 100%.

## Estrutura do repositório

- `arquivos-do-jogo/` — os arquivos que o loader carrega (o conteúdo do pacote manual).
- `instalador/` — script Inno Setup do instalador do Windows.
- `docs/` — o site do projeto (GitHub Pages).
- `scripts/` — utilitários de build (instalador, código PIX).
- `LEIA-ME.txt` — instruções completas de instalação e desinstalação.

## Créditos

- **External File Loader:** ffgriever.
- **Terminologia:** baseada na monumental tradução do FFX da [Central de Traduções](https://www.centraldetraducoes.net.br/2017/04/traducao-do-final-fantasy-x-hd-remaster-pc.html), que inspirou este projeto.
- **Tradução:** Carlos Alexandre de Oliveira, construída com Claude (Fable 5) da Anthropic.

## Aviso legal

FINAL FANTASY X-2 é marca registrada da Square Enix Co., Ltd. Este é um projeto de fãs, gratuito,
sem fins lucrativos e sem qualquer afiliação com a Square Enix. Não venda esta tradução. O jogo
original é necessário (compre na Steam).
