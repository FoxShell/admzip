Lparameters  nodeInterop, libName
if pcount() > 0
	try 
		m.nodeInterop._libs.add(CREATEOBJECT("AdmZipStatic"), m.libName)
	catch to ex 
	endtry 
ENDIF


* Author: Kodhe
SET PROCEDURE TO SYS(16) ADDITIVE 


function __admzip_execute(str)
	local num, id
	id= "admzip.8"
	TRY 	
		num= _screen.nodeinterop._api.item[m.id]	
	CATCH TO ex 	
		num= "-1"	
	ENDTRY     
	IF num == "-1"		
		_Screen.nodeinterop.connect()		
		TEXT TO m.code NOSHOW      
		
		global.ADMZIP = global.ADMZIP || {storage:{},id:0}
		   
		let storage = global.ADMZIP.storage

		
		
		async function module1(){
			
			let AdmZip = await KModule.import("npm://adm-zip@0.4.16")
			let parts = params.split("|")
			if(parts[0] == "0"){
				// create file
				let cid = Date.now() + "-" + (global.ADMZIP.id++)
				if(parts[1]){
					let zip = new AdmZip(parts[1])
					storage[cid]= zip
				}else{
					let zip = new AdmZip()
					storage[cid] = zip 
				}
				return cid 
			}
			
			else if(parts[0] == "1"){

				delete storage[parts[1]]
				return null
			}
			
			else if(parts[0] == "2"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")
				let data = null 
				if(parts[2]){
					let entry = zip.getEntry(parts[2])
					if(!entry) return null
					data= {
						attr: entry.attr,
						comment: entry.comment,
						entryName: entry.entryName,
						isDirectory: entry.isDirectory
					}					
				}
				else{
					data = zip.getEntries().map(function(a){
						return {
							attr: a.attr,
							comment: a.comment,
							entryName: a.entryName,
							isDirectory: a.isDirectory
						}
					})
				}
				return data
			}
			else if(parts[0] == "3"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")

				let entry =zip.getEntry(parts[2])
				return new Promise(function(a,b){
					zip.readFileAsync(entry, function(data){
						//if(err) return b(err)
						a(data.toString('latin1'))
					})
				})
			}
			else if(parts[0] == "4"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")

				let entry =zip.getEntry(parts[2])
				zip.deleteFile(entry)
				return null
			}
			else if(parts[0] == "5"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")

				let c = Buffer.from(parts[2],'base64')
				zip.addZipComment(c.toString('latin1'))
				return null
			}
			else if(parts[0] == "6"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")

				return zip.getZipComment()
			}
			else if(parts[0] == "7"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")

				let c = Buffer.from(parts[3],'base64')
				let entry = zip.getEntry(parts[2])
				zip.addZipEntryComment(entry, c.toString('latin1'))
				return null
			}
			else if(parts[0] == "8"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")
				
				let entry = zip.getEntry(parts[2])
				return zip.getZipEntryComment(entry)
			}
			
			else if(parts[0] == "9"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")
				
				let c = Buffer.from(parts[3],'base64')
				let entry = zip.getEntry(parts[2])
				return zip.updateFile(entry, c)
			}
			
			else if(parts[0] == "10"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")
				
				zip.addLocalFile(parts[2],parts[3])
				return null
			}
			
			else if(parts[0] == "11"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")
				
				zip.addLocalFolder(parts[2],parts[3])
				return null
			}
			
			else if(parts[0] == "12"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")
				
				let c = Buffer.from(parts[3],'base64')
				if(parts[5])
					zip.addFile(parts[2], c, parts[4], parseInt(parts[5]))
				else 
					zip.addFile(parts[2], c, parts[4])
				return null
			}
			
			else if(parts[0] == "13"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")
				let entry= zip.getEntry(parts[2])
				zip.extractEntryTo(entry, parts[3], parts[4] == 1, parts[5] == 1)
				return null
			}
			
			else if(parts[0] == "14"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")
				zip.extractAllTo(parts[2], parts[3] == 1)
				return null
			}
			
			else if(parts[0] == "15"){
				// get entries ...
				let zip = storage[parts[1]]
				if(!zip) throw new Error("Zip is closed")
				zip.writeZip(parts[2])
				return null
			}
			
		
			
			
		
		}
		return module1()



		ENDTEXT        
		_Screen.nodeinterop.register(m.id, m.code)		
		num= _screen.nodeinterop._api.item[m.id]    
	ENDIF    
	RETURN _Screen.nodeinterop.execute(m.num, m.str, .t.)
