Class {
	#name : #PREditorHandler,
	#superclass : #WARequestHandler,
	#instVars : [
		'context',
		'key'
	],
	#category : #'Pier-EditorEnh'
}

{ #category : #'instance creation' }
PREditorHandler class >> on: aContext [
	^ self new initializeOn: aContext
]

{ #category : #accessing }
PREditorHandler >> context [
	^ context
]

{ #category : #processing }
PREditorHandler >> handleFiltered: aRequestContext [
	aRequestContext respond: [ :response |
		response
			contentType: 'text/plain';
			nextPutAll: (WAHtmlCanvas builder
				render: [ :html | self renderLinksOn: html ]) ]
]

{ #category : #initialization }
PREditorHandler >> initializeOn: aContext [ 
	context := aContext
]

{ #category : #accessing }
PREditorHandler >> key [
	^ key
]

{ #category : #accessing }
PREditorHandler >> key: aString [
	key := aString
]

{ #category : #'rendering-parts' }
PREditorHandler >> renderDefaultLinksOn: html [
	html option: 'Alias>Path@Anchor'.
	html option: 'http://www.piercms.com'.
	html option: 'info@piercms.com'
]

{ #category : #rendering }
PREditorHandler >> renderLinksOn: html [
	self renderDefaultLinksOn: html.
	self renderStructureLinksOn: html.
	self renderValueLinksOn: html
]

{ #category : #'rendering-parts' }
PREditorHandler >> renderStructureLinks: aStructure level: anInteger on: html [
	(self context structure: aStructure) isValid
		ifFalse: [ ^ self ].
	html option
		value: aStructure absolutePath;
		with: [ html space: 2 * anInteger; text: aStructure title ].
	(self context enumeratorFor: aStructure)
		do: [ :each | self renderStructureLinks: each level: anInteger + 1 on: html ]
]

{ #category : #'rendering-parts' }
PREditorHandler >> renderStructureLinksOn: html [
	html optionGroup
		label: 'Structures';
		with: [ self renderStructureLinks: self context root level: 0 on: html ]
]

{ #category : #'rendering-parts' }
PREditorHandler >> renderValueLinksOn: html [
	html optionGroup label: 'Values'; with: [
		(Pragma allNamed: #value:comment: in: PRValueLink sortedByArgument: 1) do: [ :pragma |
			html option
				title: pragma arguments second;
				value: 'value:' , pragma arguments first;
				with: pragma arguments first ] ]
]
