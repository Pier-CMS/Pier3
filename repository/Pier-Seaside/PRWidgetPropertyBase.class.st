Class {
	#name : #PRWidgetPropertyBase,
	#superclass : #PRWidget,
	#instVars : [
		'properties'
	],
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-properties' }
PRWidgetPropertyBase >> properties [
	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : #'accessing-properties' }
PRWidgetPropertyBase >> propertyAt: aKey [
	^ self properties at: aKey
]

{ #category : #'accessing-properties' }
PRWidgetPropertyBase >> propertyAt: aKey ifAbsent: aBlock [
	^ self properties at: aKey ifAbsent: aBlock
]

{ #category : #'accessing-properties' }
PRWidgetPropertyBase >> propertyAt: aKey ifAbsentPut: aBlock [
	^ self properties at: aKey ifAbsentPut: aBlock
]

{ #category : #'accessing-properties' }
PRWidgetPropertyBase >> propertyAt: aKey put: aValue [
	^ self properties at: aKey put: aValue
]

{ #category : #private }
PRWidgetPropertyBase >> read: aSymbol [
	self greaseDeprecatedApi: 'PRWidgetPropertyBase>>#read:' details: 'use PRWidgetPropertyBase>>readUsing: in preference'. 
	
	^ self readUsing: (self perform: aSymbol)
]

{ #category : #'private-model' }
PRWidgetPropertyBase >> readUsing: aDescription [
	^ self propertyAt: aDescription ifAbsent: [ aDescription default ]
]

{ #category : #'private-model' }
PRWidgetPropertyBase >> write: anObject using: aDescription [
	^ self propertyAt: aDescription put: anObject
]