endfunc



DEFINE CLASS AdmZipStatic as custom


	FUNCTION get(file)
		IF PCOUNT() > 0
			RETURN CREATEOBJECT("admzip", m.file)
		ENDIF 
		RETURN CREATEOBJECT("admzip", NULL)
	ENDFUNC 

ENDDEFINE 

DEFINE CLASS AdmZip as custom
	file = null 
	_zipid = null 
	
	FUNCTION init(file)
		this.file = m.file 	
	ENDFUNC 
	
	FUNCTION _init()
		LOCAL str 
		if(ISNULL(this.file))
			str = "0|"
		ELSE
			str = "0|" + this.file 
		ENDIF 
		this._zipid = __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION getEntries()
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "2|" + this._zipid 
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION getEntry(name)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "2|" + this._zipid + "|" + m.name
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION read(entry)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "3|" + this._zipid + "|" + m.entry.entryname
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION deleteFile(entry)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "4|" + this._zipid + "|" + m.entry.entryname
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION addZipComment(comment)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "5|" + this._zipid + "|" + STRCONV(m.comment,13)
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION getZipComment()
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "6|" + this._zipid 
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION addZipEntryComment(entry,comment)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "7|" + this._zipid + "|" + entry.entryName + "|" + STRCONV(m.comment,13)
		RETURN __admzip_execute(m.str)
	ENDFUNC
	
	FUNCTION getZipEntryComment(entry)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "8|" + this._zipid + "|" + entry.entryName 
		RETURN __admzip_execute(m.str)
	ENDFUNC
	
	
	FUNCTION updateFile(entry, content)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "9|" + this._zipid + "|" + entry.entryName + "|" + STRCONV(m.comment,13)
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION addLocalFile(path, zipPath)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "10|" + this._zipid + "|" + path + "|" + zipPath
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION addLocalFolder(path, zipPath)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "11|" + this._zipid + "|" + path + "|" + zipPath
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	FUNCTION addFile(name, content, comment, attr)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "12|" + this._zipid + "|" + name + "|" + STRCONV(m.content,13)
		IF PCOUNT() > 2
			str = str +  "|" + STRCONV(m.comment,13) 
		ENDIF 
		IF PCOUNT() > 3
			str = str +  "|" + alltrim(STR(m.attr))
		ENDIF 
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	
	FUNCTION extractEntryTo(entry, targetPath, preserveEntryPath, overwrite)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "13|" + this._zipid + "|" + entry.entryName + "|" + m.targetPath
		IF PCOUNT() > 2 AND m.preserveEntryPath
			str = str + "|1"
		ELSE
			str = str + "|0"
		ENDIF 
		
		IF PCOUNT() > 3 AND (!m.overwrite)
			str = str + "|0"
		ELSE
			str = str + "|1"
		ENDIF 
		
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	
	FUNCTION extractAllTo(targetPath, overwrite)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		
		LOCAL str 
		str = "14|" + this._zipid + "|" + m.targetPath		
		IF PCOUNT() > 1 AND (!m.overwrite)
			str = str + "|0"
		ELSE
			str = str + "|1"
		ENDIF 
		
		RETURN __admzip_execute(m.str)
	ENDFUNC 
	
	
	
	FUNCTION writeZip(targetPath)
		IF ISNULL(this._zipid)
			this._init()
		ENDIF 	
		IF PCOUNT() == 0
			m.targetPath = this.file 
			if(ISNULL(m.targetPath))
				ERROR("Please specify target path")
			ENDIF 
		ENDIF 
		
		LOCAL str 
		str = "15|" + this._zipid + "|" + m.targetPath		
		RETURN __admzip_execute(m.str)
	ENDFUNC 
		
	
	FUNCTION destroy()
		IF ISNULL(this._zipid)
			RETURN 
		ENDIF 
		LOCAL str 
		str = "1|" + this._zipid 
		RETURN __admzip_execute(m.str)
	ENDFUNC 
ENDDEFINE 
