# run in PowerShell while a phone is connected and Chrome is open on the phone

# based on the SO anwsers:
# get a list of tabs:    https://android.stackexchange.com/a/199496
# convert JSON to CSV :  https://stackoverflow.com/a/43595214
# with proper encoding:  https://stackoverflow.com/a/66136255


# prereqiusites: 
# 1) get the ADB - you can do that by downloading and extracting the package from Google [5.84 MB]:  https://developer.android.com/studio/releases/platform-tools
# 2) USB debugging enabled on your device (no root required)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#STAGE 1 - PATH
#to ADB folder
$pathToADB = "C:\platform-tools"

#to folder where to store tabs
$pathToFiles = "E:\Clouds\OneDrive\Devices\11T"

#name of the export file
$nameTabs = "tabs"

#full path to JSON and CSV
$pathToJsonFile = $pathToFiles + "\" + $nameTabs + ".json"
$pathToOutputFile = $pathToFiles + "\" + $nameTabs + ".csv"



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#STAGE 2 - GET
#get a list of tabs from the phone
$pathToADB + ".\adb.exe forward tcp:9222 localabstract:chrome_devtools_remote"
wget -O $pathToJsonFile http://localhost:9222/json/list


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#STAGE 3 - CONVERT
#convert JSON to CSV with proper encoding for Cyrillic, German, French, etc.
((Get-Content -Encoding utf8 -Path $pathToJsonFile -Raw) | ConvertFrom-Json) | Export-CSV $pathToOutputFile -NoTypeInformation -Encoding utf8

