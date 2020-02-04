"
I render a table-of-contents for a page. Unlike other children of PRRenderer I redefine #start:in:on: to visit the parent of *value:toc* (ignoring the on: argument), this way embedded pages are displayed correctly.
"
Class {
	#name : #PRTocRenderer,
	#superclass : #PRDeepRenderer,
	#instVars : [
		'enabled',
		'current',
		'counter'
	],
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #utilities }
PRTocRenderer >> enable: aBoolean while: aBlock [
	| old |
	old := enabled. enabled := aBoolean.
	aBlock ensure: [ enabled := old ]
]

{ #category : #utilities }
PRTocRenderer >> ifEnabledDo: aBlock [
	enabled ifTrue: [ aBlock value ]
]

{ #category : #accessing }
PRTocRenderer >> level: anInteger [
	| value |
	value := anInteger min: 6 max: 1.
	value < current ifTrue: [
		anInteger + 1 to: current do: [ :index |
			counter at: index put: 0 ] ].
	counter
		at: (current := value)
		put: (counter at: value) + 1
]

{ #category : #visiting }
PRTocRenderer >> start: anObject [
	enabled := false.
	current := 1.
	counter := (Array new: 6) atAllPut: 0.
	html unorderedList
		class: 'toc';
		with: [ super start: anObject ]
]

{ #category : #visiting }
PRTocRenderer >> start: anObject in: aComponent on: aRenderer [
	self component: aComponent.
	self renderer: aRenderer.
	self start: aComponent owner
]

{ #category : #'visiting-document' }
PRTocRenderer >> visitHeader: anObject [ 
	self level: anObject level.
	html listItem
		class: 'toc-level-' , anObject level greaseString;
		with: 
			[ html anchor
				url: '#' , anObject hash greaseString;
				with: 
					[ html span
						class: 'toc-number';
						with: 
							[ (counter first: current) do: 
								[ :each | 
								html
									render: each;
									text: '.' ] ].
					html text: ' '.
					html span
						class: 'toc-contents';
						with: 
							[ self 
								enable: true
								while: [ super visitHeader: anObject ] ] ] ]
]

{ #category : #'visiting-document' }
PRTocRenderer >> visitText: anObject [
	self ifEnabledDo: [ html text: anObject text ]
]

{ #category : #'visiting-document' }
PRTocRenderer >> visitValueLink: anObject [
	self ifEnabledDo: [ super visitValueLink: anObject ]
]
