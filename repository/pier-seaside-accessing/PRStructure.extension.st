Extension { #name : #PRStructure }

{ #category : #'*pier-seaside-accessing' }
PRStructure >> componentsIn: aContext [
	^ self embeddedComponents collect: [ :each | aContext componentFor: each ]
]

{ #category : #'*pier-seaside-accessing' }
PRStructure >> cssClass [
	"Answer a CSS class that should be used in the body-tag when browsing the structure. Furthermore it is put into menus and links that reference the receiver."
	
	| baseClass |
	baseClass := self class fullName asLowercase allButFirst: 2.
	self properties
		at: #customCssClasses
		ifPresent: [ :value | baseClass := baseClass , ' ' , value ].
	^ baseClass
]

{ #category : #'*pier-seaside-accessing' }
PRStructure >> customCssClasses [
	^ self propertyAt: #customCssClasses ifAbsent: [ nil ]
]

{ #category : #'*pier-seaside-accessing' }
PRStructure >> customCssClasses: aString [
	^ aString isEmptyOrNil
		ifTrue: [ self properties removeKey: #customCssClasses ifAbsent: [ ] ]
		ifFalse: [ self propertyAt: #customCssClasses put: aString ]

]

{ #category : #'*pier-seaside-accessing' }
PRStructure >> embeddedComponents [
	"Answer a list of embedded component links."
	
	^ self outgoingReferences embeddedComponents
]

{ #category : #'*pier-seaside-accessing' }
PRStructure >> hideFromMenus [
	^ self propertyAt: #hideFromMenus ifAbsentPut: [ false ]
]

{ #category : #'*pier-seaside-accessing' }
PRStructure >> hideFromMenus: aBoolean [
	^ self propertyAt: #hideFromMenus put: aBoolean
]

{ #category : #'*pier-seaside-accessing' }
PRStructure >> menu [
	^ self propertyAt: #menu ifAbsent: [ self title ]
]

{ #category : #'*pier-seaside-accessing' }
PRStructure >> menu: aString [
	(aString isNil or: [ aString isEmpty or: [ aString = self title ] ])
		ifTrue: [ self properties removeKey: #menu ifAbsent: [ ] ]
		ifFalse: [ self propertyAt: #menu put: aString ]
]
