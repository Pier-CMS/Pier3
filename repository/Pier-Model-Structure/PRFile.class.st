"
I represent a data container for images, videos, sound, pdf or zip files. I reference an instance of *MAFileModel*. The mime-type is used to determine how the given file is be displayed. As an example images and videos are attempted to be inlined into the resulting output, whereas zip-files are referenced as a link to allow downloading.
"
Class {
	#name : #PRFile,
	#superclass : #PRStructure,
	#instVars : [
		'file'
	],
	#category : #'Pier-Model-Structure'
}

{ #category : #testing }
PRFile class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRFile class >> label [
	^ 'File'
]

{ #category : #visiting }
PRFile >> accept: aVisitor [
	aVisitor visitFile: self
]

{ #category : #'accessing-convenience' }
PRFile >> contents [
	"Answer a string representation of the file of the receiver. Directly access the file-model if you need the unconverted data source. Note that this intentionally uses #asString and not #greaseString that returns an printString of the byte-array."

	^ self file contents asString
]

{ #category : #'accessing-convenience' }
PRFile >> contents: aString [
	"Set the contents of the receiving file. Directly access the underlying file-model, if you do not want automatic conversion."

	self file contents: (aString ifNil: [ String new ]) asByteArray
]

{ #category : #'accessing-description' }
PRFile >> descriptionFile [
	<magritteDescription>
	^ MAFileDescription new
		accessor: #file;
		priority: 300;
		label: 'File';
		beEditable;
		yourself
]

{ #category : #accessing }
PRFile >> file [
	^ file ifNil: [ file := self fileModel new ]
]

{ #category : #accessing }
PRFile >> file: aFile [
	file := aFile
]

{ #category : #accessing }
PRFile >> fileModel [
	^ (self magritteDescription detect: [ :each | each = self descriptionFile ]) kind
]

{ #category : #'accessing-convenience' }
PRFile >> filename: aString [
	self file filename: aString
]

{ #category : #testing }
PRFile >> isFile [
	^ true
]

{ #category : #testing }
PRFile >> isImage [
	^ self file isImage
]

{ #category : #testing }
PRFile >> isText [
	^ self file isText
]

{ #category : #'accessing-convenience' }
PRFile >> mimetype: aString [
	self file mimetype: aString
]

{ #category : #copying }
PRFile >> postCopy [
	super postCopy.
	self file: self file copy
]

{ #category : #accessing }
PRFile >> url [
	^ self file urlFromFileStructure: self
]
