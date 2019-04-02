Extension { #name : #PRForbiddenView }

{ #category : #'*pier-security-rendering' }
PRForbiddenView >> renderOptionLoginOn: html [
	<option: 0>
	
	| loginContext |
	loginContext := self context
		structure: self context structure
		command: (PULogin new
			successAnswer: forbidden;
			yourself).
	loginContext isValid ifTrue: [
		html listItem: [
			html anchor
				goto: loginContext;
				with: 'Authenticate'.
			html text: ' yourself to the site.' ] ]
]
