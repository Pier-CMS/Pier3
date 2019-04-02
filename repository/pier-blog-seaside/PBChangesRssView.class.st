Class {
	#name : #PBChangesRssView,
	#superclass : #PBHistoryRssView,
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBChangesRssView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBChangesRssView class >> label [
	^ 'Changes (RSS)'
]

{ #category : #testing }
PBChangesRssView >> isVisible: aContext [
	^ aContext command isEdit and: [ super isVisible: aContext ]
]

{ #category : #'rendering-parts' }
PBChangesRssView >> renderData: aContext on: html [
	aContext command magritteDescription do: [ :each |
		each isDocumentDescription ifTrue: [
			PBRssRenderer new
				start: (aContext 	command readUsing: each)
				in: self on: html ] ]
]

{ #category : #accessing }
PBChangesRssView >> titleFor: aContext [
	^ aContext structure title
]
