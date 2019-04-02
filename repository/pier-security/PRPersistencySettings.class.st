Class {
	#name : #PRPersistencySettings,
	#superclass : #PRWidget,
	#category : #'Pier-Security-Widgets'
}

{ #category : #accessing }
PRPersistencySettings class >> groupLabel [
	^ 'Pier Settings'
]

{ #category : #testing }
PRPersistencySettings class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRPersistencySettings class >> label [
	^ 'Persistency Settings'
]

{ #category : #actions }
PRPersistencySettings >> activate: aClass [
	self kernel persistency class = aClass
		ifFalse: [ self kernel persistency: aClass new ]
]

{ #category : #actions }
PRPersistencySettings >> edit: aPersistency [
	self show: (aPersistency asComponent
		addValidatedForm;
		yourself)
]

{ #category : #rendering }
PRPersistencySettings >> renderContentOn: html [
	self isSuperuser
		ifFalse: [ ^ html paragraph: 'Only adminstrators can edit the persistency settings.' ].
	html form: [
		html select
			labels: [ :each | each label ];
			selected: self kernel persistency class;
			list: PRPersistency withAllConcreteClasses;
			callback: [ :each | self activate: each ].
		html space.
		html submitButton
			with: 'select'.
		5 timesRepeat: [ html space ].
		html submitButton
			callback: [ self edit: self kernel persistency ];
			disabled: self kernel persistency magritteDescription isEmpty;
			with: 'edit'.
		(self kernel persistency respondsTo: #snapshot) ifTrue: [
			html space.
			html submitButton
				callback: [ self kernel persistency snapshot ];
				text: 'snapshot' ] ].
	html paragraph: self kernel persistency class comment
]
