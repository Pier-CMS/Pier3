"
PQCycler offers the JQuery Cycle plugin. It takes a source structure as an input and it creates a slideshow from its children.
"
Class {
	#name : #PQCyclerWidget,
	#superclass : #PRWidget,
	#instVars : [
		'delay',
		'effect',
		'source',
		'speed',
		'timeout'
	],
	#category : #'Pier-JQuery-Widgets'
}

{ #category : #accessing }
PQCyclerWidget class >> effectChoices [
	^ #('blindX' 'blindY' 'blindZ' 'cover' 'curtainX' 'curtainY' 'fade' 'fadeZoom' 'growX' 'growY'
		'none' 'scrollUp' 'scrollDown' 'scrollLeft' 'scrollRight' 'scrollHorz' 'scrollVert' 'shuffle' 'slideX'
		'slideY' 'toss' 'turnUp' 'turnDown' 'turnLeft' 'turnRight' 'uncover' 'wipe' 'zoom')
]

{ #category : #accessing }
PQCyclerWidget class >> groupLabel [
	^ 'Pier JQuery-based Widget'
]

{ #category : #testing }
PQCyclerWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PQCyclerWidget class >> label [
	^ 'Cycler'
]

{ #category : #accessing }
PQCyclerWidget >> children [
	^ self sourceChildren 
		inject: OrderedCollection new 
		into: [:all :each | all addAll: (each componentsIn: self context). all]
]

{ #category : #accessing }
PQCyclerWidget >> delay [
	^ delay
]

{ #category : #accessing }
PQCyclerWidget >> delay: anObject [
	delay := anObject
]

{ #category : #accessing }
PQCyclerWidget >> descriptionDelay [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'Initial delay';
		parameterName: 'delay';
		accessor: #delay;
		label: 'Delay';
		priority: 130;
		default: 4000;
		bePositive;
		beInteger;
		yourself
]

{ #category : #accessing }
PQCyclerWidget >> descriptionEffect [
	<magritteDescription>
	^ MASingleOptionDescription new
		label: 'Effect';
		parameterName: 'effect';
		accessor: #effect;
		priority: 360;
		comment: 'The animation effect to be used.';
		options: self class effectChoices;
		default: self class effectChoices first;
		beRequired;
		beSorted;
		yourself
]

{ #category : #accessing }
PQCyclerWidget >> descriptionSource [
	<magritteDescription>
	^ PRStructureDescription new
		label: 'Select a structure as source';
		parameterName: 'source';
		accessor: #source;
		label: 'Source';
		priority: 100;
		yourself
]

{ #category : #accessing }
PQCyclerWidget >> descriptionSpeed [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'Transition speed';
		parameterName: 'speed';
		accessor: #speed;
		label: 'Speed';
		priority: 150;
		default: 1000;
		bePositive;
		beInteger;
		yourself
]

{ #category : #accessing }
PQCyclerWidget >> descriptionTimeout [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'Timeout';
		parameterName: 'timeout';
		accessor: #timeout;
		label: 'Timeout';
		priority: 120;
		default: 3000;
		bePositive;
		beInteger;
		yourself
]

{ #category : #accessing }
PQCyclerWidget >> effect [
	^ effect
]

{ #category : #accessing }
PQCyclerWidget >> effect: anObject [
	effect := anObject
]

{ #category : #rendering }
PQCyclerWidget >> renderContentOn: html [
	self source isNil
		ifTrue: [ ^ html div: '(no source structure specified)' ].
	self sourceChildren isEmpty
		ifTrue: [ ^ html div: '(no children in the source structure available)' ].
	html div
		id: #cycler;
		script:
				((html jQuery: #cycler) cycle
						fx: self effect;
						timeout: self timeout;
						delay: self delay;
						speed: self speed;
						pager: '#cyclerNav') greaseString;
		with: [ 
					self sourceChildren
						do: [ :each | 
							html div
								class: 'cyclerItem';
								with: [ self renderViewOf: each on: html ] ] ].
	html div
		id: #cyclerNav
]

{ #category : #rendering }
PQCyclerWidget >> renderViewOf: each on: html [
	^ html rendererInstance withinContentDo: [ html rendererInstance continue: each document in: self on: html ]
]

{ #category : #accessing }
PQCyclerWidget >> source [
	^ source
]

{ #category : #accessing }
PQCyclerWidget >> source: anObject [
	source := anObject
]

{ #category : #updating }
PQCyclerWidget >> sourceChildren [
	^ self source isNil
		ifTrue: [ #() ]
		ifFalse: [ self source enumerator contents ]
]

{ #category : #accessing }
PQCyclerWidget >> speed [
	^ speed
]

{ #category : #accessing }
PQCyclerWidget >> speed: anObject [
	speed := anObject
]

{ #category : #accessing }
PQCyclerWidget >> timeout [
	^ timeout
]

{ #category : #accessing }
PQCyclerWidget >> timeout: anObject [
	timeout := anObject
]

{ #category : #updating }
PQCyclerWidget >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.	 
			
	"assume that jQuery libraries are already loaded"
	anHtmlRoot javascript url: JQWidgetBoxDeploymentLibrary / #jquerycycleallJs
]
