 
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
file = getfile(".zip")

zip.writeZip(m.filetowrite)



* now read file ...

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

zip.extractAllTo(folder, .t.)








