 
DO (GETENV("userprofile") + "\Kawix\Shide\interop")

local AdmZip

AdmZip = _screen.nodeinterop.loadRemoteLibrary("gh+/FoxShell/admzip/src/admzip.prg|admzip-0.0.1")


* create new File 

local zip

* without parameter create new zip file in memory
zip = AdmZip.get()
zip.addFile("readme", "ADM ZIP for VFP Rocks!")
zip.addFile("nested/file", "This is a nested file")

* write ZIP to file
local file
file = getfile("zip")

WAIT "Saving ZIP file" WINDOW TIMEOUT 2
zip.writeZip(m.file)

* free memory
zip.destroy()



* now read file ...

WAIT "Reading ZIP file" WINDOW TIMEOUT 2
zip = AdmZip.get(m.file)

* get entries and list in screen
local entries
entries = zip.getEntries()
for each entry in entries
  ? entry.entryName
  ? entry.comment
endfor 

* extract all data to folder
local folder
folder = getdir()

WAIT "extracting to folder" WINDOW TIMEOUT 2
zip.extractAllTo(folder  + "\extracted", .t.)

* free memory
zip.destroy()





