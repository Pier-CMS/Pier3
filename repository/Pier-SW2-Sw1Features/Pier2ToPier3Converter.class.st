"
Pier2ToPier3Converter is used to update the names of Pier 2 pages so they are acceptable for Pier 3.  For example, it is possible to have a page in Pier 2 that has a space in the name (if one tries to move the page, it will fail and force you to re-name it, but for pages migrated from Pier1 to Pier2 then they may have never been touched after the migration).

Instance Variables:
	kernel	<PRKernel>

Example:
First check the number of broken links:
(PRInternalLink allInstances select: [ :e | e isBroken ]) size.
.
Run the below to fix page names and remove problem characters - do the following:
	PRKernel instances anyOne persistency inspect.
Run the below code there:


| converter oldHistory aKernel |
oldHistory := history.
aKernel := self kernel.
self kernel persistency: PRNullPersistency new.
converter := Pier2ToPier3Converter new kernel: aKernel.
converter kernel root enumerator everything do: [:page | converter convertPage: page].
(PRPreformatted allInstances reject: [:pre | pre children allSatisfy: [:text | text class= PRText]]) isEmpty ifFalse: [self halt: 'This should not have happened'].
PRPreformatted allInstances do: [:pre | pre children do: [:text | text text: (String space, text text)]].
aKernel persistency: self.
history := oldHistory.

"
Class {
	#name : #Pier2ToPier3Converter,
	#superclass : #Pier1ToPier2Converter,
	#instVars : [
		'titleConversionTable'
	],
	#category : #'Pier-SW2-Sw1Features'
}

{ #category : #actions }
Pier2ToPier3Converter >> convertLine: aString [
	| inputStream outputStream currentChar lastChar |
	aString isEmpty
		ifTrue: [ ^ '' ].
	(aString includes: (Character value: 226))
		ifFalse: [ ^ aString ].
	inputStream := ReadStream on: aString.
	outputStream := WriteStream on: (String new: aString size).
	lastChar := Character space.
	[ inputStream atEnd ]
		whileFalse: [ (currentChar := inputStream next) = (Character value: 226)
				ifTrue: [ lastChar isSeparator
						ifTrue: [ outputStream nextPut: $- ]
						ifFalse: [ lastChar isLetter
								ifTrue: [ outputStream nextPut: $' ].
							inputStream
								next;
								next ] ]
				ifFalse: [ outputStream nextPut: currentChar ].
			lastChar := currentChar ].
	^ outputStream contents
]

{ #category : #actions }
Pier2ToPier3Converter >> convertPage: aStructure [
	"Nil is an invalid structure name.  Title can also not be set to the title."

	| tempName |
	super convertPage: aStructure.
	(PRPath isValidName: aStructure name)
		ifTrue: [ ^ self ].
	(PRPath isValidName: aStructure title)
		ifTrue: [ 
			Transcript
				show: 'Swapping the name: ' , aStructure name printString , ' with: ' , aStructure title printString;
				cr.
			tempName := aStructure name.
			aStructure name: aStructure title.
			aStructure title: tempName.
			^ self ]
		ifFalse: [ 
			tempName := aStructure title translateWith: self titleConversionTable.
			aStructure title: aStructure name copy.
			Transcript
				show: 'Renaming from: ' , aStructure name printString , ' to: ' , tempName;
				cr.
			aStructure name: tempName ]
]

{ #category : #'initialize-release' }
Pier2ToPier3Converter >> initialize [
	super initialize.
	self
		titleConversionTable:
			(String
				withAll:
					(Character allByteCharacters
						collect: [ :c | 
							c = Character space
								ifTrue: [ $- ]
								ifFalse: [ 
									c = $/
										ifTrue: [ $_ ]
										ifFalse: [ c asLowercase ] ] ]))
]

{ #category : #accessing }
Pier2ToPier3Converter >> kernel [
	^ kernel
]

{ #category : #accessing }
Pier2ToPier3Converter >> kernel: aKernel [
	kernel := aKernel

]

{ #category : #accessing }
Pier2ToPier3Converter >> titleConversionTable [
	^ titleConversionTable
]

{ #category : #accessing }
Pier2ToPier3Converter >> titleConversionTable: aString [
	titleConversionTable := aString

]
