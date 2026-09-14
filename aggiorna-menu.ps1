$ErrorActionPreference = 'Stop'

$startMarker = '<!-- BEGIN MENU -->'
$endMarker = '<!-- END MENU -->'
$pattern = [regex]::Escape($startMarker) + '.*?' + [regex]::Escape($endMarker)
$menuPattern = [regex]::new($pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

$newMenu = @'
<!-- BEGIN MENU -->
<button class="menu-toggle" aria-controls="menu" aria-expanded="false" onclick="toggleMenu()">&#9776; Menu</button>
<div class="sidebar" id="menu">
  <h2>Menu Lezioni</h2>
  <ul>
    <li><a href="lez1/lez1_1.html">Lezione 1 — Problemi, algoritmi e storia</a></li>
    <li><a href="lez2/lez2_1.html">Lezione 2 — Diagrammi e pseudocodice</a></li>
    <li><a href="lez3/lez3_1.html">Lezione 3 — Selezione</a></li>
    <li><a href="lez4/lez4_1.html">Lezione 4 — Cicli</a></li>
    <li><a href="lez5/lez5_1.html">Lezione 5 — Array</a></li>
    <li><a href="lez6/lez6_1.html">Lezione 6 — C e C++</a></li>
  </ul>
</div>
<!-- END MENU -->
'@

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$encoding = New-Object System.Text.UTF8Encoding $false

foreach ($name in 'index.html', 'programma.html', 'raccomandazioni.html', 'impatto-ai.html') {
    $path = Join-Path $scriptDir $name
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    if (-not $menuPattern.IsMatch($content)) {
        throw "Blocco menu non trovato in $name"
    }
    $updated = $menuPattern.Replace($content, $newMenu, 1)
    [System.IO.File]::WriteAllText($path, $updated, $encoding)
    Write-Host "Menu aggiornato in $name"
}
