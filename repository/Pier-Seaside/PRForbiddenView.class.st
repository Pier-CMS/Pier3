Class {
	#name : #PRForbiddenView,
	#superclass : #PRErrorView,
	#instVars : [
		'forbidden'
	],
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRForbiddenView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRForbiddenView class >> label [
	^ 'Forbidden'
]

{ #category : #accessing }
PRForbiddenView >> forbidden: aContext [
	forbidden := aContext
]

{ #category : #rendering }
PRForbiddenView >> renderErrorOn: html [
	html paragraph: [ 
		html text: 'You are not allowed to '.
		html text: (forbidden isNil
			ifTrue: [ 'view' ]
			ifFalse: [ forbidden command class label asLowercase ]).
		html text: ' this page.' ]
]

{ #category : #accessing }
PRForbiddenView >> status [
	^ 403
]
