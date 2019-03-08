"
I am a link to a contextual value. Contrary to all other links I am not necessarily rendered as a link but as a plain string or dynamic document depending on the current browsing context. Possible values are defined in my methods marked with the pragma ==<value:comment:>==.
"
Class {
	#name : #PRValueLink,
	#superclass : #PRLink,
	#instVars : [
		'selector'
	],
	#category : #'Pier-Model-Document'
}

{ #category : #testing }
PRValueLink class >> isAbstract [
	^ false
]

{ #category : #testing }
PRValueLink class >> isValidReference: aString [
	^ aString beginsWithSubCollection: 'value:'
]

{ #category : #visiting }
PRValueLink >> accept: aVisitor [
	aVisitor visitValueLink: self
]

{ #category : #values }
PRValueLink >> childrenIn: aContext [
	<value: 'children' comment: 'Display immediate children of the current structure.'>

	^ self lookupStructure: aContext structure do: [ :structure |
		self
			formatStructureCollection: (aContext
				enumeratorFor: structure) 
			in: aContext ]
]

{ #category : #values }
PRValueLink >> contentsIn: aContext [
	<value: 'contents' comment: 'Display all the children of the current structure.'>

	^ self lookupStructure: aContext structure do: [ :structure |
		self 
			formatStructureCollection: (aContext
				enumeratorFor: structure) all
			in: aContext ]
]

{ #category : #values }
PRValueLink >> contextIn: aContext [
	<value: 'context' comment: 'Display the current context.'>

	^ self formatDescribed: aContext default: #(command label)
]

{ #category : #values }
PRValueLink >> dateIn: aContext [
	<value: 'date' comment: 'Display the current date.'>

	^ Date today
]

{ #category : #values }
PRValueLink >> editedIn: aContext [
	<value: 'edited' comment: 'Display the last performed context.'>
	
	^ self lookupStructure: aContext structure do: [ :structure |
		aContext kernel persistency
			reverseDo: [ :each | ^ self contextIn: each ]
			for: structure.
		nil ]
]

{ #category : #values }
PRValueLink >> findIn: aContext [
	<value: 'find' comment: 'Display all the structures matching the query parameter.'>

	^ self parameters at: 'query' ifPresent: [ :query |
		self lookupStructure: aContext structure do: [ :structure |
			self
				formatStructureCollection: (structure fullTextSearch
					subString: query)
				in: aContext ] ]
]

{ #category : #values }
PRValueLink >> firstIn: aContext [
	<value: 'first' comment: 'Display the first sibling of the current structure.'>
	
	^ self lookupStructure: aContext structure do: [ :structure |
		self 
			formatStructure: (aContext structure: structure)
				siblings first
			in: aContext ]
]

{ #category : #private }
PRValueLink >> formatCollection: aCollection [
	"Format a collection of document objects or strings."
	
	| collection separator |
	collection := Array streamContents: [ :stream |
		aCollection do: [ :each |
			each isNil ifFalse: [ 
				each isString
					ifTrue: [ stream nextPut: (PRText content: each) ]
					ifFalse: [ stream nextPut: each ] ] ] ].
	collection isEmpty ifTrue: [ ^ nil ].
	^ (separator := self parameters at: 'separator' ifAbsent: [ nil ]) isNil
		ifTrue: [
			collection
				inject: PRUnorderedList new
				into: [ :result :each | result add: (PRListItem with: each); yourself ] ]
		ifFalse: [
			Array streamContents: [ :stream |
				collection
					do: [ :each | stream nextPut: each ]
					separatedBy: [ stream nextPut: (PRText content: separator) ] ] ]
]

{ #category : #private }
PRValueLink >> formatDescribed: anObject default: anAccessor [
	"Formats a described object anObject according to the display parameter, use anAccessor as a default. The display string can either be a parameter name (legacy) or a string containing zero or more parameter names in curly brackets for arbitrary string composition."
	
	| display input output |
	anObject isNil 
		ifTrue: [ ^ nil ].
	(display := self parameters at: 'display' ifAbsent: [ nil ]) isNil
		ifTrue: [ ^ anAccessor asAccessor read: anObject ].
	anObject magritteDescription do: [ :description | 
		description parameterName = display
			ifTrue: [ ^ description toString: (anObject readUsing: description) ] ].
	input := display readStream.
	output := WriteStream on: (String new: 2 * display size).
	[ input atEnd ] whileFalse: [
		output nextPutAll: (input upTo: ${).
		input atEnd ifFalse: [
			| parameter description |
			parameter := input upTo: $}.
			description := anObject magritteDescription
				detect: [ :each | each parameterName = parameter ]
				ifNone: [ nil ].
			description isNil
				ifFalse: [ output nextPutAll: (description toString: (anObject readUsing: description)) ] ] ].
	^ output contents
]

{ #category : #private }
PRValueLink >> formatStructure: aStructure in: aContext [
	"Format ==aStructure==. Link it, if the parameter ==link== is given; embed it, if this is an embedded link."
	
	| string |
	(aStructure hideFromMenus
		or: [ (self selectAndReject: aStructure) isNil
		or: [ (aContext structure: aStructure) isValid not ] ])
			ifTrue: [ ^ nil ].
	string := self 
		formatDescribed: aStructure
		default: #title.
	^ (self isEmbedded or: [ self hasParameter: 'link' ])
		ifTrue: [
			PRInternalLink new
				embedded: self isEmbedded;
				parameters: self parameters;
				target: aStructure;
				addAll: (string isNil
					ifTrue: [ Array new ]
					ifFalse: [ Array with: (PRText content: string) ]);
				yourself ]
		ifFalse: [ string isNil ifFalse: [ PRText content: string ] ]
]

{ #category : #private }
PRValueLink >> formatStructureCollection: aCollection in: aContext [
	"Format a collection of structures."

	| result |
	^ self formatCollection: (Array streamContents: [ :stream |
		aCollection do: [ :each |
			(result := self formatStructure: each in: aContext) isNil
				ifFalse: [ stream nextPut: result ] ] ])
]

{ #category : #values }
PRValueLink >> historyIn: aContext [
	<value: 'history' comment: 'Display the history for the current structure.'>
	
	| contexts |
	^ self lookupStructure: aContext structure do: [ :structure |
		contexts := (aContext kernel persistency historyFor: structure)
			collect: [ :context | self contextIn: context ].
		self formatCollection: contexts ]
]

{ #category : #values }
PRValueLink >> incomingIn: aContext [
	<value: 'incoming' comment: 'Display all structures referencing the current structure.'>

	^ self lookupStructure: aContext structure do: [ :structure |
		self 
			formatStructureCollection: ((aContext root incomingReferences
				to: structure; 
				collect: [ :each | each owner ])
				select: [ :each | each notNil ]) asSet
			in: aContext ]
]

{ #category : #testing }
PRValueLink >> isBroken [
	^ self selector isNil
]

{ #category : #values }
PRValueLink >> kernelIn: aContext [
	<value: 'kernel' comment: 'Display kernel of this site.'>

	^ self formatDescribed: aContext kernel default: #name
]

{ #category : #values }
PRValueLink >> lastIn: aContext [
	<value: 'last' comment: 'Display the last sibling of the current structure.'>
	
	^ self lookupStructure: aContext structure do: [ :structure |
		self 
			formatStructure: (aContext structure: structure) 
				siblings last
			in: aContext ]
]

{ #category : #values }
PRValueLink >> linksIn: aContext [
	<value: 'links' comment: 'Display all links from the current structure.'>

	^ self lookupStructure: aContext structure do: [ :structure |
		self formatCollection: ((structure outgoingReferences 
			select: [ :each | each isInternal or: [ each isExternal ] ])
			collect: [ :each | each copy embedded: false ]) ]
]

{ #category : #private }
PRValueLink >> lookupStructure: aStructure do: aBlock [
	"Lookup aStructure and evaluate aBlock if it is found. This performs different kinds of navigation starting from aStructure. If the parameter ==path== is given an absolute or relative lookup is started. The parameter ==level== choses a structure at the specified level in the parent chain, where the root is 1 and direct children of the root 2, etc. 0 is the current structure, -1 the parent of the current structure, etc. Furthermore the levels can be delimited using ==lower== and ==upper== bounds."

	| structure |
	structure := aStructure ifNil: [ ^ nil ].
	self parameters at: 'target' ifPresent: [ :path |
		structure := structure
			lookupPath: path
			ifAbsent: [ ^ nil ] ].
	(self hasParameter: 'level') ifTrue: [
		| parents extractor level |
		parents := structure parents.
		extractor := [ :name |
			| value |
			value := (self parameters at: name ifAbsent: [ nil ] )
				asNumber greaseInteger.
			value < 1
				ifTrue: [ parents size + value ]
				ifFalse: [ value ] ].
		((level := extractor value: 'level') between: 1 and: parents size)
			ifFalse: [ ^ nil ].
		((self hasParameter: 'lower') and: [ level < (extractor value: 'lower') ])
			ifTrue: [ ^ nil ].
		((self hasParameter: 'upper') and: [ level > (extractor value: 'upper') ])
			ifTrue: [ ^ nil ].
		structure := parents at: level ifAbsent: [ ^ nil ] ].
	^ aBlock value: structure
]

{ #category : #values }
PRValueLink >> nextIn: aContext [
	<value: 'next' comment: 'Display the following sibling of the current structure.'>
	
	^ self lookupStructure: aContext structure do: [ :target |
		| elements output |
		elements := (self hasParameter: 'nested')
			ifFalse: [ (aContext structure: target) siblings ]
			ifTrue: [ (aContext enumeratorFor: target root) everything contents ].
		(elements copyAfter: target) do: [ :structure |
			(output := self formatStructure: structure in: aContext) notNil
				ifTrue: [ ^ output ] ].
		nil ]
]

{ #category : #values }
PRValueLink >> outgoingIn: aContext [
	<value: 'outgoing' comment: 'Display all structures referenced from the current structure.'>

	^ self lookupStructure: aContext structure do: [ :structure |
		self 
			formatStructureCollection: ((structure outgoingReferences
				select: [ :each | each isInternal ])
				collect: [ :each | each target ])
			in: aContext ]
]

{ #category : #values }
PRValueLink >> parentIn: aContext [
	<value: 'parent' comment: 'Display the parent of the current structure.'>
	
	| output |
	^ self lookupStructure: aContext structure do: [ :target |
		target isRoot ifFalse: [
			target parent parents reverseDo: [ :structure |
				(output := self formatStructure: structure in: aContext) notNil
					ifTrue: [ ^ output ] ] ].
		nil ]
]

{ #category : #values }
PRValueLink >> parentsIn: aContext [
	<value: 'parents' comment: 'Display the parent chain of the current structure.'>
	
	^ self lookupStructure: aContext structure do: [ :structure |
		self 
			formatStructureCollection: structure parents
			in: aContext ]
]

{ #category : #querying }
PRValueLink >> pragmas [
	"Answer the method annotations of all currently supported value-links."
	
	^ Pragma allNamed: #value:comment: from: self class to: PRValueLink sortedByArgument: 1
]

{ #category : #values }
PRValueLink >> previousIn: aContext [
	<value: 'previous' comment: 'Display the previous sibling of the current structure.'>
	
	^ self lookupStructure: aContext structure do: [ :target |
		| elements output |
		elements := (self hasParameter: 'nested')
			ifFalse: [ (aContext structure: target) siblings ]
			ifTrue: [ (aContext enumeratorFor: target root) everything contents ].
		(elements copyUpTo: target) reverseDo: [ :structure |
			(output := self formatStructure: structure in: aContext) notNil
				ifTrue: [ ^ output ] ].
		nil ]
]

{ #category : #values }
PRValueLink >> randomIn: aContext [
	<value: 'random' comment: 'Display a random child of the current structure.'>

	| structures |
	^ self lookupStructure: aContext structure do: [ :structure |
		structures := (aContext structure: structure)
			enumerator all contents.
		structures isEmpty 
			ifFalse: [ self formatStructure: structures atRandom in: aContext ] ]
]

{ #category : #accessing }
PRValueLink >> reference: aString [
	super reference: aString.
	selector := self selectorFor: self title asLowercase trimBoth
]

{ #category : #values }
PRValueLink >> rootIn: aContext [
	<value: 'root' comment: 'Display the root structure.'>
	
	^ self formatStructure: aContext root in: aContext
]

{ #category : #private }
PRValueLink >> selectAndReject: anObject [
	self parameters at: 'select' ifPresent: [ :tokens |
		(tokens includesSubstring: anObject class label caseSensitive: true)
			ifFalse: [ ^ nil ] ].
	self parameters at: 'reject' ifPresent: [ :tokens |
		(tokens includesSubstring: anObject class label caseSensitive: true)
			ifTrue: [ ^ nil ] ].
	^ anObject
]

{ #category : #accessing }
PRValueLink >> selector [
	^ selector
]

{ #category : #querying }
PRValueLink >> selectorFor: aString [
	"Answer the method selector for the given value link ==aString==, of nil if not found."

	self pragmas
		do: [ :pragma | 
			pragma arguments first = aString
				ifTrue: [ ^ pragma methodSelector ] ].
	^ nil
]

{ #category : #values }
PRValueLink >> siblingsIn: aContext [
	<value: 'siblings' comment: 'Display the siblings of the current structure.'>
	
	^ self lookupStructure: aContext structure do: [ :structure |
		self 
			formatStructureCollection: (aContext structure: structure)
				siblings
			in: aContext ]
]

{ #category : #values }
PRValueLink >> structureIn: aContext [
	<value: 'structure' comment: 'Display the current structure.'>
	
	^ self lookupStructure: aContext structure do: [ :structure |
		self formatStructure: structure in: aContext ]
]

{ #category : #values }
PRValueLink >> timeIn: aContext [
	<value: 'time' comment: 'Display the current time.'>

	^ Time now
]

{ #category : #accessing }
PRValueLink >> title [
	^ self reference copyAfter: $:
]

{ #category : #querying }
PRValueLink >> valueIn: aContext [
	"Answer the current value within aContext. The answer is either a ==PRDocument== composite, any other ==Object== that is printable, or ==nil== if context or parameters are invalid."

	^ (aContext notNil and: [ self class selectors includes: self selector ])
		ifTrue: [ self perform: self selector with: aContext ]
]

{ #category : #values }
PRValueLink >> valuesIn: aContext [
	<value: 'values' comment: 'Display a table with all possible values with comment.'>

	^ PRTable new
		add: (PRTableRow new
			add: (PRTableCell new
				add: (PRText content: 'Markup');
				beHeading;
				yourself);
			add: (PRTableCell new
				add: (PRText content: 'Comment');
				beHeading;
				yourself);
			yourself);
		addAll: (self pragmas collect: [ :pragma |
			PRTableRow new
				add: (PRTableCell new
					add: (PRMonospaceFormat new
						add: (PRText content: '*value:' , pragma arguments first , '*');
						yourself);
					yourself);
				add: (PRTableCell new
					add: (PRText content: pragma arguments second);
					yourself);
				yourself ]);
		yourself
]
