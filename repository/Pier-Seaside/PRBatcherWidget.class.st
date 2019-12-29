Class {
	#name : #PRBatcherWidget,
	#superclass : #PRWidget,
	#instVars : [
		'showFirstLast',
		'showNumbers',
		'showPreviousNext'
	],
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #testing }
PRBatcherWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRBatcherWidget class >> label [
	^ 'Batcher'
]

{ #category : #'accessing-descriptions' }
PRBatcherWidget >> descriptionShowFirstLast [
	<magritteDescription>
	^ MABooleanDescription new
		parameterName: 'show-first-last';
		checkboxLabel: 'First/Last';
		accessor: #showFirstLast;
		label: 'Show Links';
		default: true;
		priority: 100;
		yourself
]

{ #category : #'accessing-descriptions' }
PRBatcherWidget >> descriptionShowNumbers [
	<magritteDescription>
	^ MABooleanDescription new
		parameterName: 'show-numbers';
		checkboxLabel: 'Numbers';
		accessor: #showNumbers;
		default: true;
		priority: 230;
		yourself
]

{ #category : #'accessing-descriptions' }
PRBatcherWidget >> descriptionShowPreviousNext [
	<magritteDescription>
	^ MABooleanDescription new
		parameterName: 'show-previous-next';
		checkboxLabel: 'Previous/Next';
		accessor: #showPreviousNext;
		default: true;
		priority: 210;
		yourself
]

{ #category : #accessing }
PRBatcherWidget >> nextSibling [
	"Answer the next sibling in the current context or nil."

	^ self siblings after: self context structure ifAbsent: [ nil ]
]

{ #category : #accessing }
PRBatcherWidget >> previousSibling [
	"Answer the previous sibling in the current context or nil."

	^ self siblings before: self context structure ifAbsent: [ nil ]
]

{ #category : #rendering }
PRBatcherWidget >> renderContentOn: html [ 
	self siblings isEmpty ifTrue: [ ^ self ].
	(self showFirstLast) ifTrue: 
		[ self 
			renderLabel: '|<'
			class: 'first'
			structure: self siblings first
			on: html ].
	(self showPreviousNext) ifTrue: 
		[ self 
			renderLabel: '<<'
			class: 'previous'
			structure: self previousSibling
			on: html ].
	(self showNumbers) ifTrue: 
		[ self siblings keysAndValuesDo: 
			[ :index :each | 
			self 
				renderLabel: index
				class: 'number'
				structure: each
				on: html ] ].
	(self showPreviousNext) ifTrue: 
		[ self 
			renderLabel: '>>'
			class: 'next'
			structure: self nextSibling
			on: html ].
	(self showFirstLast) ifTrue: 
		[ self 
			renderLabel: '>|'
			class: 'last'
			structure: self siblings last
			on: html ]
]

{ #category : #rendering }
PRBatcherWidget >> renderLabel: aString class: aCssString structure: aStructure on: html [
	| active |
	active := self context structure = aStructure.
	(active or: [ aStructure isNil ])
		ifTrue: [
			html span
				class: aCssString;
				class: 'active' if: active;
				with: aString ]
		ifFalse: [
			html anchor
				class: aCssString;
				title: aStructure title;
				goto: (self context structure: aStructure);
				with: aString ].
	html text: ' '
]

{ #category : #accessing }
PRBatcherWidget >> showFirstLast [
	^ showFirstLast
]

{ #category : #accessing }
PRBatcherWidget >> showFirstLast: anObject [
	showFirstLast := anObject
]

{ #category : #accessing }
PRBatcherWidget >> showNumbers [
	^ showNumbers
]

{ #category : #accessing }
PRBatcherWidget >> showNumbers: anObject [
	showNumbers := anObject
]

{ #category : #accessing }
PRBatcherWidget >> showPreviousNext [
	^ showPreviousNext
]

{ #category : #accessing }
PRBatcherWidget >> showPreviousNext: anObject [
	showPreviousNext := anObject
]

{ #category : #accessing }
PRBatcherWidget >> siblings [
	"Answer an list of siblings in the current context."

	^ (self context enumeratorFor: self context structure parent) contents
]
