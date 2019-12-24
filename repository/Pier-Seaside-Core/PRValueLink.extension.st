Extension { #name : #PRValueLink }

{ #category : #'*pier-seaside' }
PRValueLink >> redirectIn: aContext [
	"Ignore the request if this is not the default view, e.g. an rss changes feed."
	<value: 'redirect' comment: 'Redirect to a different location, specified in the ''to'' parameter.'>
	
	| link url |
	(aContext command isView 
		and: [ aContext command viewComponentClass = aContext command defaultViewComponentClass ]) 
			ifFalse: [ ^ nil ].
	link := PRLink fromString: ((self 
		parameters at: 'to'
		ifAbsent: [ ^ nil ]) ifNil: [ ^ nil ]).
	link owner: aContext structure.
	link isBroken ifTrue: [ ^ nil ].
	url := link isInternal 
		ifTrue: [ (aContext structure: link target) url ]
		ifFalse: [ 
			link isExternal 
				ifTrue: [ link url ]
				ifFalse: [ ^ nil ] ].
	aContext session requestContext responseGenerator
		redirectTo: url greaseString;
		respond.
	^ nil
]

{ #category : #'*pier-seaside' }
PRValueLink >> tocIn: aContext [
	<value: 'toc' comment: 'Display the table of contents of the current structure.'>

	^ self lookupStructure: aContext structure do: [ :structure | [ :html |
		PRTocRenderer new 
			start: structure
			in: self 
			on: html ] ]
]
