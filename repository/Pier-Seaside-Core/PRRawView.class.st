Class {
	#name : #PRRawView,
	#superclass : #PRViewComponent,
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRRawView class >> isRestful [
	^ true
]

{ #category : #testing }
PRRawView >> isFullResponse [
	^ true
]

{ #category : #responding }
PRRawView >> respondUsing: aResponse [
	aResponse cacheForever
]
