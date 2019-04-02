Class {
	#name : #PRExporterImporter,
	#superclass : #PRObject,
	#instVars : [
		'owner',
		'writeStream'
	],
	#category : #'Pier-Pharo-Persistency'
}

{ #category : #'accessing-configuration' }
PRExporterImporter >> emptyWriteStream [
	self subclassResponsibility
]

{ #category : #actions }
PRExporterImporter >> export: aKernel on: aRequestContext [
	aKernel exportOn: self.
	aRequestContext response
		document: self writeStream contents
			mimeType: self mimeType
			fileName: aKernel name , self extension;
		respond
]

{ #category : #accessing }
PRExporterImporter >> extension [
	self subclassResponsibility
]

{ #category : #actions }
PRExporterImporter >> import: aCollection into: aKernel [
	| kernel stream |
	aCollection isNil
		ifTrue: [ ^ owner inform: 'Please specify an import.' ].
	[ stream := self readStreamOn: aCollection.
	kernel := stream next ]
		on: Error
		do: [ :err | ^ owner inform: 'Unable to import: ' , err messageText printString , '.' ].
	(kernel isKindOf: PRKernel)
		ifFalse: [ ^ owner inform: 'Invalid file format.' ].
	self replace
		ifTrue: [ 
			aKernel becomeForward: kernel.
			aKernel persistency desanitize ]
		ifFalse: [
			kernel root name: (PRAddCommand new
				uniqueName: kernel root name
				in: aKernel root).
			aKernel root addChild: kernel root ].
	self sanitizeImport: kernel root.
	^ kernel

]

{ #category : #accessing }
PRExporterImporter >> mimeType [
	self subclassResponsibility 
]

{ #category : #accessing }
PRExporterImporter >> owner [
	^ owner
]

{ #category : #accessing }
PRExporterImporter >> owner: anObject [
	owner := anObject
]

{ #category : #'accessing-configuration' }
PRExporterImporter >> readStreamOn: aCollection [
	self subclassResponsibility
]

{ #category : #accessing }
PRExporterImporter >> replace [
	^ owner replace 
]

{ #category : #private }
PRExporterImporter >> sanitizeExport: aStructure [
	"Some older versions of Pier have block contexts in their conditions, get rid of these."
	
	aStructure enumerator with all do: [ :structure |
		Smalltalk at: #PRComponent ifPresent: [ :class |
			(structure isKindOf: class) ifTrue: [
				structure settings keys do: [ :desc |
					desc conditions: (desc conditions
						reject: [ :cond | cond key isBlock ]) ] ] ] ]
]

{ #category : #private }
PRExporterImporter >> sanitizeImport: aStructure [
	"After importing drop all the security settings as these users might not exist in the new kernel. Also refresh all the links so that they are properly printed when editing these pages."
	
	aStructure enumerator with all do: [ :structure |
		self replace ifFalse: [
			Smalltalk at: #PUSecurity ifPresent: [ :class |
				structure 
					removeDecoration: class
					ifAbsent: [ ] ] ].
		structure outgoingReferences do: [ :link |
			(link isInternal and: [ link isBroken not ])
				ifTrue: [ link update ] ] ]
]

{ #category : #accessing }
PRExporterImporter >> writeStream [
	^ writeStream ifNil: [ writeStream := self emptyWriteStream ]
]
