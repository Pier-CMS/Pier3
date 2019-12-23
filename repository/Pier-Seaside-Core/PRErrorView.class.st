Class {
	#name : #PRErrorView,
	#superclass : #PRViewComponent,
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRErrorView class >> isListed [
	^ false
]

{ #category : #testing }
PRErrorView class >> isValidIn: aContext [
	^ true
]

{ #category : #accessing }
PRErrorView class >> label [
	^ 'Error'
]

{ #category : #rendering }
PRErrorView >> renderContentOn: html [
	self requestContext response status: self status.
	self renderErrorOn: html.
	self renderSolutionsOn: html
]

{ #category : #rendering }
PRErrorView >> renderErrorOn: html [
]

{ #category : #'rendering-options' }
PRErrorView >> renderOptionExternalOn: html [
	<option: 400>
	
	| referer |
	referer := self requestContext request referer.
	referer isNil ifFalse: [
		html listItem: [
			html text: 'If you clicked a link from an external page '.
			html anchor
				url: referer;
				with: referer.
			html text: ', please inform the webmaster of this site of his mistake.' ] ]
]

{ #category : #'rendering-options' }
PRErrorView >> renderOptionLinkOn: html [
	<option: 100>
	
	html listItem: 'Click on a link on this site.'
]

{ #category : #'rendering-options' }
PRErrorView >> renderOptionRootOn: html [
	<option: 200>
	
	| rootContext |
	rootContext := self context structure: self context root.
	rootContext isValid ifTrue: [
		html listItem: [
			html text: 'Jump to the '.
			html anchor
				goto: rootContext;
				with: rootContext structure title.
			html text: ' homepage.' ] ]
]

{ #category : #'rendering-options' }
PRErrorView >> renderOptionSpellingOn: html [
	<option: 300>
	
	html listItem: 'If you typed the page address, make sure that it is spelled correctly.'
]

{ #category : #rendering }
PRErrorView >> renderOptionsOn: html [
	(Pragma
		allNamed: #option:
		from: self class
		to: PRErrorView
		sortedUsing: [ :a :b | a arguments first < b arguments first ])
		do: [ :each | self perform: each methodSelector with: html ]
]

{ #category : #rendering }
PRErrorView >> renderSolutionsOn: html [
	html paragraph: 'You might want to try one of these options:'.
	html unorderedList: [ self renderOptionsOn: html ]
]

{ #category : #accessing }
PRErrorView >> status [
	^ 200
]
