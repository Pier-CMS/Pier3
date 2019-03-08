Class {
	#name : #PRMacroExpander,
	#superclass : #PRBasicObject,
	#instVars : [
		'character',
		'table'
	],
	#classInstVars : [
		'default'
	],
	#category : #'Pier-Model-Utilities'
}

{ #category : #accessing }
PRMacroExpander class >> default [
	^ default
]

{ #category : #'class initialization' }
PRMacroExpander class >> initialize [
	default := self new.
	default
		on: $c do: #(command label);	" current command "
		on: $r do: #(kernel root title);	" current root structure "
		on: $t do: #(structure title);		" current structure "
		on: $k do: #(kernel name)		" current kernel name "
]

{ #category : #'instance creation' }
PRMacroExpander class >> on: aDictionary [
	^ self new
		table: aDictionary;
		yourself
]

{ #category : #'class initialization' }
PRMacroExpander class >> unload [
	default := nil
]

{ #category : #accessing }
PRMacroExpander >> character [
	^ character
]

{ #category : #accessing }
PRMacroExpander >> character: aCharacter [
	character := aCharacter
]

{ #category : #'accessing-defaults' }
PRMacroExpander >> defaultCharacter [
	^ $%
]

{ #category : #'accessing-defaults' }
PRMacroExpander >> defaultTable [
	^ Dictionary new
]

{ #category : #evaluation }
PRMacroExpander >> expand: aString with: anObject [
	^ aString isEmptyOrNil
		ifTrue: [ aString ]
		ifFalse: [ self expandFrom: aString readStream with: anObject ]
]

{ #category : #private }
PRMacroExpander >> expandFrom: aReadStream with: anObject [
	^ String streamContents: [ :writeStream |
		[ aReadStream atEnd ] whileFalse: [
			writeStream nextPutAll: (aReadStream upTo: self character).
			aReadStream atEnd 
				ifFalse: [ self expandFrom: aReadStream with: anObject on: writeStream ] ] ]
]

{ #category : #private }
PRMacroExpander >> expandFrom: aReadStream with: anObject on: aWriteStream [
	| accessor char result |
	accessor := self table
		at: (char := aReadStream next)
		ifAbsent: [ nil ].
	accessor isNil
		ifTrue: [ aWriteStream nextPut: char ]
		ifFalse: [ 
			result := accessor read: anObject.
			result isNil
				ifFalse: [ aWriteStream nextPutAll: result ] ]
]

{ #category : #initialization }
PRMacroExpander >> initialize [
	super initialize.
	self table: self defaultTable.
	self character: self defaultCharacter
]

{ #category : #configuration }
PRMacroExpander >> on: aCharacter do: anAccessor [
	table at: aCharacter put: anAccessor asAccessor
]

{ #category : #accessing }
PRMacroExpander >> table [
	^ table
]

{ #category : #accessing }
PRMacroExpander >> table: aDictionary [
	table := aDictionary
]
