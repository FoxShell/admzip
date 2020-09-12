# admzip
Manipulate zip files. Adm-zip like project for VFP.


## Import library

Import FoxShell/Shide: [https://github.com/FoxShell/shide](https://github.com/FoxShell/shide#import-shide-in-your-project)

That's all, you are ready to use. See the examples


## Usage

This project is inspirated on [https://github.com/cthackers/adm-zip/wiki/ADM-ZIP](https://github.com/cthackers/adm-zip/wiki/ADM-ZIP)

Create a zip file is very easy
```dbase

* load 
DO (GETENV("userprofile") + "\Kawix\Shide\interop")
local AdmZip
AdmZip = _screen.nodeinterop.loadRemoteLibrary("gh+/FoxShell/admzip/src/admzip.prg|admzip-0.0.1")


* create new File 

local zip

* without parameter create new zip file in memory
zip = AdmZip.get()
zip.addFile("readme", "ADM ZIP for VFP Rocks!")
zip.addFile("nested/file", "This is a nested file")
zip.writeZip("c:/path/to/save.zip")
* free memory
zip.destroy()
```

Please see the full example: [examples/zip-create-read.prg](./examples/zip-create-read.prg). 

