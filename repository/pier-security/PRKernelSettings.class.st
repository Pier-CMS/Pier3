Class {
	#name : #PRKernelSettings,
	#superclass : #PRWidget,
	#instVars : [
		'component'
	],
	#category : #'Pier-Security-Widgets'
}

{ #category : #accessing }
PRKernelSettings class >> groupLabel [
	^ 'Pier Settings'
]

{ #category : #testing }
PRKernelSettings class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRKernelSettings class >> label [
	^ 'Kernel Settings'
]

{ #category : #hooks }
PRKernelSettings >> children [
	^ Array with: self component
]

{ #category : #accessing }
PRKernelSettings >> component [
	^ component ifNil: [
		component := self kernel asComponent
			addValidatedForm;
			yourself ]
]

{ #category : #rendering }
PRKernelSettings >> renderContentOn: html [
	self isSuperuser
		ifFalse: [ ^ html paragraph: 'Only adminstrators can edit the kernel settings.' ].
	html render: self children
]
