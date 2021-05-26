<#
  
	SCRIPT AUFRUF IN PS:
	.\Compare-two-CSV.ps1 -Datei1 <Name> -Datei2 <Name> -ResultatCSV <Name> 
	Die Namen müssen Strings sein und man muss im selben Verzeichnis sein wie das Skript.
	
	Beispiele:
	.\Compare-two-CSV.ps1 -Datei1 "Mappe1.csv" -Datei2 "Mappe2.csv" -ResultatCSV "Mappe3.csv"
	.\Compare-two-CSV.ps1 -Datei1 "C:\Pfad\zur\CSV\Mappe1.csv" -Datei2 "C:\Pfad\zur\CSV\Mappe2.csv" -ResultatCSV "C:\Pfad\zur\Datei\Mappe3.csv"
#>


param (
    [parameter(Mandatory=$true)]
    [String] $Datei1,
    [parameter(Mandatory=$true)]
    [String] $Datei2,
    [String] $ResultatCSV = "Compare-Output"

)

$CSV1Import = Import-CSV -delimiter ";" -path $Datei1
$CSV2Import = Import-CSV -delimiter ";" -path $Datei2

<#
	Oben werden die Parameter definiert, wobei [String] besagt, sie MÜSSEN ein String sein und [Mandatory=$true] "zwingt" den User Parameter einzugeben.
	Mit Import-CSV wird der Inhalt in PowerShell geladen, damit er verwendet werden kann.

	QUELLEN:
		- https://www.youtube.com/watch?v=6ySxsnOGnCU (zuletzt besucht: 03.01.2021)
		- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-csv?view=powershell-7.1 (zuletzt besucht: 03.01.2021)
#>


function vergleichen 
{
  param(
    [OBJECT] $mitgabe1,
    [OBJECT] $mitgabe2
  )
    if (
        ($mitgabe1.strasse -eq $mitgabe2.strasse) -and
        ($mitgabe1.'Hausnr.' -eq $mitgabe2.'Hausnr.') -and
        ($mitgabe1.PLZ -eq $mitgabe2.PLZ) -and
        ($mitgabe1.Ort -eq $mitgabe2.Ort) -and
        ($mitgabe1.'Telefon 1' -eq $mitgabe2.'Telefon 1')
       )
    {
      return $true 
    }
  return $false
}

<#
	Zuerst haben wir bei beiden CSV-Dateien immer alle Spalten verglichen. Jedoch brauchte das Skript dadurch viel zu lange, wodurch wir eine Methode erstellt haben, welche nur aufgerufen wird, wenn Vor- und Nachname übereinstimmen (s. weiter unten im Skript).
	In dieser Funktion werden zwei Parameter definiert, welche bei Aufruf weiter unten im Skript mit Daten befüllt werden (ganze Zeile aus dem CSV).
	
    Danach werden diese zwei mitgegebenen CSV Zeilen auf die Übereinstimmung von Strasse, Hausnummer usw. geprüft.
	Stimmen alle überein, wir das If-Statement erfüllt und der Wert „True“ zurückgeliefert. Ansonsten wird der Wert „False“ zurückgeliefert.
#>



$Matches = @()
#Erstellen eines Arrays

foreach ($zeileCSV1 in $CSV1Import) 
{
  foreach ($zeileCSV2 in $CSV2Import) 
  {
    if (($zeileCSV1.vorname -eq $zeileCSV2.vorname) -and ($zeileCSV1.name -eq $zeileCSV2.name)) 
    {
      if (vergleichen -mitgabe1 $zeileCSV1 -mitgabe2 $zeileCSV2) 
      {
        $Matches += $zeileCSV1
 
      }

    }
  }
  
}

<#
	In dieser doppelten Foreach-Schleife werden die CSV-Dateien verglichen.
	Es wird jeweils die erste Zeile aus dem ersten CSV genommen (erste Foreach) und dann mit ALLEN Zeilen aus dem zweiten CSV verglichen (zweite Foreach).
	
    Dabei wird zuerst nur der Vor- und Nachname überprüft. Stimmen diese überein wird die obere Funktion aufgerufen, damit der Rest auch verglichen wird.
 	Wird „True“ zurück geliefert, so wird ein Eintrag in das „Matches“ Array (oben definiert) erstellt.

	QUELLE: 
 		- https://adamtheautomator.com/powershell-import-csv-foreach/ (Foreach-Schleifen mit Arrays nutzen (CSV)) (zuletzt besucht: 03.01.2021)
#>



$Doppelt = @()

foreach ($zeile1 in $Matches) 
{
  $zaehler = 0
  foreach ($zeile2 in $Matches) 
  {
    if (($zeile1.vorname -eq $zeile2.vorname) -and ($zeile1.name -eq $zeile2.name)) 
    {
      if (vergleichen -mitgabe1 $zeile1 -mitgabe2 $zeile2) 
      {
        if ($zaehler -gt 0) 
        {
          $Doppelt += $zeile1
        }
        
        $zaehler += 1
      }
    }

  }
}

<#
	Im Matches Array sind alle redundanten Datensätze aus den beiden CSV-Dateien. Um die Doppelten zu finden vergleichen wir lediglich das Array mit sich selbst.
	Es wird dasselbe gemacht, wie in der oberen Foreach-Schleife, nur haben wir noch einen Zähler eingebaut, damit Datensätze, die nur einmal vorkommen, nicht in das neue Array „Doppelt“ gespeichert werden. Somit haben wir nur noch jene übrig, die mehr als einmal vorkommen.
#>


$Doppelt | Sort-Object Vorname,Name,Strasse,PLZ,Ort,'Hausnr.','Telefon 1' -Unique | Export-Csv -path $ResultatCSV -notypeinformation -delimiter ";" -encoding utf8

<#

	Das „Doppelt“ Array wird mit Sort-Object sortiert und dann exportiert. Dabei wird mit „-Unique“ noch geschaut, dass jeder Datensatz ein Unikat ist und nicht doppelt vorkommt.

	QUELLE:
		- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv?view=powershell-7.1 (Export-CVS) (zuletzt Besucht: 03.01.2021)
		- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/sort-object?view=powershell-7.1 (Sort-Object) (zuletzt Besucht: 03.01.2021)
#>



$uniqueHits = Import-CSV -delimiter ";" -path $ResultatCSV

write-host ("Es wurden {0} Eintraege gefunden die mehrfach vorkommen." -f $Doppelt.count)
write-host ("Davon sind {0} einzigartig." -f $uniqueHits.count)

<#
	Damit wir (oder auch ein User) nicht jedes Mal das CSV manuell öffnen müssen, zum Schauen wie viele Datensätze vorkommen, haben wir das neu erstellte CSV nochmals importiert und dann mittels „count“ die Anzahl Datensätze darin gezählt.
#>


