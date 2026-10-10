import { copyFile, mkdir, readFile, stat, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const output = join(root, '_site');
const html = await readFile(join(root, 'prueba.html'), 'utf8');
const assets = new Set();

// Incluye solamente recursos usados por la página, no documentos del proyecto.
for (const match of html.matchAll(/(?:src=["']|url\(["']?)(Media\/[^"'\s)]+)(?:["']|\))/g)) {
  const asset = match[1];
  if (!/^Media\/[A-Za-z0-9_.-]+$/.test(asset)) {
    throw new Error(`Ruta de recurso no admitida: ${asset}`);
  }
  const source = join(root, asset);
  if (!(await stat(source)).isFile()) throw new Error(`Recurso inválido: ${asset}`);
  assets.add(asset);
}
if (assets.size === 0) throw new Error('No se encontraron los recursos de la maqueta.');

await mkdir(join(output, 'Media'), { recursive: true });
await writeFile(join(output, 'index.html'), html, 'utf8');
await writeFile(join(output, 'prueba.html'), html, 'utf8');
await writeFile(join(output, '.nojekyll'), '', 'utf8');
for (const asset of assets) await copyFile(join(root, asset), join(output, asset));
console.log(`Sitio preparado en _site: index.html, prueba.html y ${assets.size} recursos.`);
