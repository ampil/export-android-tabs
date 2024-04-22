# run in PowerShell while a phone is connected and Chrome is open on the phone

# based on these SO anwsers
# get a list of tabs  :  https://android.stackexchange.com/a/199496
# convert JSON to CSV :  https://stackoverflow.com/a/43595214
# with proper encoding:  https://stackoverflow.com/a/66136255


# prereqiusites: 
# 1) USB debugging enabled on your device (no root required)
# 2) [optional*] download the ADB app from Google and extract it [5.84 MB]:  https://developer.android.com/studio/releases/platform-tools
#    *if it is missing the script will download and unpack it



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#set the folder where to store output files with tabs
$outFolder = "C:\export\11T"



function getAndroidTabs {
	param(
	 [Parameter(mandatory)]     [string]$outFolder
	)
	
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#STAGE 1 - SET VARIABLES
	$ErrorActionPreference = 'Stop'

	#ADB 
	$pathToADB = 'C:\platform-tools\adb.exe'

	#name of the export files
	$formattedDateTime = Get-Date -format "yyyy-MM-dd HH-mm-ss"
	$nameTabs = 'tabs ' + $formattedDateTime

	#full paths of JSON and CSV export files
	$pathToJsonFile = $outFolder + "\" + $nameTabs + ".json"
	$pathToOutputFile = $outFolder + "\" + $nameTabs + ".csv"

	#forwarded link from Android device to this Windows device containing tabs in a JSON format
	$port = '9223'
	$url = "http://localhost:$port/json/list"


	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#STAGE 2 - VALIDATION
	#make sure ADB exists
	If (!(Test-Path -Path $pathToADB)) {
		Write-Warning "ADB is not found. Downloading it"
		
		# downloading
		$urlADB = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
		$pathToDownloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
		Invoke-WebRequest -Uri $urlADB -OutFile "$pathToDownloads\platform-tools.zip"
		
		# extracting to a 2nd parent directory
		Expand-Archive -Path "$pathToDownloads\platform-tools.zip" -DestinationPath (Split-path $pathToADB | split-path) -Force
	}


	# check if USB debugging enabled - read list of devices available to ADB
	$cmdOutput = & $pathToADB devices 
	
	if ($cmdOutput[1].length -gt "device".length) {
		Write-Host "USB debugging enabled. Accessing tabs..."
	} else {
		Write-Warning "USB debugging disabled or phone is not connected! Opeartion aborted. Please connect the phone and turn on USB debugging."
		break
	}

	#make sure the folder to store data exists
	If (!(Test-Path -Path $outFolder)) {
		New-Item -ItemType Directory -Path $outFolder
		Write-Host "Save directory created"
	}



	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#STAGE 3 - GET TABS FROM THE PHONE
	#activate adb
	Write-Host "Activating ADB port forwarding"
	$params = "forward tcp:$port localabstract:chrome_devtools_remote"
	$cmd = "& $pathToADB $params | Write-Verbose"   # with '| Write-Verbose' hide output of the command which is '9223'
	Invoke-Expression $cmd

	# download the list of tabs from the phone as a .json file
	Invoke-WebRequest -Uri $url -OutFile $pathToJsonFile

	#convert JSON to CSV with proper encoding for Cyrillic, German, French, etc.
	if (!(Test-Path $pathToJsonFile)) {
		Write-Warning "Tabs file ('$nameTabs.json') was not downloaded"
	} else {
		((Get-Content -Encoding utf8BOM -Path $pathToJsonFile -Raw) | ConvertFrom-Json) | Export-CSV $pathToOutputFile -NoTypeInformation -Encoding utf8BOM
		
		Write-Host "Completed. Tabs exported to " $outFolder
	}


	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#STAGE 4 - CLEANING UP
	# close adb server and free up the port
	$params = "kill-server"
	$cmd = "& $pathToADB $params"
	Invoke-Expression $cmd

}


# call the function
getAndroidTabs $outFolder