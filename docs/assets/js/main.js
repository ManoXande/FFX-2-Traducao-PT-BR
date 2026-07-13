/* ============================================================
   Tradução PT-BR de FFX-2 — comportamentos progressivos.
   O site funciona inteiro sem JS; isto só melhora a experiência.
   ============================================================ */

/* Código PIX "copia e cola" (BR Code validado por scripts/gerar-pix.py).
   String vazia = seção de doação fica no estado "em breve". */
var PIX_PAYLOAD =
  "00020126580014br.gov.bcb.pix0136cf09c78d-19a2-4598-a059-862cd326fb8a5204000053039865802BR5925Carlos Alexandre de Olive6006BRASIL62070503***6304202E";

(function () {
  "use strict";

  var reduz = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ---------- 1. Scroll-reveal ---------- */
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
        entradas.forEach(function (e) {
          if (e.isIntersecting) {
            e.target.classList.add("revelado");
            obs.unobserve(e.target);
          }
        });
      },
      { threshold: 0.15, rootMargin: "0px 0px -8% 0px" }
    );
    alvos.forEach(function (el) {
      obs.observe(el);
    });
  }

  /* ---------- 2. Tabs do tutorial ---------- */
  function iniciarTabs() {
    var tabs = Array.prototype.slice.call(document.querySelectorAll(".tab"));
    if (!tabs.length) return;

    function selecionar(tab) {
      tabs.forEach(function (t) {
        var ativo = t === tab;
        t.setAttribute("aria-selected", ativo ? "true" : "false");
        t.tabIndex = ativo ? 0 : -1;
        var painel = document.getElementById(t.getAttribute("aria-controls"));
        if (painel) painel.hidden = !ativo;
      });
    }

    tabs.forEach(function (tab, i) {
      tab.addEventListener("click", function () {
        selecionar(tab);
      });
      tab.addEventListener("keydown", function (ev) {
        var j = null;
        if (ev.key === "ArrowRight") j = (i + 1) % tabs.length;
        else if (ev.key === "ArrowLeft") j = (i - 1 + tabs.length) % tabs.length;
        if (j !== null) {
          ev.preventDefault();
          tabs[j].focus();
          selecionar(tabs[j]);
        }
      });
    });
  }

  /* ---------- 3. Botões copiar ---------- */
  function copiarTexto(texto) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      return navigator.clipboard.writeText(texto);
    }
    return new Promise(function (resolve, reject) {
      try {
        var ta = document.createElement("textarea");
        ta.value = texto;
        ta.style.position = "fixed";
        ta.style.left = "-9999px";
        document.body.appendChild(ta);
        ta.select();
        document.execCommand("copy");
        document.body.removeChild(ta);
        resolve();
      } catch (e) {
        reject(e);
      }
    });
  }

  function feedbackBotao(btn, ok) {
    var original = btn.dataset.original || btn.textContent;
    btn.dataset.original = original;
    btn.textContent = ok ? "Copiado!" : "Tente de novo";
    setTimeout(function () {
      btn.textContent = btn.dataset.original;
    }, 2000);
  }

  function iniciarCopiarMono() {
    document.querySelectorAll(".bloco-mono .copiar").forEach(function (btn) {
      btn.addEventListener("click", function () {
        var span = btn.parentElement.querySelector("span");
        var texto = span ? span.textContent : "";
        copiarTexto(texto).then(
          function () {
            feedbackBotao(btn, true);
          },
          function () {
            feedbackBotao(btn, false);
          }
        );
      });
    });
  }

  /* ---------- 4. Nav esconde ao rolar para baixo ---------- */
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

  /* ---------- 5. giscus preguiçoso ---------- */
  function iniciarGiscus() {
    var alvo = document.getElementById("giscus");
    if (!alvo) return;
    var carregado = false;
    function carregar() {
      if (carregado) return;
      carregado = true;
      var s = document.createElement("script");
      s.src = "https://giscus.app/client.js";
      s.setAttribute("data-repo", "ManoXande/FFX-2-Traducao-PT-BR");
      s.setAttribute("data-repo-id", "R_kgDOTXIOKA");
      s.setAttribute("data-category", "General");
      s.setAttribute("data-category-id", "DIC_kwDOTXIOKM4DBHB2");
      s.setAttribute("data-mapping", "pathname");
      s.setAttribute("data-strict", "0");
      s.setAttribute("data-reactions-enabled", "1");
      s.setAttribute("data-emit-metadata", "0");
      s.setAttribute("data-input-position", "top");
      s.setAttribute(
        "data-theme",
        "https://manoxande.github.io/FFX-2-Traducao-PT-BR/assets/css/giscus.css"
      );
      s.setAttribute("data-lang", "pt");
      s.crossOrigin = "anonymous";
      s.async = true;
      alvo.appendChild(s);
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

  /* ---------- 6. Estado de sucesso do formulário ---------- */
  function iniciarFormSucesso() {
    if (window.location.search.indexOf("enviado=1") === -1) return;
    var form = document.getElementById("form-contato");
    var sucesso = document.getElementById("form-sucesso");
    if (form && sucesso) {
      form.hidden = true;
      sucesso.hidden = false;
    }
  }

  /* ---------- 7. Seção PIX ---------- */
  function iniciarPix() {
    var pendente = document.getElementById("pix-pendente");
    var ativo = document.getElementById("pix-ativo");
    if (!pendente || !ativo) return;

    var chave = (PIX_PAYLOAD || "").trim();
    if (chave.length > 0) {
      var code = document.getElementById("pix-copia-texto");
      if (code) code.textContent = chave;
      ativo.hidden = false;
      pendente.hidden = true;

      var btn = document.getElementById("pix-copiar");
      if (btn) {
        btn.addEventListener("click", function () {
          copiarTexto(chave).then(
            function () {
              feedbackBotao(btn, true);
            },
            function () {
              feedbackBotao(btn, false);
            }
          );
        });
      }
    } else {
      pendente.hidden = false;
      ativo.hidden = true;
    }
  }

  /* ---------- 8. Pyreflies do hero ---------- */
  function iniciarPyreflies() {
    if (reduz) return;
    var camada = document.getElementById("pyreflies");
    if (!camada) return;
    var total = 18;
    for (var i = 0; i < total; i++) {
      var p = document.createElement("span");
      p.className = "pyrefly";
      p.style.left = (Math.random() * 100).toFixed(2) + "%";
      p.style.top = (55 + Math.random() * 45).toFixed(2) + "%";
      p.style.setProperty("--dur", (10 + Math.random() * 10).toFixed(1) + "s");
      p.style.setProperty("--atraso", (Math.random() * 12).toFixed(1) + "s");
      var esc = 0.6 + Math.random() * 0.9;
      p.style.width = (5 * esc).toFixed(1) + "px";
      p.style.height = p.style.width;
      if (i % 3 === 0) {
        p.style.background = "oklch(0.80 0.10 195)";
        p.style.boxShadow = "0 0 8px 2px oklch(0.80 0.10 195 / 0.7)";
      }
      camada.appendChild(p);
    }
  }

  function iniciar() {
    iniciarReveals();
    iniciarTabs();
    iniciarCopiarMono();
    iniciarNav();
    iniciarGiscus();
    iniciarFormSucesso();
    iniciarPix();
    iniciarPyreflies();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", iniciar);
  } else {
    iniciar();
  }
})();
