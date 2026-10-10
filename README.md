# Shark Grúas

Maqueta de la landing de Shark Grúas: servicios, cobertura regional,
preguntas frecuentes y vista de prueba del cotizador.

La base operativa está en la Región Metropolitana y el alcance confirmado
de los traslados va desde La Serena hasta Chillán. El mapa resalta las regiones
del recorrido; no representa atención completa de todas sus localidades.

## Vista local

Abrir `prueba.html` en un navegador. Los recursos están en `Media/`.
El formulario es una demostración: no calcula tarifas ni envía o guarda datos.

## Preparar la publicación

Se necesita Node.js 22 o posterior, sin instalar dependencias.

```sh
node scripts/build-pages.mjs
```

El comando prepara `_site/index.html`, una copia compatible en
`_site/prueba.html` y los recursos que usa la página. `_site/` no se versiona.
Los documentos internos y scripts de generación de mapas no se incorporan
al sitio publicado.

## GitHub Pages

Repositorio público: [Bulmak/SharkGruas](https://github.com/Bulmak/SharkGruas).
Sitio: [Shark Grúas](https://bulmak.github.io/SharkGruas/).

GitHub Pages usa **Settings → Pages → Source → GitHub Actions**.
El workflow `.github/workflows/pages.yml` está habilitado y prepara y publica la maqueta con
cada push a `main`, y también permite una ejecución manual.
La URL final se obtiene del despliegue de GitHub Pages.

El sitio es público. La maqueta conserva la directiva `noindex, nofollow`
para pedir a los buscadores que no la indexen durante esta etapa.

Esta publicación corresponde a la maqueta estática. Next.js, Supabase,
n8n y el panel de administración pertenecen a etapas posteriores.

## Recursos cartográficos

El mapa regional es una adaptación de
[Mapa de Chile (regiones).svg](https://commons.wikimedia.org/wiki/File:Mapa_de_Chile_(regiones).svg),
por B1mbo / Osmar Valdebenito, con actualización de Ñuble por Janitoalevic.
Licencia: [CC BY-SA 3.0 Chile](https://creativecommons.org/licenses/by-sa/3.0/cl/).
Se modificaron colores, presentación y agrupación regional.

La carpeta conserva recursos anteriores del prototipo, incluido el mapa de
comunas adaptado de
[Comunas de Santiago (nombres).svg](https://commons.wikimedia.org/wiki/File:Comunas_de_Santiago_(nombres).svg),
por Osmar Valdebenito, bajo
[CC BY-SA 2.5](https://creativecommons.org/licenses/by-sa/2.5/).
Ese mapa no se utiliza en la página actual.
