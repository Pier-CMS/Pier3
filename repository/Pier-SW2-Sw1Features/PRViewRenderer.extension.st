Extension { #name : #PRViewRenderer }

{ #category : #'*pier-sw2-sw1features' }
PRViewRenderer >> visitPierTable: anObject [
	| table |
	(table := html table) attributes addClass: 'prtable'.
	table with: [ super visitTable: anObject ]
]
