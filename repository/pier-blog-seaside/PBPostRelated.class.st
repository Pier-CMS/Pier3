Class {
	#name : #PBPostRelated,
	#superclass : #PBPostFilter,
	#instVars : [
		'post',
		'related'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBPostRelated class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBPostRelated class >> label [
	^ 'Related'
]

{ #category : #private }
PBPostRelated >> findRelated [
	| other |
	self post isNil
		ifTrue: [ ^ #() ].
	other := ((self posts copyWithout: self post)
		collect: [ :each | each -> (each tags count: [ :tag | self post tags includes: tag ]) ])
		reject: [ :each | each value = 0 ].
	other sort: [ :a :b | a value > b value ].
	self maxItems notNil
		ifTrue: [ other := other first: (other size min: self maxItems) ].
	^ other collect: [ :e | e key ]
]

{ #category : #events }
PBPostRelated >> onChangeContext: aContext [
	super onChangeContext: aContext.
	self post = self findPost
		ifFalse: [ self refresh ]
]

{ #category : #accessing }
PBPostRelated >> post [
	^ post ifNil: [ post := self findPost ]
]

{ #category : #actions }
PBPostRelated >> refresh [
	super refresh.
	post := related := nil
]

{ #category : #accessing }
PBPostRelated >> related [
	^ related ifNil: [ related := self findRelated ]
]

{ #category : #rendering }
PBPostRelated >> renderBlogOn: html [
	self related isEmpty
		ifTrue: [ ^ self ].
	html unorderedList: [
		self related do: [ :each |
			html listItem: [
				html anchor
					goto: (self context structure: each);
					with: [ html html: each menu ] ] ] ]
]
