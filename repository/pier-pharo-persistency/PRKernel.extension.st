Extension { #name : #PRKernel }

{ #category : #'*pier-pharo-persistency' }
PRKernel >> exportOn: anExporter [
	| persistencyBackup |
	anExporter sanitizeExport: self root.
	
	persistencyBackup := persistency.
	persistency := persistencyBackup class new
		copyFrom: persistencyBackup;
		sanitize.
			
	[ [ anExporter writeStream nextPut: self; close ] 
		ensure: [ persistency := persistencyBackup ] ]
			on: Error
			do: [ :err | ^ anExporter owner inform: 'Unable to export: ' , err messageText printString , '.' ].

]
