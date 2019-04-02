"
Pier1ToPier2Converter is used to convert an imported pier 1 kernel to pier 2 syntax, it replaces html tags with {{{<tag>}}} for a set of known tags (see #verbatimToMatch).

An example of how this can be used to convert pages:

Run the below to fix page names and remove problem characters - do the following:
	PRKernel instances anyOne persistency inspect.
Run the below code there:


| converter oldHistory aKernel |
oldHistory := history.
aKernel := self kernel.
aKernel persistency: PRNullPersistency new.
converter := Pier1ToPier2Converter new kernel: aKernel.
converter kernel root enumerator everything do: [:page | converter convertPage: page].
aKernel persistency: self.
history := oldHistory.

Before running this, one should check that '{{{' should not be found.
"
Class {
	#name : #Pier1ToPier2Converter,
	#superclass : #Object,
	#instVars : [
		'kernel'
	],
	#category : #'Pier-SW2-Sw1Features'
}

{ #category : #'as yet unclassified' }
Pier1ToPier2Converter class >> convertPage: aPage [
	| new |
	new := self new.
	new kernel: aPage kernel.
	new convertPage: aPage
]

{ #category : #accessing }
Pier1ToPier2Converter >> contextForStructure: aStructure command: aCommand [
	| context |
	context := PRContext kernel: self kernel structure: aStructure command: aCommand.
	context propertyAt: #user put: (context kernel users select: [ :e | e isSuperuser ]) anyOne.
	^ context
]

{ #category : #actions }
Pier1ToPier2Converter >> convertLine: aString [
	| resultsBeforeTableFix |
	aString isEmpty
		ifTrue: [ ^ '' ].
	aString first = $=
		ifTrue: [ ^ aString ]
		ifFalse: [ 
			resultsBeforeTableFix := self verbatimToMatch copy: aString translatingMatchesUsing: [ :match | '{{{' , match , '}}}' ].
			resultsBeforeTableFix first = $|
				ifTrue: [ 
					resultsBeforeTableFix := '\|{{{<' asRegexIgnoringCase
						copy: resultsBeforeTableFix
						translatingMatchesUsing: [ :ignore | '| {{{<' ] ].
			^ resultsBeforeTableFix ]
]

{ #category : #actions }
Pier1ToPier2Converter >> convertPage: aStructure [
	| command context document |
	command := PREditCommand new.
	context := self contextForStructure: aStructure command: command.
	aStructure hasDocument
		ifTrue: [ 
			document := PRPage descriptionDocument fromString: (self convertString: aStructure contents).
			command write: document using: PRPage descriptionDocument.
			command execute ]
]

{ #category : #actions }
Pier1ToPier2Converter >> convertString: aString [
	^ String
		new: aString size
		streamContents: [ :lines | aString lines do: [ :line | lines nextPutAll: (self convertLine: line) ] separatedBy: [ lines cr ] ]
]

{ #category : #accessing }
Pier1ToPier2Converter >> kernel [
	^ kernel
]

{ #category : #accessing }
Pier1ToPier2Converter >> kernel: aKernel [
	kernel := aKernel
]

{ #category : #accessing }
Pier1ToPier2Converter >> verbatimToMatch [
	^ '<a [^>]*>|</a>|<br[^>]*>|<hr[^>]*>|<ol[^>]*>|<ul[^>]*>|<li[^>]*>|</li>|</ul>|</ol>|<blockquote[^>]*>|</blockquote>|<span[^>]*>|</span>|<div[^>]*>|</div>|<img[^>]*>|</img>|&#[0-9]*;|&lt;|&gt;|<font[^>]*>|</font>|<marquee[^>]*|</marquee>|<i>|</i>|<b>|</b>|<pre>|</pre>|<code[^>]*>|</code>'
		asRegexIgnoringCase
]
