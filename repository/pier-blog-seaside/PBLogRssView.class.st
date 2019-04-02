Class {
	#name : #PBLogRssView,
	#superclass : #PBHistoryRssView,
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBLogRssView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBLogRssView class >> label [
	^ 'Log (RSS)'
]
