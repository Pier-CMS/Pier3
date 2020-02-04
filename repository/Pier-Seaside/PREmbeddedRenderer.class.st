Class {
	#name : #PREmbeddedRenderer,
	#superclass : #PRReferenceRenderer,
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitComponent: aStructure [
	parent 
		structure: aStructure
		during: [ html render: (self context componentFor: link) ]
]

{ #category : #'visiting-document' }
PREmbeddedRenderer >> visitExternalLink: aLink [
	"Goes through all the pragmas and check for the first match with the given URL."
	
	| pragmas |
	pragmas := Pragma
		allNamed: #external:priority:
		from: self class 
		to: PREmbeddedRenderer
		sortedByArgument: 2.
	pragmas do: [ :pragma |
		(aLink url greaseString includesSubstring: pragma arguments first caseSensitive: false)
			ifTrue: [ ^ self perform: pragma selector with: aLink ] ].
	super visitExternalLink: aLink
]

{ #category : #'visiting-document' }
PREmbeddedRenderer >> visitExternalLinkIframe: aLink [
	<external: '.htm' priority: 0>
	<external: '.html' priority: 0>

	html iframe
		attributes: (self attributesFor: aLink);
		title: aLink title;
		url: aLink url
]

{ #category : #'visiting-document' }
PREmbeddedRenderer >> visitExternalLinkImage: aLink [
	<external: '.png' priority: 0>
	<external: '.jpg' priority: 0>
	<external: '.jpeg' priority: 0>
	<external: '.gif' priority: 0>

	html image
		attributes: (self attributesFor: aLink);
		title: aLink title;
		url: aLink url
]

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitFile: aStructure [
	"This code does not use the Magritte rendering to be able to add additional attributes to the generated tags. Similar to the internal embedded links it goes the pragmas and checks for the first match with the given mimetype. If no renderer can be found, simply put a link."

	| pragmas |
	aStructure file ifNil: [ ^ self ].
	parent
		structure: aStructure
		during: [ (link hasParameter: 'anchor')
				ifTrue: [ html anchor
						name: (aStructure name select: [ :each | each isAlphaNumeric ]) ].
			(link hasParameter: 'download')
				ifTrue: [ ^ self visitFileDownload: aStructure ].
			pragmas := Pragma
				allNamed: #internal:priority:
				from: self class
				to: PREmbeddedRenderer
				sortedByArgument: 2.
			pragmas
				do: [ :pragma | 
					(aStructure file mimetype
						beginsWithSubCollection: pragma arguments first)
						ifTrue: [ ^ self perform: pragma methodSelector with: aStructure ] ].
			self visitFileDownload: aStructure ]
]

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitFileDownload: aStructure [
	<internal: 'application/' priority: 0>
	
	(self anchorFor: link)
		goto: (self context structure: aStructure view: PRDownloadView);
		with: [ self visitLink: link ]
]

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitFileImage: aStructure [
	<internal: 'image/' priority: 0>
	
	html image
		attributes: (self attributesFor: link);
		altText: aStructure title;
		url: aStructure url
]

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitFileJavascript: aStructure [
	<internal: 'text/javascript' priority: -10>
	<internal: 'application/javascript' priority: -10>

	html script
		attributes: (self attributesFor: link);
		url: aStructure file url
]

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitFileMedia: aStructure [
	<internal: 'video/' priority: 0>
	<internal: 'audio/' priority: 0>

	| url mime |
	url := aStructure file url.
	mime := aStructure file mimetype.
	(html tag: 'object')
		attributes: (self attributesFor: link);
		attributeAt: 'data' put: url;
		attributeAt: 'type' put: mime;
		with: [ 
			(html tag: 'param')
				attributeAt: 'name' put: 'src';
				with: url.
			(html tag: 'param')
				attributeAt: 'name' put: 'scale';
				with: 'aspect'.
			(html tag: 'param')
				attributeAt: 'name' put: 'autoplay';
				with: 'false'.
			(html tag: 'embed')
				attributes: (self attributesFor: link);
				attributeAt: 'src' put: url;
				attributeAt: 'scale' put: 'aspect';
				attributeAt: 'autoplay' put: 'false';
				attributeAt: 'type' put: mime;
				with: [ super visitInternalLink: link ] ]
]

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitFileText: aStructure [
	<internal: 'text/' priority: 0>

	html preformatted
		attributes: (self attributesFor: link);
		with: aStructure contents
]

{ #category : #'visiting-document' }
PREmbeddedRenderer >> visitInternalLink: aLink [
	"Visits the target to embed it, if the user has permissions to see the target, ignore otherwise."

	(parent visitsOf: aLink target) > 1
		ifTrue: [ super visitInternalLink: aLink ]
		ifFalse: [
			(self context structure: aLink target) isValid
				ifTrue: [ self visit: aLink target ] ]
]

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitPage: aPage [
	(link hasParameter: 'menu')
		ifTrue: [ self visitPageMenu: aPage ]
		ifFalse: [ super visitPage: aPage ]
]

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitPageMenu: aPage [ 
	| visitor |
	visitor := PRMostSpecificInternalLinkVisitor new.
	visitor visit: aPage document.
	parent structure: aPage during: [
		PRMenuRenderer new
			copyFrom: parent;
			target: visitor target;
			continue: aPage document
			in: aPage on: html ]
]

{ #category : #'visiting-structure' }
PREmbeddedRenderer >> visitStructure: aStructure [
	parent visit: aStructure
]
