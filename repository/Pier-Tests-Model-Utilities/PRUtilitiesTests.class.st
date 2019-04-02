Class {
	#name : #PRUtilitiesTests,
	#superclass : #TestCase,
	#category : #'Pier-Tests-Model-Utilities'
}

{ #category : #accessing }
PRUtilitiesTests >> number1 [
	^ '1!'
]

{ #category : #accessing }
PRUtilitiesTests >> number2 [
	^ '!2'
]

{ #category : #accessing }
PRUtilitiesTests >> number3 [
	^ '3'
]

{ #category : #'tests-escaper' }
PRUtilitiesTests >> testEnsureEscape [
	| visitor tag |
	visitor := PRPath basicNew initialize; yourself.
	tag := nil.

	self assert: (visitor withEscaper: [
		[ true ]
			ensure: [ tag := 1 ] ]).
	self assert: tag = 1.

	self assert: (visitor withEscaper: [
		[ visitor escape: true ]
			ensure: [ tag := 2 ] ]).
	self assert: tag = 2
]

{ #category : #'tests-escaper' }
PRUtilitiesTests >> testEscaper [
	| visitor |
	visitor := PRPath basicNew initialize; yourself.

	self assert: (visitor withEscaper: [ true ]).
	self deny: (visitor withEscaper: [ false ]).

	self assert: (visitor withEscaper: [ visitor escape: true. false ]).
	self deny: (visitor withEscaper: [ visitor escape: false. true ])
]

{ #category : #'tests-escaper' }
PRUtilitiesTests >> testHasEscaper [
	| visitor |
	visitor :=  PRPath basicNew initialize; yourself.
	self deny: visitor hasEscaper.
	self assert: (visitor withEscaper: [ visitor hasEscaper ])
]

{ #category : #'tests-expander' }
PRUtilitiesTests >> testMacroExpand [
	| expander |
	expander := PRMacroExpander new.
	expander
		on: $0 do: #(selector);
		on: $1 do: #(number1);
		on: $2 do: #(number2);
		on: $3 do: #(yourself number3).

	self assert: (expander expand: '' with: self) = ''.
	self assert: (expander expand: 'xyz' with: self) = 'xyz'.

	self assert: (expander expand: '%0' with: self) = 'testMacroExpand'.
	self assert: (expander expand: '%1' with: self) = '1!'.
	self assert: (expander expand: '%2' with: self) = '!2'.
	self assert: (expander expand: '%3' with: self) = '3'.

	self assert: (expander expand: '%1xy' with: self) = '1!xy'.
	self assert: (expander expand: 'x%1y' with: self) = 'x1!y'.
	self assert: (expander expand: 'xy%1' with: self) = 'xy1!'.

	self assert: (expander expand: '%2xy' with: self) = '!2xy'.
	self assert: (expander expand: 'x%2y' with: self) = 'x!2y'.
	self assert: (expander expand: 'xy%2' with: self) = 'xy!2'.

	self assert: (expander expand: '%1%2' with: self) = '1!!2'.
	self assert: (expander expand: 'x%1%2' with: self) = 'x1!!2'.
	self assert: (expander expand: 'x%1y%2' with: self) = 'x1!y!2'.
	self assert: (expander expand: 'x%1y%2z' with: self) = 'x1!y!2z'.

	self assert: (expander expand: '%%' with: self) = '%'.
	self assert: (expander expand: '%3' with: self) = '3'
]

{ #category : #'tests-expander' }
PRUtilitiesTests >> testMacroInitialized [
	| expander |
	expander := PRMacroExpander new.

	self assert: expander character = $%.
	self assert: expander table isEmpty
]
