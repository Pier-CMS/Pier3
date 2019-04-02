Class {
	#name : #PBDiffRssView,
	#superclass : #PBHistoryRssView,
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBDiffRssView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBDiffRssView class >> label [
	^ 'Diff (RSS)'
]

{ #category : #testing }
PBDiffRssView >> isFiltered [
	^ false
]

{ #category : #testing }
PBDiffRssView >> isVisible: aContext [
	^ aContext command isEdit and: [ super isVisible: aContext ]
]

{ #category : #'rendering-parts' }
PBDiffRssView >> renderData: aContext on: html [
	| previous |
	previous := self 
		previousContextOf: aContext
		matching: [ :each | each structure == aContext structure ].
	aContext command magritteDescription do: [ :each |
		each isDocumentDescription ifTrue: [
			| source target |
			source := previous isNil
				ifFalse: [ each toString: (previous command readUsing: each) ].
			target := each toString: (aContext command readUsing: each).
			html render: (PRWordDiffAlgorithm from: source to: target) ] ]
]

{ #category : #accessing }
PBDiffRssView >> titleFor: aContext [
	^ aContext structure title
]
