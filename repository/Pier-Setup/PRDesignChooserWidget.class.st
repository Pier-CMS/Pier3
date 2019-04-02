Class {
	#name : #PRDesignChooserWidget,
	#superclass : #PRWidget,
	#category : #'Pier-Setup'
}

{ #category : #testing }
PRDesignChooserWidget class >> isAbstract [
	^false
]

{ #category : #rendering }
PRDesignChooserWidget >> renderContentOn: html [

	html unorderedList: [
		PRDistribution withAllSubclasses do: [:each |
			html listItem: [
				html anchor callback: [
					(self confirm: 'You will replace the entire content and design of the current Pier. Do you want to continue?')
						ifTrue: [
							PRKernel reset.
							WACurrentRequestContext value application preferenceAt: #kernel put: each new kernel.
							self session unregister.
							self requestContext redirectTo: self application  url ]
				]; with: each title
			]
		]
	]
]
