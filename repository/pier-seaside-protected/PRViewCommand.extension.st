Extension { #name : #PRViewCommand }

{ #category : #'*pier-seaside-protected' }
PRViewCommand >> initialRequest: aRequest [
	| viewClass |
	super initialRequest: aRequest.
	viewClass := PRPierFrame
		classFromRequest: aRequest
		name: 'view'
		base: PRViewComponent.
	(viewClass notNil and: [ viewClass isValidIn: self context ])
		ifTrue: [ self viewComponentClass: viewClass ].
	self viewComponent visiblePresentersDo: [ :each | each initialRequest: aRequest ].
	(self viewComponent isFullResponse)
		ifTrue: [ self viewComponent handle: WACurrentRequestContext value ]

]

{ #category : #'*pier-seaside-protected' }
PRViewCommand >> sanitizeSeasideCache [
	<sanitize>
	
	self properties removeKey: #viewComponent ifAbsent: [ ]
]

{ #category : #'*pier-seaside-protected' }
PRViewCommand >> updateUrl: anUrl [ 
	super updateUrl: anUrl.
	self viewComponentClass = self defaultViewComponentClass 
		ifFalse: [ anUrl queryFields at: 'view' put: self viewComponentClass name greaseString ].
	self properties 
		at: #viewComponent
		ifPresent: [ :component | component updateUrl: anUrl ]
]
