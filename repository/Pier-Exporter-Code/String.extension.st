Extension { #name : #String }

{ #category : #'*pier-exporter-code' }
String >> codeOn: aStream [
	"multibyte strings are handled by SequenceableCollection which is a common base for Gemstone and Pharo"
	self isOctetString ifFalse: [ ^ super codeOn: aStream ]. 
	 
	aStream nextPut: $'.
	self do: [ :aChar |
		aChar = $' ifTrue: [ aStream nextPut: $' ].
		aStream nextPut: aChar ].
	aStream nextPut:  $'
]
