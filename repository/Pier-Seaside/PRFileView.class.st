"
If the request isn't of mime-type text/html I respond directly with my associated file, otherwise I delegate rendering to my super-class.
"
Class {
	#name : #PRFileView,
	#superclass : #PRDefaultView,
	#instVars : [
		'isFullResponse'
	],
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRFileView class >> isAbstract [
	^ false
]

{ #category : #testing }
PRFileView class >> isHtmlRequest: aRequest [
	| isHtmlRequest |
	isHtmlRequest := (aRequest accept 
		collect: [ :each | each value = WAMimeType textHtml ]) 
			detect: [ :each | each ] 
			ifNone: [ aRequest contentType notNil and: [ aRequest contentType = WAMimeType textHtml ] ].
		
	^ isHtmlRequest
]

{ #category : #accessing }
PRFileView class >> label [
	^ 'File'
]

{ #category : #hooks }
PRFileView >> initialRequest: aRequest [
	isFullResponse := (self class isHtmlRequest: aRequest) not.
]

{ #category : #testing }
PRFileView >> isFullResponse [
	^ isFullResponse ifNil: [ false ]
]

{ #category : #responding }
PRFileView >> respondUsing: aResponse [
	| file |
	file := self context structure file.
	
	aResponse
		binary;
		cacheForever;
		contentType: file mimetype seasideMimeType;
		headerAt: 'Content-Disposition' put: 'inline; filename="' , file filename , '"';
		nextPutAll:  file contents;
		respond
]
