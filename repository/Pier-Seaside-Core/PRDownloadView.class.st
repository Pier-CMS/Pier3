Class {
	#name : #PRDownloadView,
	#superclass : #PRRawView,
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRDownloadView class >> isAbstract [
	^ false
]

{ #category : #testing }
PRDownloadView class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isFile ]
]

{ #category : #converting }
PRDownloadView class >> label [
	^ 'Download'
]

{ #category : #accessing }
PRDownloadView >> file [
	^ self context structure file
]

{ #category : #responding }
PRDownloadView >> respondUsing: aResponse [
	super respondUsing: aResponse.
	aResponse
		redirectTo: self file url;
		cacheForever;
		movedPermanently
]
