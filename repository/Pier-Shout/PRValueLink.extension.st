Extension { #name : #PRValueLink }

{ #category : #'*pier-shout' }
PRValueLink >> sourceIn: aContext [
	<value: 'source' comment: 'Display the source code of the class, selectors and comment given in the parameters.'>
	
	^ self propertyAt: #shouter ifAbsentPut: [
		| class symbol shouter |
		class := self
			parameters at: 'class'
			ifAbsent: [ ^ 'class parameter missing' ].
		class := self class environment
			classNamed: class trimBoth.
		class isNil
			ifTrue: [ ^ 'class name unknown' ].
			
		(self hasParameter: 'comment') ifTrue: [
			^ PRPillarParser parse:  class comment ].
					
		symbol := self parameterAt: 'selector'.
		shouter := SPHighlightedCode new.
		shouter classOrMetaClass: class.
		shouter text: (symbol isNil
			ifTrue: [ class definition ]
			ifFalse: [ 
				class name , '>>' , (class 
					sourceCodeAt: symbol trimBoth asSymbol
					ifAbsent: [ ^ 'selector name unknown' ]) ])
						asString.
		shouter ]
]
