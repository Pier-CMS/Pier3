Class {
	#name : #PRCodeBuilderDescriptionVisitor,
	#superclass : #MAVisitor,
	#instVars : [
		'structure',
		'stream',
		'methods',
		'exporter',
		'selectorsWithCommonDefaults'
	],
	#category : #'Pier-Exporter-Code'
}

{ #category : #'instance creation' }
PRCodeBuilderDescriptionVisitor class >> structure: structure methods: methods exporter: exporter on: stream [
	^ self basicNew
		initializeWithStructure: structure methods: methods exporter: exporter stream: stream
		yourself
]

{ #category : #private }
PRCodeBuilderDescriptionVisitor >> addCodeFor: aDescription value: value [
	aDescription asCodeFor: structure value: value exporter: exporter on: stream.
	stream nextPut: Character cr
]

{ #category : #modifying }
PRCodeBuilderDescriptionVisitor >> addMethod: method [
	self methods add: method
]

{ #category : #initialization }
PRCodeBuilderDescriptionVisitor >> initializeWithStructure: aStructure methods: methodsCollection exporter: anExporter stream: aStream [
	self initialize.
	
	structure := aStructure.
	methods := methodsCollection.
	exporter := anExporter.
	stream := aStream
]

{ #category : #'check defaults' }
PRCodeBuilderDescriptionVisitor >> isCommonDefault: aDescription [
	| accessor defaultCheckBlock |
	
	"Unfortunately the description frequently doesn't define a default value, but there are a common set of defaults we don't need to write.
	We key off the readSelector and check against a dictionary for common defaults"
	accessor := aDescription accessor.
	(accessor class canUnderstand: #readSelector) ifFalse: [ ^ false ].
	defaultCheckBlock := self selectorsWithCommonDefaults at: accessor readSelector ifAbsent: [ ^ false ].
	
	^ defaultCheckBlock value
]

{ #category : #'check defaults' }
PRCodeBuilderDescriptionVisitor >> isDefaultDescriptionValue: aDescription [
	| descriptionDefault structureValue |
	
	descriptionDefault := aDescription default.
	structureValue := structure readUsing: aDescription.
	^ descriptionDefault = structureValue 
]

{ #category : #'check defaults' }
PRCodeBuilderDescriptionVisitor >> isNil: aDescription [
	^ (structure readUsing: aDescription) isNil

]

{ #category : #accessing }
PRCodeBuilderDescriptionVisitor >> methods [
	^ methods
]

{ #category : #'check defaults' }
PRCodeBuilderDescriptionVisitor >> selectorsWithCommonDefaults [
	^ selectorsWithCommonDefaults ifNil: [ 
		selectorsWithCommonDefaults := Dictionary new
			at: #name put: [ true ];
			at: #title put: [ structure title = structure name capitalized ];
			at: #menu put: [ structure menu = structure title ];
			at: #tags put: [ structure tags isEmpty ];
			at: #hideFromMenus put: [ structure hideFromMenus not ];
			yourself ]
]

{ #category : #visiting }
PRCodeBuilderDescriptionVisitor >> visit: aDescription [
	"only visit writable descriptions - otherwise we can't initialise it."
	(aDescription stringAccessor canWrite: structure) ifFalse: [ ^ self ]. 
	
	"only visit descriptions with non-default values"
	(self isDefaultDescriptionValue: aDescription) ifTrue: [ ^ self ].
	(self isNil: aDescription) ifTrue: [ ^ self ].
	(self isCommonDefault: aDescription) ifTrue: [ ^ self ].

	aDescription acceptMagritte: self
]

{ #category : #visiting }
PRCodeBuilderDescriptionVisitor >> visitDescription: aDescription [
	| value |
	value := (aDescription accessor read: structure) asCode.
	self addCodeFor: aDescription value: value
]

{ #category : #visiting }
PRCodeBuilderDescriptionVisitor >> visitDocumentDescription: aDescription [
	"could have used:
		 value := (aDescription toString: (aDescription accessor read: structure)) asCode
	but I thought it was good to be explicit that we require wiki format output"
	| value |
	value := (self writerClass write: (aDescription accessor read: structure)) asCode.
	self addCodeFor: aDescription value: value
]

{ #category : #visiting }
PRCodeBuilderDescriptionVisitor >> visitFileDescription: aDescription [
	| fileModel |
	fileModel := aDescription accessor read: structure.

	stream 
		<< '	structure file: (' << fileModel class greaseString << ' new
		filename: ' << fileModel filename asCode << ';
		mimetype: ' << fileModel mimetype asCode.
		fileModel class name = #MAExternalFileModel ifFalse: [
			| fileModelContents |
			fileModelContents := fileModel contents.
			fileModelContents isEmptyOrNil
				ifTrue: [ stream << ').' << String cr]
				ifFalse: [
			"deliberately use #asString on the ByteArray rather than #greaseString - as #greaseString generates a string representation of the ByteString eg  '#[0 1 2 3]' where #asString
			converts the ByteArray to a string"
					stream << ';' << String cr.
					stream << '		contents: ' << (fileModel isText
							ifTrue: [ fileModelContents asString asCode ]
							ifFalse: [ fileModelContents asCode ]) << ').' << String cr ] ].
	fileModel class name = #MAExternalFileModel ifTrue: [
		stream << ').' << String cr.
		stream << '		structure file directory: ' << fileModel location asCode << '.' << String cr.
		stream << '		"url: ' << (fileModel baseUrl ifNil: [ '' ])  << '/' << (fileModel location reduce: [ :a :b | a , '/' , b ])  << '/' << fileModel filename greaseString << '"' << String cr ]

]

{ #category : #visiting }
PRCodeBuilderDescriptionVisitor >> visitStructureDescription: aDescription [
	| subStructure |
	subStructure := aDescription accessor read: structure.
	aDescription asCodeFor: structure value: ' (self ', subStructure asSelector, ': aKernel)' exporter: exporter on: stream.
	stream nextPut: Character cr.
	
	self methods addAll: (exporter writeCodeFor: subStructure)
]

{ #category : #visiting }
PRCodeBuilderDescriptionVisitor >> writerClass [
	" old Pier has the Wiki writer, new Pier has the pillar writer "
	^Smalltalk at: #PRPillarWriter ifAbsent: [ Smalltalk at: #PRWikiWriter ]
]
