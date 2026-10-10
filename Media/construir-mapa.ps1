$ErrorActionPreference = 'Stop'
$sourcePath = Join-Path $PSScriptRoot 'comunas-original.svg'
[xml]$source = Get-Content -LiteralPath $sourcePath -Raw -Encoding UTF8
$ns = 'http://www.w3.org/2000/svg'
$map = New-Object System.Xml.XmlDocument
$svg = $map.CreateElement('svg', $ns)
$svg.SetAttribute('viewBox', '0 0 550 550')
$svg.SetAttribute('role', 'img')
$svg.SetAttribute('aria-labelledby', 'map-title map-desc')
$svg.SetAttribute('class', 'commune-map')
[void]$map.AppendChild($svg)
foreach ($entry in @(@('title','map-title','Comunas del Gran Santiago'), @('desc','map-desc','Mapa de referencia. Azul oscuro: cobertura sin confirmar. Amarillo: cobertura confirmada.'))) {
  $element = $map.CreateElement($entry[0], $ns)
  $element.SetAttribute('id', $entry[1]); $element.InnerText = $entry[2]
  [void]$svg.AppendChild($element)
}
$style = $map.CreateElement('style', $ns)
$style.InnerText = '.commune path{fill:#101d2b;stroke:#91a6b8;stroke-width:0.7;stroke-linejoin:round}.commune text{fill:#fff;font-family:Arial,sans-serif;font-size:9px;text-anchor:middle;pointer-events:none}.commune.covered path{fill:#ffe000;stroke:#101d2b}.commune.covered text{fill:#101d2b}.commune:focus{outline:none}.commune:focus path,.commune:hover path{stroke:#397db5;stroke-width:2}'
[void]$svg.AppendChild($style)
$paths = $source.SelectNodes('//*[local-name()="path"]')
$texts = $source.SelectNodes('//*[local-name()="text"]')
foreach ($path in $paths) {
  $name = $path.GetAttribute('id')
  $group = $map.CreateElement('g', $ns)
  $group.SetAttribute('class','commune'); $group.SetAttribute('data-commune',$name)
  $group.SetAttribute('tabindex','0'); $group.SetAttribute('role','group'); $group.SetAttribute('aria-label', $name + ': cobertura sin confirmar')
  $title = $map.CreateElement('title', $ns); $title.InnerText = $name + ': cobertura sin confirmar'
  [void]$group.AppendChild($title)
  $shape = $map.CreateElement('path', $ns); $shape.SetAttribute('d',$path.GetAttribute('d'))
  [void]$group.AppendChild($shape)
  $label = @($texts | Where-Object { ($_.InnerText -replace '\s','') -eq ($name -replace '\s','') })
  if ($label.Count -ne 1) { throw "Etiqueta no encontrada: $name" }
  $text = $map.CreateElement('text', $ns)
  $text.SetAttribute('x',$label[0].GetAttribute('x')); $text.SetAttribute('y',$label[0].GetAttribute('y'))
  foreach ($span in $label[0].ChildNodes) {
    if ($span.LocalName -eq 'tspan') {
      $newSpan = $map.CreateElement('tspan',$ns)
      $newSpan.SetAttribute('x',$span.GetAttribute('x')); $newSpan.SetAttribute('y',$span.GetAttribute('y'))
      $newSpan.InnerText = $span.InnerText; [void]$text.AppendChild($newSpan)
    }
  }
  [void]$group.AppendChild($text); [void]$svg.AppendChild($group)
}
$metadata = $map.CreateElement('metadata',$ns)
$metadata.InnerText = 'Adaptación cromática y agrupación por comuna de Comunas de Santiago (nombres).svg, Osmar Valdebenito, Wikimedia Commons. CC BY-SA 2.5. https://commons.wikimedia.org/wiki/File:Comunas_de_Santiago_(nombres).svg https://creativecommons.org/licenses/by-sa/2.5/'
[void]$svg.AppendChild($metadata)
$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot 'comunas-santiago.svg'), $map.OuterXml, $utf8)
$htmlPath = Join-Path (Split-Path $PSScriptRoot -Parent) 'prueba.html'
$html = [System.IO.File]::ReadAllText($htmlPath)
$inline = '<!-- MAPA VECTORIAL INICIO -->' + $map.OuterXml + '<!-- MAPA VECTORIAL FIN -->'
if ($html.Contains('<!-- MAPA VECTORIAL INICIO -->')) {
  $html = [regex]::Replace($html,'(?s)<!-- MAPA VECTORIAL INICIO -->.*?<!-- MAPA VECTORIAL FIN -->', [System.Text.RegularExpressions.MatchEvaluator]{param($match) $inline})
} else {
  $html = [regex]::Replace($html,'<img src="Media/comunas-santiago.webp"[^>]*>', [System.Text.RegularExpressions.MatchEvaluator]{param($match) $inline})
}
[System.IO.File]::WriteAllText($htmlPath,$html,$utf8)
Write-Output "Mapa generado: $($paths.Count) comunas con etiquetas y geometrías originales."
