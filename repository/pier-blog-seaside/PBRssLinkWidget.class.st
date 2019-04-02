Class {
	#name : #PBRssLinkWidget,
	#superclass : #PRWidget,
	#instVars : [
		'blog'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #accessing }
PBRssLinkWidget class >> groupLabel [
	^ 'Pier Blog'
]

{ #category : #testing }
PBRssLinkWidget class >> isAbstract [
	^false
]

{ #category : #accessing }
PBRssLinkWidget class >> label [
	^ 'Links'
]

{ #category : #accessing }
PBRssLinkWidget >> blog [
	^ blog
]

{ #category : #accessing }
PBRssLinkWidget >> blog: anObject [
	blog := anObject
]

{ #category : #accessing }
PBRssLinkWidget >> descriptionBlog [
	<magritteDescription>
	^ PRStructureDescription new
		addCondition: (MACondition selector: #isBlog) labelled: 'Select a blog as source';
		accessor: #blog;
		label: 'Source';
		priority: 100;
		yourself
]

{ #category : #rendering }
PBRssLinkWidget >> renderContentOn: html [
	self blog isNil 
		ifTrue: [ ^ html div: '(no blog specified)' ].
	html anchor 
		url: (self context
			structure: self blog
			view: PBEntriesRssView)
				url;
		with: [ html span class: 'rsslink'; with: 'RSS' ]
]
