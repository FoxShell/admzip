# admzip
Manipulate zip files. Adm-zip like project for VFP.


## Import library

Import FoxShell/Shide: [https://github.com/FoxShell/shide](https://github.com/FoxShell/shide#import-shide-in-your-project)

That's all, you are ready to use. See the examples


## Usage

This project is inspirated on [https://github.com/cthackers/adm-zip/wiki/ADM-ZIP](https://github.com/cthackers/adm-zip/wiki/ADM-ZIP)

Create a zip file is very easy
```harbour

* load library
DO (GETENV("userprofile") + "\Kawix\Shide\interop")
local AdmZip
AdmZip = _screen.nodeinterop.loadRemoteLibrary("gh+/FoxShell/admzip/src/admzip.prg|admzip-0.0.1")


* create new File 

local zip

* without parameter create new zip file in memory
zip = AdmZip.get()
zip.addFile("readme", "ADM ZIP for VFP Rocks!")
zip.addFile("directory/file", "This is a file inside directory")
zip.writeZip("c:/path/to/save.zip")
* free memory
zip.destroy()
```

Please see the full example: [adm-zip.js](./examples/zip-create-read.prg). 


# Documentation

You are welcome to help us improve the documentation. If you know how works [adm-zip.js](./examples/zip-create-read.prg) you can understand how works this.
ONly there are few changes: 

- This project don't have ```readFile``` or ```readAsText``` methods. Instead have a ```read``` method
- All buffers value/parameters in adm-zip.js are replaced by ```string``` in this project (latin1 encoding)
- You should call ```destroy``` for free memory used in creating/reading files



### zipStatic class 


```typescript 
zipStatic#get(path?: string) : zipFile
```

Return a new zipFile object. Created in memory if not parameter, or read if file exists



### zipFile class

```typescript
zipFile#getEntries() : Array<zipEntry>
```

Return the entries of zip file


```typescript 
zipFile#getEntry(name: string) : ZipEntry
```

Return the entry by name


```typescript 
zipFile#read(entry: zipEntry) : string
```

Read an entry



```typescript
zipFile#deleteFile(entry: zipEntry) : void
```

Delete an entry file


```typescript
zipFile#addZipComment(comment: string) : void
```

Add a comment to zip file


```typescript
zipFile#getZipComment() : string
```

Return the zip file comment


```typescript 
zipFile#addZipEntryComment(entry: zipEntry, comment: string) : void
```

Add a comment for entry 


```typescript
zipFile#getZipEntryComment(entry: zipEntry) : string
```

Return the comment for a zip entry 


```typescript
zipFile#updateFile(entry: zipEntry, content: string) : void
```

Update the entry file content


```typescript 
zipFile#addLocalFile(localPath: string, zipPath: string) : void
```

Adds a local file to zip file


```typescript
zipFile#addLocalFolder(localPath: string, zipPath: string) : void
```

Add a local folder to zip file


```typescript 
zipFile#addFile(entryName: string, content: string, comment?: string, attr?: number) : void
```

Add a new file to zip. Comment and attr are optional


```typescript 
zipFile#extractEntryTo(entry: zipEntry, path: string, preserveFullPath?: boolean = false, overwrite?: boolean = true ) : void
```

Extract an entry to file. 


```typescript
zipFile#extractAllTo(path: string, overwrite?: boolean = true ) : void
```

Extract all files from zip to folder


```typescript
zipFile#writeZip(path?: string) : void
```

Write zip file to disk. If no parameter passed used from passed to ```zipStatic#get```


```typescript
zipFile#destroy() : void
```

Free memory used for zip creation/reading.



### zipEntry class

```typescript
zipEntry#attr : number
```
Attr for entry


```typescript
zipEntry#comment : string
```
Comment for entry. Empty if not present


```typescript
zipEntry#entryName : string
``` 
Full path name in zip file for entry














