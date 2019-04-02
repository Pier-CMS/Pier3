Class {
	#name : #PRNotFoundView,
	#superclass : #PRErrorView,
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRNotFoundView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRNotFoundView class >> label [
	^ 'Not Found'
]

{ #category : #rendering }
PRNotFoundView >> renderErrorOn: html [
	html paragraph: [ 
		html 
			text: 'The requested object '; 
			code: self requestContext request url;
			text: ' was not found on this server.' ]
]

{ #category : #'rendering-options' }
PRNotFoundView >> renderSearchOn: html [
	<option: 500>
	
	| widgets |
	widgets := self context structure environment embeddedComponents
		select: [ :each | each target componentClass includesBehavior: PRSearchWidget ].
	widgets isEmpty ifTrue: [ ^ self ].
	html listItem: 'Use the search on this page to find what you are looking for.'
]

{ #category : #accessing }
PRNotFoundView >> status [
	^ 404
]
