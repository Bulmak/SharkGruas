$ErrorActionPreference = 'Stop'
[xml]$source = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'regiones-original.svg') -Raw -Encoding UTF8
$regions = @(
  @('arica','Arica y Parinacota','Region_Arica_Parinacota',$false),
  @('tarapaca','Tarapacá','Region_Tarapaca',$false),
  @('antofagasta','Antofagasta','Region_Antofagasta',$false),
  @('atacama','Atacama','Region_Atacama',$false),
  @('coquimbo','Coquimbo','Region_Coquimbo',$true),
  @('valparaiso','Valparaíso','Region_Valparaiso',$true),
  @('metropolitana','Metropolitana','Region_Metropolitana',$true),
  @('ohiggins',"O'Higgins",'Region_OHiggins',$true),
  @('maule','Maule','Region_Maule',$true),
  @('nuble','Ñuble','Nuble-9',$true),
  @('biobio','Biobío','Biobio-4',$false),
  @('araucania','La Araucanía','Region_Araucania',$false),
  @('los-rios','Los Ríos','Region_Los_Rios',$false),
  @('los-lagos','Los Lagos','Region_Los_Lagos',$false),
  @('aysen','Aysén','Region_Aisen',$false),
  @('magallanes','Magallanes','Region_Magallanes',$false)
)
$ns = 'http://www.w3.org/2000/svg'
$doc = New-Object System.Xml.XmlDocument
$svg = $doc.CreateElement('svg',$ns)
$svg.SetAttribute('viewBox','0 0 400 2000')
$svg.SetAttribute('class','regions-svg')
$svg.SetAttribute('role','img')
$svg.SetAttribute('aria-labelledby','regions-title regions-description')
[void]$doc.AppendChild($svg)
foreach ($item in @(@('title','regions-title','Chile por regiones'),@('desc','regions-description','Mapa de referencia. Amarillo: regiones del recorrido entre La Serena y Chillán. Azul oscuro: fuera del recorrido indicado. El alcance está delimitado por estas ciudades, no por la totalidad de cada región.'))) {
  $el = $doc.CreateElement($item[0],$ns); $el.SetAttribute('id',$item[1]); $el.InnerText=$item[2]; [void]$svg.AppendChild($el)
}
$style = $doc.CreateElement('style',$ns)
$style.InnerText='.region path{fill:#101d2b;stroke:#fff;stroke-width:2;stroke-linejoin:round}.region.proposed path{fill:#ffe000}.region.is-highlighted path{stroke:#397db5;stroke-width:5}'
[void]$svg.AppendChild($style)
$list = New-Object System.Text.StringBuilder
foreach ($region in $regions) {
  $sourceShape=$source.SelectSingleNode('//*[@id="' + $region[2] + '"]')
  if ($null -eq $sourceShape) { throw "No se encontró $($region[1])" }
  $group = $doc.CreateElement('g',$ns)
  $class='region'; if ($region[3]) {$class+=' proposed'}
  $group.SetAttribute('class',$class); $group.SetAttribute('data-region',$region[0])
  $state='Fuera del recorrido indicado'; if ($region[3]) {$state='Región del recorrido entre La Serena y Chillán'}
  $title=$doc.CreateElement('title',$ns); $title.InnerText=$region[1]+': '+$state; [void]$group.AppendChild($title)
  if ($sourceShape.LocalName -eq 'path') {$paths=@($sourceShape)} else {$paths=$sourceShape.SelectNodes('.//*[local-name()="path"]')}
  $count=0
  foreach($path in $paths) {
    # Los recuadros de islas del original no forman parte de esta vista continental.
    if($path.GetAttribute('id').StartsWith('Rect_')){continue}
    $shape=$doc.CreateElement('path',$ns)
    $shape.SetAttribute('d',$path.GetAttribute('d')); $shape.SetAttribute('fill-rule','evenodd')
    [void]$group.AppendChild($shape); $count++
  }
  if ($count -eq 0){throw "No hay geometría para $($region[1])"}
  [void]$svg.AppendChild($group)
  $escaped=[System.Net.WebUtility]::HtmlEncode($region[1])
  $class='region-button'; if($region[3]){$class+=' proposed'}
  [void]$list.Append('<li><button type="button" class="'+$class+'" data-region-name="'+$region[0]+'" data-proposed="'+$region[3].ToString().ToLower()+'" aria-label="'+$escaped+': '+$state+'"><span class="region-dot" aria-hidden="true"></span>'+$escaped+'</button></li>')
}
$meta=$doc.CreateElement('metadata',$ns)
$meta.InnerText='Adaptado de Mapa de Chile (regiones).svg, B1mbo (Osmar Valdebenito), actualización de Ñuble por Janitoalevic. Wikimedia Commons. CC BY-SA 3.0 Chile. https://commons.wikimedia.org/wiki/File:Mapa_de_Chile_(regiones).svg https://creativecommons.org/licenses/by-sa/3.0/cl/ Cambios: colores, selección continental, separación por regiones.'
[void]$svg.AppendChild($meta)
$utf8=New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot 'regiones-chile.svg'),$doc.OuterXml,$utf8)
$htmlPath=Join-Path (Split-Path $PSScriptRoot -Parent) 'prueba.html'
$html=[System.IO.File]::ReadAllText($htmlPath)
$svgInline='<!-- REGIONES SVG INICIO -->'+$doc.OuterXml+'<!-- REGIONES SVG FIN -->'
$listInline='<!-- REGIONES LISTA INICIO -->'+$list.ToString()+'<!-- REGIONES LISTA FIN -->'
$html=[regex]::Replace($html,'(?s)<!-- REGIONES SVG INICIO -->.*?<!-- REGIONES SVG FIN -->',[System.Text.RegularExpressions.MatchEvaluator]{param($match) $svgInline})
$html=[regex]::Replace($html,'(?s)<!-- REGIONES LISTA INICIO -->.*?<!-- REGIONES LISTA FIN -->',[System.Text.RegularExpressions.MatchEvaluator]{param($match) $listInline})
[System.IO.File]::WriteAllText($htmlPath,$html,$utf8)
Write-Output 'Mapa regional generado: 16 regiones, 6 resaltadas como regiones del recorrido.'
