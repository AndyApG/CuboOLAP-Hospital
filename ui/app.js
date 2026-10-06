const $ = id => document.getElementById(id);
const el = (tag, props, parent) => { const e = Object.assign(document.createElement(tag), props); parent && parent.append(e); return e; };
// path / path2 = padres ya fijados en cada eje: [{k, etiqueta}]. h2 = dimensión con la que se cruza ("" = ninguna)
const state = {q: 1, h: "hospital", path: [], h2: "", path2: []};
let META;
const num = (v, u) => u === "$" ? "$" + v.toLocaleString("es-MX", {minimumFractionDigits: 2}) : u ? `${v} ${u}` : v;

async function cargar() {
  const p = {q: state.q, h: state.h, path: state.path.map(x => x.k).join("|")};
  if (state.h2) { p.h2 = state.h2; p.path2 = state.path2.map(x => x.k).join("|"); }
  const r = await (await fetch("/api/olap?" + new URLSearchParams(p))).json();
  r.error ? ($("hint").textContent = r.error) : render(r);
}

function chips(cont, items, activo, alClic) {
  cont.innerHTML = "";
  for (const [id, txt] of items) { const b = el("button", {textContent: txt, className: id == activo ? "on" : ""}, cont); b.onclick = () => alClic(id); }
}

function render(r) {
  const dims = Object.entries(META.jerarquias);
  chips($("consultas"), META.consultas.map(c => [c.id, `${c.id}. ${c.titulo}`]), state.q, id => {
    Object.assign(state, {q: +id, h: META.consultas.find(c => c.id == id).hier, path: [], h2: "", path2: []}); cargar(); });
  chips($("hiers"), dims, state.h, k => { Object.assign(state, {h: k, path: []}); if (state.h2 === k) Object.assign(state, {h2: "", path2: []}); cargar(); });
  chips($("cruce"), [["", "(ninguna)"], ...dims.filter(([k]) => k !== state.h)], state.h2, k => { Object.assign(state, {h2: k, path2: []}); cargar(); });

  // Migas de pan por eje: cada miga y el botón son ROLL UP
  $("crumbs").innerHTML = "";
  r.ejes.forEach((e, i) => {
    const key = i ? "path2" : "path", row = el("div", {className: "crumbrow"}, $("crumbs"));
    el("span", {className: "dim", textContent: META.jerarquias[e.hier] + ":"}, row);
    const crumb = (txt, nivel, act) => { const b = el("button", {textContent: txt, className: act ? "act" : ""}, row);
      b.onclick = () => { state[key] = state[key].slice(0, nivel); cargar(); }; };
    crumb("Total", 0, e.n === 0);
    state[key].forEach((p, j) => { el("span", {className: "sep", textContent: "›"}, row); crumb(`${e.niveles[j]}: ${p.etiqueta}`, j + 1, false); });
    if (e.n > 0) el("button", {textContent: "⬆ Roll up", onclick: () => { state[key].pop(); cargar(); }}, row);
  });
  $("hint").textContent = r.ejes.some(e => e.puede_drill) ? "Clic en una etiqueta azul = Drill down en esa dimensión. Migas o ⬆ Roll up = subir de nivel."
                                                        : "Máximo detalle en todas las dimensiones. Usa Roll up o las migas para subir.";
  $("thead").innerHTML = r.ejes.map(e => `<th>${e.nivel}</th>`).join("") + `<th>Atenciones</th><th>${r.titulo}</th><th class="grafico"></th>`;

  const max = Math.max(...r.rows.map(x => x.valor), 1);
  $("tbody").innerHTML = "";
  for (const x of r.rows) {
    const tr = el("tr", {}, $("tbody"));
    r.ejes.forEach((e, i) => {
      const k = "k" + (i + 1), et = "etiqueta" + (i + 1), td = el("td", {textContent: x[et]}, tr);
      if (e.puede_drill) { td.className = "drill"; td.onclick = () => { state[i ? "path2" : "path"].push({k: x[k], etiqueta: x[et]}); cargar(); }; }
    });
    el("td", {textContent: x.atenciones}, tr); el("td", {textContent: num(x.valor, r.unidad)}, tr);
    el("td", {className: "grafico", innerHTML: `<div class="b" style="width:${100 * x.valor / max}%"></div>`}, tr);
  }
  el("tr", {className: "tot", innerHTML: `<td colspan="${r.ejes.length}">Total (niveles superiores)</td><td>${r.total.atenciones}</td><td>${num(r.total.valor, r.unidad)}</td><td class="grafico"></td>`}, $("tbody"));
  $("sql").textContent = r.sql;
}

fetch("/api/meta").then(r => r.json()).then(m => { META = m; cargar(); });
