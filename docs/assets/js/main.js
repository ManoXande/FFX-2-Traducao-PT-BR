/* ============================================================
   Tradução PT-BR de FFX-2 — comportamentos progressivos.
   O site funciona sem JavaScript; este arquivo melhora a experiência.
   ============================================================ */

(function () {
  "use strict";

  var reduz = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  function iniciarReveals() {
    var alvos = document.querySelectorAll(".reveal");
    if (reduz || !("IntersectionObserver" in window)) {
      alvos.forEach(function (el) {
        el.classList.add("revelado");
      });
      return;
    }

    var obs = new IntersectionObserver(
      function (entradas) {
        entradas.forEach(function (entrada) {
          if (entrada.isIntersecting) {
            entrada.target.classList.add("revelado");
            obs.unobserve(entrada.target);
          }
        });
      },
      { threshold: 0.15, rootMargin: "0px 0px -8% 0px" }
    );

    alvos.forEach(function (el) {
      obs.observe(el);
    });
  }

  function iniciarTabs() {
    var tabs = Array.prototype.slice.call(document.querySelectorAll(".tab"));
    if (!tabs.length) return;

    function selecionar(tab) {
      tabs.forEach(function (item) {
        var ativo = item === tab;
        item.setAttribute("aria-selected", ativo ? "true" : "false");
        item.tabIndex = ativo ? 0 : -1;

        var painel = document.getElementById(item.getAttribute("aria-controls"));
        if (painel) painel.hidden = !ativo;
      });
    }

    tabs.forEach(function (tab, indice) {
      tab.addEventListener("click", function () {
        selecionar(tab);
      });

      tab.addEventListener("keydown", function (evento) {
        var proximo = null;
        if (evento.key === "ArrowRight") {
          proximo = (indice + 1) % tabs.length;
        } else if (evento.key === "ArrowLeft") {
          proximo = (indice - 1 + tabs.length) % tabs.length;
        }

        if (proximo !== null) {
          evento.preventDefault();
          tabs[proximo].focus();
          selecionar(tabs[proximo]);
        }
      });
    });
  }

  function copiarTexto(texto) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      return navigator.clipboard.writeText(texto);
    }

    return new Promise(function (resolve, reject) {
      try {
        var textarea = document.createElement("textarea");
        textarea.value = texto;
        textarea.style.position = "fixed";
        textarea.style.left = "-9999px";
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand("copy");
        document.body.removeChild(textarea);
        resolve();
      } catch (erro) {
        reject(erro);
      }
    });
  }

  function feedbackBotao(botao, sucesso) {
    var original = botao.dataset.original || botao.textContent;
    botao.dataset.original = original;
    botao.textContent = sucesso ? "Copiado!" : "Tente de novo";

    window.setTimeout(function () {
      botao.textContent = botao.dataset.original;
    }, 2000);
  }

  function iniciarCopiarMono() {
    document.querySelectorAll(".bloco-mono .copiar").forEach(function (botao) {
      botao.addEventListener("click", function () {
        var span = botao.parentElement.querySelector("span");
        var texto = span ? span.textContent : "";

        copiarTexto(texto).then(
          function () {
            feedbackBotao(botao, true);
          },
          function () {
            feedbackBotao(botao, false);
          }
        );
      });
    });
  }

  function iniciarNav() {
    var topo = document.getElementById("topo");
    if (!topo) return;

    var ultimo = window.pageYOffset;
    var travado = false;

    window.addEventListener(
      "scroll",
      function () {
        if (travado) return;
        travado = true;

        window.requestAnimationFrame(function () {
          var atual = window.pageYOffset;
          var descendo = atual > ultimo && atual > 120;
          topo.setAttribute("data-oculto", descendo ? "true" : "false");
          ultimo = atual;
          travado = false;
        });
      },
      { passive: true }
    );
  }

  function iniciarGiscus() {
    var alvo = document.getElementById("giscus");
    if (!alvo) return;

    var carregado = false;

    function carregar() {
      if (carregado) return;
      carregado = true;

      var script = document.createElement("script");
      script.src = "https://giscus.app/client.js";
      script.setAttribute("data-repo", "ManoXande/FFX-2-Traducao-PT-BR");
      script.setAttribute("data-repo-id", "R_kgDOTXIOKA");
      script.setAttribute("data-category", "General");
      script.setAttribute("data-category-id", "DIC_kwDOTXIOKM4DBHB2");
      script.setAttribute("data-mapping", "pathname");
      script.setAttribute("data-strict", "0");
      script.setAttribute("data-reactions-enabled", "1");
      script.setAttribute("data-emit-metadata", "0");
      script.setAttribute("data-input-position", "top");
      script.setAttribute(
        "data-theme",
        "https://manoxande.github.io/FFX-2-Traducao-PT-BR/assets/css/giscus.css"
      );
      script.setAttribute("data-lang", "pt");
      script.crossOrigin = "anonymous";
      script.async = true;
      alvo.appendChild(script);
    }

    if (!("IntersectionObserver" in window)) {
      carregar();
      return;
    }

    var obs = new IntersectionObserver(
      function (entradas) {
        if (entradas[0].isIntersecting) {
          carregar();
          obs.disconnect();
        }
      },
      { rootMargin: "300px" }
    );

    obs.observe(alvo);
  }

  function iniciarPyreflies() {
    if (reduz) return;

    var camada = document.getElementById("pyreflies");
    if (!camada) return;

    var total = 18;
    for (var i = 0; i < total; i += 1) {
      var particula = document.createElement("span");
      particula.className = "pyrefly";
      particula.style.left = (Math.random() * 100).toFixed(2) + "%";
      particula.style.top = (55 + Math.random() * 45).toFixed(2) + "%";
      particula.style.setProperty("--dur", (10 + Math.random() * 10).toFixed(1) + "s");
      particula.style.setProperty("--atraso", (Math.random() * 12).toFixed(1) + "s");

      var escala = 0.6 + Math.random() * 0.9;
      particula.style.width = (5 * escala).toFixed(1) + "px";
      particula.style.height = particula.style.width;

      if (i % 3 === 0) {
        particula.style.background = "oklch(0.80 0.10 195)";
        particula.style.boxShadow = "0 0 8px 2px oklch(0.80 0.10 195 / 0.7)";
      }

      camada.appendChild(particula);
    }
  }

  function iniciar() {
    iniciarReveals();
    iniciarTabs();
    iniciarCopiarMono();
    iniciarNav();
    iniciarGiscus();
    iniciarPyreflies();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", iniciar);
  } else {
    iniciar();
  }
})();
