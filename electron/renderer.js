const source = document.getElementById('source');
const preview = document.getElementById('preview');
const status = document.getElementById('status');
const fileLabel = document.getElementById('file');
const metrics = document.getElementById('metrics');
let filePath = null; let saved = '';
const sample = '# Electron Markdown Editor\n\nEdit **Markdown** on the left and watch the formatted preview update.\n\n- Open a .md file\n- Type normally\n- Scroll either pane\n\n> The saved value is always Markdown source.\n';
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
    if (trimmed.startsWith('```')) {
      if (inCode) { blocks.push(`<pre><code>${escapeHtml(code.join('\n'))}</code></pre>`); code = []; inCode = false; }
      else { flushParagraph(); flushList(); inCode = true; }
      return;
    }
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
  flushParagraph(); flushList();
  return blocks.join('');
}
function render() { preview.innerHTML = format(source.value); status.textContent = source.value === saved ? 'Saved' : 'Unsaved changes'; metrics.textContent = `${source.value.length} bytes | Electron | 1280x800`; }
source.value = sample; saved = sample; render(); source.addEventListener('input', render);
document.getElementById('new').onclick = () => { source.value = '# Untitled\n\n'; filePath = null; fileLabel.textContent = 'Untitled.md'; saved = source.value; render(); };
document.getElementById('open').onclick = async () => {
  try {
    const opened = await window.documentApi.open();
    if (!opened) return;
    source.value = opened.source; filePath = opened.path; fileLabel.textContent = opened.name; saved = source.value; render();
  } catch (error) { status.textContent = `Open failed: ${error.message}`; }
};
document.getElementById('save').onclick = async () => {
  try {
    const savedDocument = await window.documentApi.save({ path: filePath, source: source.value });
    if (!savedDocument) return;
    filePath = savedDocument.path; fileLabel.textContent = savedDocument.name; saved = source.value; render();
  } catch (error) { status.textContent = `Save failed: ${error.message}`; }
};
