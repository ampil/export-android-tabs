
# export-android-tabs

`export-android-tabs` is a PowerShell script that exports open tabs from Google Chrome on an Android device to a Windows computer, producing both JSON and CSV outputs for easy analysis in Excel or BI tools.

## Features

* Export currently open Chrome tabs from Android to JSON and CSV on Windows, suitable for spreadsheets and automation pipelines.
* Automatic download and extraction of Android Platform Tools if not already installed locally; **root is not required**.
* Graceful error handling when Chrome isn’t open on the device, with a clear prompt to open it and retry.


## Prerequisites

* USB debugging enabled on the Android device and the computer marked as trusted when prompted.
* Windows with PowerShell available (included since Windows 7 SP1 / Windows Server 2008 R2 SP1).
* [Google Chrome Browser](https://play.google.com/store/apps/details?id=com.android.chrome) open on the device.
* [Android Debug Bridge (ADB)](https://developer.android.com/studio/releases/platform-tools) from Android Platform Tools (~6 MB). If not found, the script will download it automatically during execution.


## Quick start

1. Connect the Android phone to the Windows PC via USB and ensure Chrome is open on the device.
2. Open `export-android-tabs.ps1` in an editor and configure:
    * Output folder: `$outFolder`.
    * (_optional_) ADB path: `$pathToADB` (the script downloads ADB if not found at the path).
    * (_optional_) output names: `$pathToJsonFile` and `$pathToOutputFile`.
3. Run the script in PowerShell (for example, from the script directory): `./export-android-tabs.ps1`.

## Output

* `tabs [datetime].json`: raw DevTools tab list, including title and url fields.
* `tabs [datetime].csv`: a flat table suitable for Excel and other spreadsheet software.


## Example JSON fields

* "description": ""
* "devtoolsFrontendUrl": "https://chrome-devtools-frontend.appspot.com/serve_internal_file/@6aa76cc02752c25ffead4a19a03e13cdda08db6a/inspector.html?ws=localhost:9223/devtools/page/19939",
* "id": "19939",
* "title": "Удачный переход Netflix на GraphQL / Хабр",
* "type": "page",
* "url": "https://habr.com/ru/companies/otus/articles/785672/",
* "webSocketDebuggerUrl": "ws://localhost:9223/devtools/page/19939"
![image](https://github.com/ampil/export-android-tabs/assets/33726853/0766031a-0641-461e-a282-7649601f40ac)


## Encoding notes

The script uses UTF‑8 when reading and writing, ensuring correct handling of umlauts (`ä`, `ö`, `ü`), accents (`é`, `â`, `ê`), and Cyrillic (`привет`) in tab titles and URLs.

## Behavior and device notes

On some devices (e.g., Xiaomi 11T) export may work with the screen locked, but keeping Chrome active on the device generally yields more reliable results.

## Troubleshooting

- Script prints “Chrome should be opened on your device. Is it now?” and exits gracefully:
    - Open Chrome on the device and rerun the script.
- Device not listed as “device” in adb devices:
    - Reconnect USB and confirm the RSA trust prompt on the phone; ensure USB debugging is enabled.
- CSV looks empty or shows wrong characters:
    - Verify write access to `$outFolder` and ensure Excel is correctly opening a CSV encoded with UTF-8.


## Credits

Inspired by a StackExchange answer and subsequent discussion; direct references are linked in the script comments.
