Set fso = CreateObject("Scripting.FileSystemObject")
Set a = fs.CreateTextFile("x:\go.txt", True)

'Check every 1 second to see if the file exists 
While Not fso.FileExists(filespec)
	Wscript.Sleep 1000
Wend

'When it does exist, delete it and go on
fso.DeleteFile(filespec)
