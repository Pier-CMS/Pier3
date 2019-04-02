Class {
	#name : #PRFileSettings,
	#superclass : #PRWidget,
	#instVars : [
		'component',
		'model'
	],
	#category : #'Pier-Security-Widgets'
}

{ #category : #accessing }
PRFileSettings class >> groupLabel [
	^ 'Pier Settings'
]

{ #category : #testing }
PRFileSettings class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRFileSettings class >> label [
	^ 'File Settings'
]

{ #category : #accessing }
PRFileSettings >> children [
	^ Array with: component
]

{ #category : #initialization }
PRFileSettings >> initialize [
	super initialize.
	component := (self magritteDescription asComponentOn: self)
		addValidatedForm;
		yourself
]

{ #category : #accessing }
PRFileSettings >> magritteDescription [
	^ MAContainer new
		add: (MAStringDescription new
			label: 'Base Directory';
			accessor: #baseDirectoryPath;
			comment: 'Defines the base-directory where the files are stored. If this field is left empty, it default to a subdirectory of of the current image-location.';
			yourself);
		add: (MAStringDescription new
			label: 'Base URL';
			accessor: #baseUrl;
			comment: 'Defines the base-URL where the files are served from, when using an external web server. if this field is left empty, files are served through the image.';
			yourself);
		yourself
]

{ #category : #accessing }
PRFileSettings >> model [
	^ model ifNil: [
		model := PRFile new fileModel ]
]

{ #category : #dispatching }
PRFileSettings >> readUsing: aDescription [
	^ self model readUsing: aDescription
		
]

{ #category : #rendering }
PRFileSettings >> renderContentOn: html [
	self isSuperuser
		ifFalse: [ ^ html paragraph: 'Only adminstrators can edit the file settings.' ].
	html render: self children
]

{ #category : #dispatching }
PRFileSettings >> write: anObject using: aDescription [
	^ self model write: anObject using: aDescription
]
