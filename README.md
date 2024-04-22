# export-android-tabs

`export-android-tabs` is a PowerShell tool to export open tabs in a Chrome browser on an Android phone to a computer on Windows. Saves tabs in JSON and CSV formats.


## Prerequisites

* enabled USB debugging on your Android device
* Windows computer with PowerShell (installed by default starting with Windows 7 SP1 and Windows Server 2008 R2 SP1)
* Installed [Google Chrome Browser](https://play.google.com/store/apps/details?id=com.android.chrome) of course
* _*_ [Android Debug Bridge](https://developer.android.com/studio/releases/platform-tools)
  (we need the minimal version - the platform tools ~6 Mb. It has the `adb.exe` executable)
* ! **no** root required !

Connect an Android phone to a Windows PC. While connected you may need to tap "OK" on your phone to make the connection trusted between your PC and the phone.  
_*_ ADB will be downloaded and extracted during script execution if you don't have it locally.


## Usage

Open `export-android-tabs.ps1` in a text editor (i.e. [Notepad++](https://notepad-plus-plus.org/downloads/)) and modify paths:
* to the output folder where to store a file with tabs: variable `$outFolder`
* (_optional_) path to `adb.exe`: variable `$pathToADB` (_the script downloads it if not found at the location specified_)
* (_optional_) names of the output files: `$pathToJsonFile` and `$pathToOutputFile`

Then save and run the script and execute it in PowerShell or copy-paste script contents to the PowerShell window.


After the script is executed, you will get two files:
* `tabs [datetime].json` with information about all your tabs in a raw JSON format.
* `tabs [datetime].csv` suitable for Excel or any other spreadsheet processing software.


## Example output
The output in a JSON file has the following fields (with sample values):
* "description": ""
* "devtoolsFrontendUrl": "https://chrome-devtools-frontend.appspot.com/serve_internal_file/@6aa76cc02752c25ffead4a19a03e13cdda08db6a/inspector.html?ws=localhost:9223/devtools/page/19939",
* "id": "19939",
* "title": "Удачный переход Netflix на GraphQL / Хабр",
* "type": "page",
* "url": "https://habr.com/ru/companies/otus/articles/785672/",
* "webSocketDebuggerUrl": "ws://localhost:9223/devtools/page/19939"
![image](https://github.com/ampil/export-android-tabs/assets/33726853/0766031a-0641-461e-a282-7649601f40ac)

Basically, we need `title` and `url`.


## Notes

The script has an `-Encoding utf8` parameter which is critical to properly read UTF8 symbols from the `title` field in the JSON file. These are umlauts `ä ö ü`, accents `é â ê`, cyrillic `привет`, etc.

On my phone (Xiaomi 11T), the script is working while the phone is locked. But you may need to keep it unlocked with active Chrome browser on the screen.


## Credit

This script was inspired by this [StackExchange answer and following comments](https://android.stackexchange.com/a/199496).
