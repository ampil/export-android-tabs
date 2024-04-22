# export-android-tabs

A PowerShell tool to export open tabs in a Chrome browser on an Android phone to a computer on Windows. Output tabs in JSON and CSV formats.


## Prerequisites

* Windows computer with PowerShell installed (installed by default starting with Windows 7 SP1 and Windows Server 2008 R2 SP1)
* [Android Debug Bridge](https://developer.android.com/studio/releases/platform-tools)
  (platform tools including the `adb` executable, ~6 Mb)
* [Google Chrome Browser](https://play.google.com/store/apps/details?id=com.android.chrome) on the phone
* USB debugging enabled on your device (no root required)

Connect an Android phone to a Windows PC and open the Chrome browser on the phone. While connected you may need to tap "OK" on your phone to make it trusted.


## Usage

Open `export-android-tabs.ps1` in a text editor (i.e. [Notepad++](https://notepad-plus-plus.org/downloads/)) and modify paths:
* to the output folder where to store a file with tabs. That's a variable `$outFolder`
* (optional) path to `adb.exe`. That's a variable `$pathToADB` (_the script downloads it if not found in the location specified_)
* (optional) name of the output files: `$pathToJsonFile` and `$pathToOutputFile`

Then save and run the script or copy-paste the script contents to the PowerShell window.


After the script is executed, you will get two files:

* `tabs [datetime].json` file with information about all your tabs in a raw JSON format.
* `tabs [datetime].csv` file you can open in Excel or any other spreadsheet processing software.


## Notes

The script has an `-Encoding utf8` parameter which is critical to properly read UTF8 symbols from the `title` field in the JSON file. These are umlauts `ä ö ü`, accents `é â ê`, cyrillic `привет`, etc.

On my phone (Xiaomi 11T), the script is working while the phone is locked. But you may need to keep it unlocked with active Chrome browser on the screen.


## Credit

This script was inspired by this [StackExchange answer and following comments](https://android.stackexchange.com/a/199496).
