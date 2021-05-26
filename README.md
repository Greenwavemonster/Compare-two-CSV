# Compare-two-CSV / PowerShell

Okay so, three things:

1. Welcome :)
2. Im *not* a professional, so the code is not perfect
3. The script (var, methods etc.) are in german because I am so yeah....

About the PowerShell-Script:
------------------
We (me & three friends) had to create this for a project work at our school. 

*Functionality:*  

SHORT:
* When calling the script it has to be fed w/ two CSV-Files (See "Run Script")
* The script is designed to compare address lists
* The script will compare CSV2 against CSV1 and write all the REDUNDANT adresses into CSV3
* If CSV2 contains Addresses which are NOT in CSV1, idk the script will probably ignore them or throw a error
* *IMPORTANT*: You have to either rename all the var's in the Script to match your CSV's or the other way around (They have to be in the correct order to compare them!)
* Everything is coded and (beautifully) commented in german (If you reeeaaalllyyy need a english version I can make you one)

LONG:
When calling the Script you can feed it with two CSV-Files (See "Run Script"), which will then be compared. We had two CSV's which both contained 9999 Adresses. In CSV1 all addresses were unique, on CSV2 *not*. The Script then compared the two Files and generates a CSV3 were all redundant addresses from CSV2 are listed (based on the CSV1).
It does it by first comparing the First- and Familyname. If these Match, it compares the addresses etc., if these all match, the row gets stored in a Array.
When finished all the comparing, it recompared the array with the array itself but we added a counter. 
The first time a match happens, it checks if the counter is 0: If YES, the counter gets incremented by 1. If NO (counter is allready incremented), the row gets written in a new Array. This helps us eliminating all rows that only match once (since we only want the redundant data). 
At last this new array get exported with the parameter "unique" in to a new CSV-File.
Magic done :)

THIS MEANS:  
* This script is only to find redundandt adresses in a second CSV
* If CSV2 contains Addresses which are NOT in CSV1, idk the scipt might ignore them or throw a error

*Run Script:* 
Following examples show how to run the script:

NOTE: 
* Leave "-Datei1" & "-Datei2" as they are because these are the var names in wich the CSV-Path is stored! ("Datei" is german the word for "File")
* "-ResultatCSV <name>" Is not mandatory. If you want you can rename the output CSV, otherwise it will be called "Compare-Output"
* Again check that the CSV rows match the scripts var's
  
Here the Lines:  
* .\Compare-two-CSV.ps1 -Datei1 'CSV1-File-Name' -Datei2 'CSV2-File-Name'
* .\Compare-two-CSV.ps1 -Datei1 'CSV1-File-Name' -Datei2 'CSV2-File-Name' -ResultatCSV 'Name'
* .\Compare-two-CSV.ps1 - Datei1 'C:\Path\to\your\File1.csv' - Datei2 'C:\Path\to\your\File2.csv' -ResultatCSV 'C:\Path\to\store\Output.csv'
