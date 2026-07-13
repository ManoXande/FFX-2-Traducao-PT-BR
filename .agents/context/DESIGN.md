# DESIGN.md — Site da Tradução PT-BR de FFX-2

## Cena

Fã de FF, 30 e poucos anos, deitado no sofá às 23h com o celular, luz apagada, acabou
de ver um vídeo sobre a tradução. Tema **escuro** obrigatório (não é escolha estética,
é a cena). Mobile-first 375px; desktop é a versão expandida.

## Estratégia de cor: Committed (oceano) com acento quente

A superfície é o mar de Spira à noite; o dourado é a luz quente da locadora/pôr-do-sol.
Referência nomeada: a paleta da própria abertura do FFX-2 (show da Yuna em Luca:
noite azul-profunda + holofotes dourados, roxos e magenta). O rosa/violeta é o que
carrega a atmosfera POP de FFX-2 (mais vibrante e alegre que o FFX melancólico):
entra como brilho de holofote no hero, na faixa cinematográfica e nos kickers dela.

```css
--abismo:       oklch(0.16 0.03 230);   /* fundo base, mar profundo       */
--oceano:       oklch(0.20 0.045 225);  /* superfícies elevadas           */
--oceano-raso:  oklch(0.26 0.055 215);  /* bordas, divisores              */
--espuma:       oklch(0.93 0.012 220);  /* texto principal                */
--nevoa:        oklch(0.72 0.03 220);   /* texto secundário               */
--dourado:      oklch(0.80 0.13 80);    /* acento primário, títulos-chave */
--coral:        oklch(0.70 0.16 40);    /* CTA quente (botão download)    */
--aqua:         oklch(0.78 0.10 195);   /* links, glow, detalhes vivos    */
```

Nunca `#000`/`#fff`. Todo neutro tingido para hue 215–230.
O dourado/coral pode carregar 30%+ do hero — compromisso, não decoração.

## Tipografia (self-hosted em assets/fonts/, ver fonts.css)

- **Young Serif** (400) — display: títulos H1/H2, números de passo, o "X-2".
  Serifa calorosa, robusta, cara de capa de RPG anos 90. Só regular: hierarquia por tamanho.
- **Wix Madefor Text** (400/500/600/700 + itálico 400) — corpo, UI, botões.
- **Fragment Mono** (400) — SÓ para strings literais (comandos, caminhos de pasta).

Escala modular ratio ≥1.30, fluida com clamp(). Corpo 65–75ch máx.
Texto claro sobre escuro: line-height +0.05.

## Layout

- Long-scroll de dobras com arte por seção (permissão brand: mundos diferentes por
  seção, voz consistente). Assimetria deliberada: renders das personagens quebram
  a grade e invadem margens.
- Espaçamento com ritmo: seções respiram (clamp(4rem, 10vw, 9rem)), grupos internos densos.
- Sem container universal: texto em coluna de leitura, imagens podem sangrar full-bleed.

## Motion

- Reveal de entrada do hero orquestrado (stagger 60–90ms), ease-out-expo, 500–700ms.
- Scroll-reveal discreto (opacity+translateY 12px) via IntersectionObserver, uma vez só.
- `prefers-reduced-motion`: tudo instantâneo.
- Nunca animar layout (width/height/top); só transform/opacity.

## Bans (além dos globais)

- Nada de moldura "gamer" (cantos chanfrados neon, HUD fake).
- Nada de fundo preto puro com verde terminal.
- Logo oficial do jogo não é usado (fundo branco + trademark); o título é tipográfico.
- Emoji no corpo do texto: no máximo o ☕ da seção de apoio.
