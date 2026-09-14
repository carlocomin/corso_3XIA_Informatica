$ErrorActionPreference = 'Stop'

$startMarker = '<!-- BEGIN MENU -->'
$endMarker = '<!-- END MENU -->'
$pattern = [regex]::Escape($startMarker) + '.*?' + [regex]::Escape($endMarker)
$menuPattern = [regex]::new($pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

$newMenu = @'
<!-- BEGIN MENU -->
<button class="menu-toggle" aria-controls="menu" aria-expanded="false" onclick="toggleMenu()">&#9776; Menu</button>
<div class="sidebar" id="menu">
  <h2>Menu Lezione 1</h2>
  <ul>
    <li><a href="lez1_1.html">1.1 — Il concetto di problema</a></li>
    <li><a href="lez1_2.html">1.2 — Il problema del contadino</a></li>
    <li><a href="lez1_3.html">1.3 — Il problema della bilancia</a></li>
    <li><a href="lez1_4.html">1.4 — Il concetto di algoritmo</a></li>
    <li><a href="lez1_5.html">1.5 — Verifica delle competenze</a></li>
  </ul>
</div>
<!-- END MENU -->
'@

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$encoding = New-Object System.Text.UTF8Encoding $false

Get-ChildItem -LiteralPath $scriptDir -Filter 'lez1_*.html' | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    if (-not $menuPattern.IsMatch($content)) {
        throw "Blocco menu non trovato in $($_.Name)"
    }
    $updated = $menuPattern.Replace($content, $newMenu, 1)
    [System.IO.File]::WriteAllText($_.FullName, $updated, $encoding)
    Write-Host "Menu aggiornato in $($_.Name)"
}
