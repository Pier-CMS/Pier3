Class {
	#name : #BOPdfView,
	#superclass : #BOBookView,
	#instVars : [
		'directory'
	],
	#category : #'Pier-Book-Latex'
}

{ #category : #accessing }
BOPdfView class >> label [
	^ 'Book PDF'
]

{ #category : #configuration }
BOPdfView >> bibtex [
	^ self findExecutable: 'bibtex'
]

{ #category : #accessing }
BOPdfView >> directory [
	^ directory ifNil: [ directory := (FileDirectory default directoryNamed: 'pdf/' , DateAndTime now asSortableString) assureExistence ]
]

{ #category : #accessing }
BOPdfView >> filename [
	^ self book name
]

{ #category : #private }
BOPdfView >> findExecutable: aString [
	| path |
	path := #('/usr/bin' '/usr/local/bin' '/usr/texbin')
		detect: [ :each | (FileDirectory on: each) fileExists: aString ]
		ifNone: [ self error: 'The command ' , aString printString , ' cannot be found.' ].
	^ (FileDirectory on: path) fullNameFor: aString
]

{ #category : #configuration }
BOPdfView >> intex [
	^ self findExecutable: 'makeindex'
]

{ #category : #configuration }
BOPdfView >> latex [
	^ self findExecutable: 'pdflatex'
]

{ #category : #accessing }
BOPdfView >> process [
	^ (Smalltalk classNamed: #OSProcess) ifNil: [ self error: 'OSProcess not found' ]
]

{ #category : #rendering }
BOPdfView >> renderPdfOn: aStream [
	| fullname stream latexCommand bibtexCommand indexCommand |
	fullname := self directory fullNameFor: self filename.
	[ stream := self directory forceNewFileNamed: self filename , '.tex'.
	[ stream nextPutAll: (self writer write: self book) ]
		ensure: [ stream close ].
	latexCommand := self latex , ' -output-directory ' , self directory fullName printString , ' -interaction batchmode ' , (fullname , '.tex') printString.
	bibtexCommand := self bibtex , ' -output-directory ' , self directory fullName printString , ' -interaction batchmode ' , (fullname , '.tex') printString.
	indexCommand := self intex , ' -output-directory ' , self directory fullName printString , ' -interaction batchmode ' , (fullname , '.tex') printString.
	self process
		waitForCommand: latexCommand;
		waitForCommand: bibtexCommand;
		waitForCommand: indexCommand;
		waitForCommand: latexCommand;
		waitForCommand: latexCommand.
	stream := self directory oldFileNamed: self filename , '.pdf'.
	^ [ self streamFrom: stream to: aStream ]
		ensure: [ stream close ] ]
			ensure: [ self directory recursiveDelete. directory := nil ]
]

{ #category : #responding }
BOPdfView >> respondUsing: aResponse [
	super respondUsing: aResponse.
	aResponse
		binary;
		contentType: 'application/pdf';
		attachmentWithFileName: self book name , '.pdf'.
	self renderPdfOn: aResponse stream
]

{ #category : #private }
BOPdfView >> streamFrom: aSourceStream to: aTargetStream [
	aSourceStream binary. 
	aTargetStream binary.
	[ aSourceStream atEnd ] 
		whileFalse: [ aTargetStream nextPutAll: (aSourceStream next: 1024) ]
]
