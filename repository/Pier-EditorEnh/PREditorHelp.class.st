Class {
	#name : #PREditorHelp,
	#superclass : #PRRawView,
	#instVars : [
		'structure'
	],
	#category : #'Pier-EditorEnh'
}

{ #category : #testing }
PREditorHelp class >> isAbstract [
	^ false
]

{ #category : #testing }
PREditorHelp class >> isListed [
	^ false
]

{ #category : #testing }
PREditorHelp class >> isValidIn: aContext [
	^ true
]

{ #category : #accessing }
PREditorHelp class >> label [
	^ 'Help'
]

{ #category : #responding }
PREditorHelp >> respondUsing: aResponse [
	super respondUsing: aResponse.
	aResponse
		cacheForever;
		contentType: 'text/html';
		nextPutAll: (self rendererClass builder
			fullDocument: true;
			rootBlock: [ :root | self updateRoot: root ];
			render: [ :html | | renderer |
				renderer := PRViewRenderer new.
				renderer withinContentDo: [
					renderer
					start: self structure
					in: self on: html ] ])
]

{ #category : #accessing }
PREditorHelp >> structure [
	^ structure ifNil: [ structure := PRKernel defaultInfoSyntax ]
]

{ #category : #accessing }
PREditorHelp >> style [
	^ 'html {
	color: #111;
	font-size: 85%;
	line-height: 1.5;
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
}
body, table, tr, td, th {
	color: inherit;
	text-align: left;
	font-size: inherit;
	vertical-align: top;
	font-family: inherit;
}

table { margin: 1em 0; }
ul, ol { padding-left: 2em; }

code {
	padding: 2px;
	font-size: 1.2em;
	background-color: #ddd;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
}'
]

{ #category : #responding }
PREditorHelp >> updateRoot: aHtmlRoot [
	super updateRoot: aHtmlRoot.
	aHtmlRoot title: 'Pier Syntax'
]
