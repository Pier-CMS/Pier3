Class {
	#name : #PRSystemWidget,
	#superclass : #PRWidget,
	#category : #'Pier-Pharo-Seaside'
}

{ #category : #accessing }
PRSystemWidget class >> groupLabel [
	^ 'Pier System'
]

{ #category : #testing }
PRSystemWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRSystemWidget class >> label [
	^ 'System Statistics'
]

{ #category : #accessing }
PRSystemWidget >> persistency [
	^ self context kernel persistency
]

{ #category : #rendering }
PRSystemWidget >> renderActionsOn: html [
	html form: [
		html submitButton
			callback: [ Smalltalk garbageCollect ];
			text: 'Garbage Collect' ]
]

{ #category : #rendering }
PRSystemWidget >> renderContentOn: html [
	html preformatted: 'Does not work anymore'.
	self isSuperuser ifTrue: [ self renderActionsOn: html ]
]
