Extension { #name : #TestCase }

{ #category : #'*pier-tests-security' }
TestCase >> assert: aCollection1 equalElements: aCollection2 [
	self assert: aCollection1 size = aCollection2 size.
	aCollection1 do: [ :each | self assert: (aCollection2 includes: each) ]
]
