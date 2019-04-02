Extension { #name : #PRCommand }

{ #category : #'*pier-seaside-protected' }
PRCommand >> initialRequest: aRequest [
	"Override this to extract additional data from the request. This is only called for requests that don't have a valid session yet.'"
]

{ #category : #'*pier-seaside-protected' }
PRCommand >> updateRoot: aHtmlRoot [
	"Override customize the <head> section of an HTML document."

	aHtmlRoot meta
		name: 'robots';
		content: self robots.
	aHtmlRoot bodyAttributes
		addClass: self cssClass
]

{ #category : #'*pier-seaside-protected' }
PRCommand >> updateUrl: anUrl [ 
	"Override to customize the URL used to display this command."
	
	self class = self structure defaultCommandClass 
		ifFalse: [ anUrl queryFields at: 'command' put: self class name greaseString ]
]
