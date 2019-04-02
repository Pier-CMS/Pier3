Class {
	#name : #PRDocumentWidgetAccessor,
	#superclass : #MAChainAccessor,
	#category : #'Pier-Documents'
}

{ #category : #'instance creation' }
PRDocumentWidgetAccessor class >> on: selector key: key [
	^ self 
		on: (MASelectorAccessor selector: selector)
		accessor:  (MADictionaryAccessor key: key)
]
