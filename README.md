# Compare-two-CSV  (WIP)

Okay so, three things:

1. Welcome :)
2. Im *not* a professional, so the code is not perfect
3. The Script (var, methods etc.) are in german because i am so yeah....

About the Script:
------------------
We (Me & three friends) had to create this for a project work at our school. 

*Functionality:*  

SHORT:
* When calling the script it has to be fed w/ two CSV-Files (See "Run Script")
* The script finds redundant addresses in a CSV2 based on a CSV1 and will write these adresses in to a new CSV
* If CSV2 contains Addresses which are NOT in CSV1, idk the scipt might ignore them or throw a error
* *IMPORTANT*: You have to either rename all the var's in the Script to match your CSV's or the other way around (They have to be in the correct order to compare them!)
* Everything is coded and (beautifully) commented in german (If you reeeaaalllyyy need a english version I can make you one)

LONG:
When calling the Script you can feed it with two CSV-Files (See "Run Script"), which will then be compared. We had two CSV's which both contained 9999 Adresses. In CSV1 all addresses were unique, on CSV2 *not*. The Script then compared the two Files and generates a CSV3 were all redundant addresses from CSV2 are listed (based on the CSV1).

THIS MEANS:  
* This script is only to find redundandt adresses in a second CSV
* If CSV2 contains Addresses which are NOT in CSV1, idk the scipt might ignore them or throw a error
