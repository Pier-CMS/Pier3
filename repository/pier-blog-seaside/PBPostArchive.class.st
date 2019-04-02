Class {
	#name : #PBPostArchive,
	#superclass : #PBPostFilter,
	#instVars : [
		'archive'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBPostArchive class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBPostArchive class >> label [
	^ 'Archive'
]

{ #category : #accessing }
PBPostArchive >> archive [
	^ archive ifNil: [ archive := self buildArchive ]
]

{ #category : #private }
PBPostArchive >> buildArchive [
	| monthMap monthSorted |
	monthMap := Dictionary new.
	self posts do: [ :each |
		(monthMap at: each publication asMonth ifAbsentPut: [ OrderedCollection new ])
			add: each ].
	monthSorted := SortedCollection 
		sortBlock: [ :a :b | a key > b key ].
	monthMap associationsDo: [ :assoc | monthSorted add: assoc ].
	self maxItems notNil
		ifTrue: [ monthSorted := monthSorted first: (monthMap size min: self maxItems) ].
	^ monthSorted
]

{ #category : #actions }
PBPostArchive >> refresh [
	super refresh.
	archive := nil
]

{ #category : #rendering }
PBPostArchive >> renderBlogOn: html [
	self archive isEmpty ifTrue: [ ^ self ].
	html unorderedList: [
		self archive do: [ :assoc |
			html listItem: [
				self 
					renderFilter: assoc value
					with: assoc key name , ' ' , assoc key year greaseString
					on: html ] ] ]
]
