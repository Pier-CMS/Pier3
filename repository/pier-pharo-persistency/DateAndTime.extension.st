Extension { #name : #DateAndTime }

{ #category : #'*pier-pharo-persistency' }
DateAndTime >> asSortableString [
	"A small interpreter to get a date exactly the way required."

	| code separator |
	code := #( year 4 $- monthIndex 2 $- dayOfMonth 2 $_ hour 2 $- minute 2 $- second 2 ) readStream.
	^ String streamContents: [ :stream |
		[ code atEnd ] whileFalse: [
			stream nextPutAll: ((self perform: code next)
				printPaddedWith: $0 to: code next).
			(separator := code next) isNil
				ifFalse: [ stream nextPut: separator ] ] ]
]
