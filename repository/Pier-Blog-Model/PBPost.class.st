Class {
	#name : #PBPost,
	#superclass : #PBEntry,
	#instVars : [
		'sourceUrl',
		'sourceTitle',
		'enclosure'
	],
	#category : #'Pier-Blog-Model'
}

{ #category : #testing }
PBPost class >> canBeChildOf: aClass [
	^ aClass includesBehavior: PBBlog
]

{ #category : #accessing }
PBPost class >> label [
	^ 'Blog Post'
]

{ #category : #visiting }
PBPost >> accept: aVisitor [
	aVisitor visitPost: self
]

{ #category : #'accessing-descriptions' }
PBPost >> descriptionEnclosure [
	<magritteDescription>
	^ PRStructureDescription new
		addCondition: (MACondition selector: #isFile) labelled: 'Enclosure must be a file';
		comment: 'A media object that is attached to the item.';
		accessor: #enclosure;
		label: 'Enclosure';
		priority: 350;
		beEditable;
		yourself
]

{ #category : #'accessing-descriptions' }
PBPost >> descriptionSourceTitle [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #sourceTitle;
		comment: 'The title of the RSS channel the item came from.';
		label: 'Source Title';
		priority: 330;
		beEditable;
		yourself
]

{ #category : #'accessing-descriptions' }
PBPost >> descriptionSourceUrl [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #sourceUrl;
		comment: 'The URL of the RSS channel the item came from.';
		label: 'Source URL';
		priority: 340;
		beEditable;
		yourself
]

{ #category : #'accessing-descriptions' }
PBPost >> descriptionTags [
	<magritteDescription>
	^ super descriptionTags
		priority: 110;
		beEditable;
		yourself
]

{ #category : #accessing }
PBPost >> enclosure [
	^ enclosure
]

{ #category : #accessing }
PBPost >> enclosure: aFile [
	enclosure := aFile
]

{ #category : #testing }
PBPost >> isPost [
	^ true
]

{ #category : #accessing }
PBPost >> sourceTitle [
	^ sourceTitle
]

{ #category : #accessing }
PBPost >> sourceTitle: aString [
	sourceTitle := aString
]

{ #category : #accessing }
PBPost >> sourceUrl [
	^ sourceUrl
]

{ #category : #accessing }
PBPost >> sourceUrl: aString [
	sourceUrl := aString
]
