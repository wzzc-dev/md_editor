const fs = require('fs');
const path = require('path');
const { performance } = require('perf_hooks');
const fixtureArg = process.argv[process.argv.indexOf('--benchmark') + 1];
const fixture = path.isAbsolute(fixtureArg) ? fixtureArg : path.resolve(__dirname, '..', fixtureArg);
const scenario = process.argv[process.argv.indexOf('--benchmark') + 2];
const source = fs.readFileSync(fixture, 'utf8');
function escapeHtml(value) { return value.replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[ch]); }
function inline(value) {
  let html = escapeHtml(value);
  html = html.replace(/(\*\*|__)(.+?)\1/g, '<strong>$2</strong>');
  html = html.replace(/(?<!\w)(\*)([^*]+?)\1/g, '<em>$2</em>');
  html = html.replace(/`([^`]+)`/g, '<code>$1</code>');
  return html;
}
function format(value) {
  const lines = value.split('\n'); const blocks = []; let paragraph = []; let list = []; let code = []; let inCode = false;
  const flushParagraph = () => { if (paragraph.length) { blocks.push(`<p>${inline(paragraph.join(' '))}</p>`); paragraph = []; } };
  const flushList = () => { if (list.length) { blocks.push(`<ul>${list.map(item => `<li>${inline(item)}</li>`).join('')}</ul>`); list = []; } };
  lines.forEach(raw => {
    const line = raw.trimEnd(); const trimmed = line.trim();
    if (trimmed.startsWith('```')) { if (inCode) { blocks.push(`<pre><code>${escapeHtml(code.join('\n'))}</code></pre>`); code = []; inCode = false; } else { flushParagraph(); flushList(); inCode = true; } return; }
    if (inCode) { code.push(line); return; }
    if (!trimmed) { flushParagraph(); flushList(); return; }
    const heading = /^(#{1,6})\s+(.*)$/.exec(trimmed);
    if (heading) { flushParagraph(); flushList(); const level = heading[1].length; blocks.push(`<h${level}>${inline(heading[2])}</h${level}>`); return; }
    if (/^[-*] /.test(trimmed)) { flushParagraph(); list.push(trimmed.slice(2)); return; }
    if (/^> /.test(trimmed)) { flushParagraph(); flushList(); blocks.push(`<blockquote>${inline(trimmed.slice(2))}</blockquote>`); return; }
    flushList();
    paragraph.push(trimmed);
  });
  if (inCode) blocks.push(`<pre><code>${escapeHtml(code.join('\n'))}</code></pre>`);
  flushParagraph(); flushList(); return blocks.join('');
}
const samples = []; if (scenario === 'open') { const t = performance.now(); format(source); samples.push(performance.now() - t); } else { const count = scenario === 'scroll' ? 120 : 10; for (let i = 0; i < count; i += 1) { const t = performance.now(); format(`${source}${scenario === 'input' ? i : ''}`); samples.push(performance.now() - t); } }
samples.sort((a, b) => a - b); const mean = samples.reduce((a, b) => a + b, 0) / samples.length; const at = p => samples[Math.round((samples.length - 1) * p)];
console.log(JSON.stringify({ adapter: 'electron', measurement_scope: 'headless-render', scenario, samples_ms: samples, mean_ms: mean, p95_ms: at(.95), p99_ms: at(.99), dropped_frames: samples.filter(x => x > 16.667).length, input_latency_ms: scenario === 'input' ? mean : null }));
