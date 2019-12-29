Class {
	#name : #PRWidget,
	#superclass : #MAComponent,
	#instVars : [
		'context',
		'owner'
	],
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #accessing }
PRWidget class >> groupLabel [
	^ 'Pier Widget'
]

{ #category : #accessing }
PRWidget >> context [
	^ context ifNil: [ context := super context ]
]

{ #category : #private }
PRWidget >> expand: aString [
	self context ifNil: [ ^aString ].
	^ PRMacroExpander default expand: aString with: self context
]

{ #category : #initialization }
PRWidget >> initializeOwner: aStructure link: anInternalLink [
	super initializeOwner: (owner := aStructure) link: anInternalLink
]

{ #category : #accessing }
PRWidget >> kernel [
	^ self context kernel
]

{ #category : #events }
PRWidget >> onChangeContext: aContext [
	super onChangeContext: aContext.
	context := aContext
]

{ #category : #accessing }
PRWidget >> owner [
	"The owning structure where this widget is instantiated and configured from."
	
	^ owner
]

{ #category : #rendering }
PRWidget >> renderContentOn: html [
	"Note: If you code ends up in here you most certainly need to rename #renderWidgetOn: to #renderContentOn:"

	self subclassResponsibility
]
