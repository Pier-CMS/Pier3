Class {
	#name : #PBPostTags,
	#superclass : #PBPostFilter,
	#instVars : [
		'tags'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBPostTags class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBPostTags class >> label [
	^ 'Tags'
]

{ #category : #private }
PBPostTags >> findTags [
	| tagsMap tagsByCount |
	tagsMap := Dictionary new.
	self posts do: [ :post |
		post tags do: [ :tag |
			(tagsMap at: tag ifAbsentPut: [ OrderedCollection new ])
				add: post ] ].
	tagsByCount := SortedCollection
		sortBlock: [ :a :b | a value size < b value size ].
	tagsMap associationsDo: [ :assoc | tagsByCount add: assoc ].
	self maxItems notNil
		ifTrue: [ tagsByCount := tagsByCount last: (tagsByCount size min: self maxItems) ].
	^ tagsByCount asSortedCollection: [ :a :b | a key < b key ]
]

{ #category : #actions }
PBPostTags >> refresh [
	super refresh.
	tags := nil
]

{ #category : #rendering }
PBPostTags >> renderBlogOn: html [
	self tags isEmpty ifTrue: [ ^ self ].
	html unorderedList: [
		self tags do: [ :assoc |
			html listItem: [
				self 
					renderFilter: assoc value
					with: assoc key
					on: html ] ] ]
]

{ #category : #accessing }
PBPostTags >> tags [
	^ tags ifNil: [ tags := self findTags ]
]
