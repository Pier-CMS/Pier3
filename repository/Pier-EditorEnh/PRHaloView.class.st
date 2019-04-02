Class {
	#name : #PRHaloView,
	#superclass : #PRDefaultView,
	#category : #'Pier-EditorEnh'
}

{ #category : #accessing }
PRHaloView class >> label [
	^ 'Halos'
]

{ #category : #accessing }
PRHaloView >> label [
	^ self class label
]

{ #category : #accessing }
PRHaloView >> rendererInstance [
	^ PRHaloRenderer new
]

{ #category : #accessing }
PRHaloView >> robots [
	^ 'noindex,nofollow'
]

{ #category : #updating }
PRHaloView >> updateRoot: aHtmlRoot [
	super updateRoot: aHtmlRoot.
	PRHaloScripts default updateRoot: aHtmlRoot
]
