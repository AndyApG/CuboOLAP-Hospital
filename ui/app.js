const $ = id => document.getElementById(id);
const HIERS = {tiempo: "Tiempo", hospital: "Hospital", diagnostico: "Diagnóstico"};
const state = {h: "tiempo", path: []};            // path = [{k, etiqueta}, ...]  (los padres ya fijados)
const fmt = {atenciones: v => v, costo_total: v => "$" + v.toLocaleString("es-MX", {minimumFractionDigits: 2}),
  costo_prom: v => "$" + v.toLocaleString("es-MX", {minimumFractionDigits: 2}), espera_prom: v => v.toFixed(1)};

async function cargar() {
  const q = new URLSearchParams({h: state.h, path: state.path.map(p => p.k).join("|")});
  const r = await (await fetch("/api/olap?" + q)).json();
  render(r);
}

function render(r) {
  $("hiers").innerHTML = "";
  for (const [k, nombre] of Object.entries(HIERS)) {
    const b = Object.assign(document.createElement("button"), {textContent: nombre, className: k === state.h ? "on" : ""});
    b.onclick = () => { state.h = k; state.path = []; cargar(); };
    $("hiers").append(b);
  }
  // Migas de pan: cada una es un ROLL UP hasta ese nivel
  $("crumbs").innerHTML = "";
  const crumb = (txt, nivel, act) => {
    const b = Object.assign(document.createElement("button"), {textContent: txt, className: act ? "act" : ""});
    b.onclick = () => { state.path = state.path.slice(0, nivel); cargar(); };
    $("crumbs").append(b);
  };
  crumb("Total", 0, r.n === 0);
  state.path.forEach((p, i) => { $("crumbs").append(Object.assign(document.createElement("span"), {className: "sep", textContent: "›"}));
    crumb(`${r.niveles[i]}: ${p.etiqueta}`, i + 1, false); });
  if (r.n > 0) { const up = Object.assign(document.createElement("button"), {textContent: "⬆ Roll up"});
    up.onclick = () => { state.path.pop(); cargar(); }; $("crumbs").append(up); }
  $("hint").textContent = r.puede_drill ? `Nivel: ${r.nivel}. Haz clic en una fila para hacer Drill down a ${r.niveles[r.n + 1]}.`
                                        : `Nivel: ${r.nivel} (máximo detalle). Usa Roll up o las migas para subir.`;
  $("th-nivel").textContent = r.nivel;

  const m = $("medida").value, max = Math.max(...r.rows.map(x => x[m]), 1);
  const tot = r.rows.reduce((a, x) => ({n: a.n + x.atenciones, c: a.c + x.costo_total}), {n: 0, c: 0});
  $("tbody").innerHTML = "";
  for (const x of r.rows) {
    const tr = document.createElement("tr");
    if (r.puede_drill) { tr.className = "drill"; tr.onclick = () => { state.path.push({k: x.k, etiqueta: x.etiqueta}); cargar(); }; }
    tr.innerHTML = `<td>${x.etiqueta}</td><td>${x.atenciones}</td><td>${fmt.costo_total(x.costo_total)}</td>
      <td>${fmt.costo_prom(x.costo_prom)}</td><td>${x.espera_prom.toFixed(1)} min</td>
      <td class="grafico"><div class="b" style="width:${100 * x[m] / max}%"></div></td>`;
    $("tbody").append(tr);
  }
  const t = document.createElement("tr"); t.className = "tot";
  t.innerHTML = `<td>Subtotal</td><td>${tot.n}</td><td>${fmt.costo_total(tot.c)}</td><td>${fmt.costo_prom(tot.c / tot.n)}</td><td></td><td class="grafico"></td>`;
  $("tbody").append(t);
}

$("medida").onchange = cargar;
cargar();
