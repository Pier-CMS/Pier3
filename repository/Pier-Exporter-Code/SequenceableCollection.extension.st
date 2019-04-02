Extension { #name : #SequenceableCollection }

{ #category : #'*pier-exporter-code' }
SequenceableCollection >> codeMultiByteStringAsMainlyAsciiStringOn: aStream [
	| readStream initialPosition |
	
	readStream := ReadStream on: self.
	initialPosition := readStream position. "initialPosition varies between Gemstone and Pharo"
	aStream nextPut: $(.
	[ readStream atEnd not ] whileTrue: [
	
		(readStream position ~= initialPosition) ifTrue: [
			aStream nextPutAll: ', ' ].
		
		aStream nextPutAll: '('''.
		[ (readStream atEnd not) and: [ readStream peek asInteger  < 256 ] ] whileTrue: [
			| nextChar |
			nextChar := readStream next.
			nextChar = $' ifTrue: [ aStream nextPut: $' ].	
			aStream nextPut: nextChar ].
			aStream nextPut: $'.
			
			(readStream atEnd not) ifTrue: [
				aStream nextPutAll: ' copyWith: (Character value: '; print: readStream next greaseInteger; nextPut: $) ].
	
		aStream nextPut: $) ].
	aStream nextPut: $).
]

{ #category : #'*pier-exporter-code' }
SequenceableCollection >> codeMultiByteStringAsUTF8ByteArrayOn: aStream [
	| uft8EncodedString |

	uft8EncodedString := (GRCodec forEncoding: 'utf-8') encode: self.
	aStream << '((GRCodec forEncoding: ''utf-8'') decode: '. uft8EncodedString asByteArray codeOn: aStream. aStream nextPut: $)
	
]

{ #category : #'*pier-exporter-code' }
SequenceableCollection >> codeOn: aStream [
	"single byte string #codeOn: is implemented in String>>#codeOn:"
	self isString 
		ifFalse: [ super codeOn: aStream ]
		ifTrue: [
			| asciiCharacterCount |
			"The multibyte string #codeOn: implementation is defined here (in SequenceableCollection) as 
			SequenceableCollection is a common multibyte string base for Gemstone and Pharo"
			asciiCharacterCount := self count: [ :each | each  asInteger < 256 ].
			(asciiCharacterCount / self size) > (3 /4) 
				ifTrue: [ self codeMultiByteStringAsMainlyAsciiStringOn: aStream ]
				ifFalse: [ self codeMultiByteStringAsUTF8ByteArrayOn: aStream ] ]

	
]
