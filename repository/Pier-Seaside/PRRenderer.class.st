"
The renderer is a visitor that knows the canvas and painter object it is supposed to generate HTML to.

Instance Variables
	html:		<WACanvas>
	painter:		<WAHtmlCanvas>
"
Class {
	#name : #PRRenderer,
	#superclass : #PRVisitor,
	#instVars : [
		'component',
		'html'
	],
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #'as yet unclassified' }
PRRenderer class >> isAbstract [
	^false
]

{ #category : #accessing }
PRRenderer >> component [
	^ component
]

{ #category : #accessing }
PRRenderer >> component: aComponent [
	component := aComponent
]

{ #category : #'accessing-dynamic' }
PRRenderer >> context [
	^ PRCurrentContext value
]

{ #category : #'accessing-dynamic' }
PRRenderer >> context: aContext [
	PRCurrentContext value: aContext
]

{ #category : #visiting }
PRRenderer >> continue: anObject in: aComponent on: aRenderer [
	| previous |
	previous := self shallowCopy.
	self component: aComponent.
	self renderer: aRenderer.
	[ self visit: anObject ]
		ensure: [ self copyFrom: previous ]
]

{ #category : #accessing }
PRRenderer >> renderer [
	^ html
]

{ #category : #accessing }
PRRenderer >> renderer: aRenderer [
	html := aRenderer
]

{ #category : #visiting }
PRRenderer >> start: anObject in: aComponent on: aRenderer [
	self component: aComponent.
	self renderer: aRenderer.
	self start: anObject
]
