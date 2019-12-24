Class {
	#name : #PRDefaultView,
	#superclass : #PRViewComponent,
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRDefaultView class >> isAbstract [
	^ false
]

{ #category : #testing }
PRDefaultView class >> isRestful [
	^ true
]

{ #category : #accessing }
PRDefaultView class >> label [
	^ 'View'
]

{ #category : #accessing }
PRDefaultView >> label [
	^ self context structure title
]

{ #category : #rendering }
PRDefaultView >> render: aStructure on: html [
	html rendererInstance withinContentDo: [ 
		html rendererInstance 
			continue: aStructure 
			in: self on: html ]
]

{ #category : #rendering }
PRDefaultView >> renderContentOn: html [
	self render: self context structure on: html
]

{ #category : #accessing }
PRDefaultView >> robots [
	^ 'index,follow'
]

{ #category : #updating }
PRDefaultView >> updateRoot: aHtmlRoot [
	"Add universal edit button: http://universaleditbutton.org/."

	| editContext |
	super updateRoot: aHtmlRoot.
	editContext := self context command: self context structure
		editCommandClass new.
	editContext isValid ifTrue: [
		aHtmlRoot link
			beAlternate;
			type: 'application/x-wiki';
			title: editContext command label;
			url: (editContext urlOn: (self rendererClass
				context: aHtmlRoot context)) ]
]
