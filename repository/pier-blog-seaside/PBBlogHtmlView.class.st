Class {
	#name : #PBBlogHtmlView,
	#superclass : #PBHtmlView,
	#instVars : [
		'posts',
		'batcher'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBBlogHtmlView class >> isAbstract [
	^ false
]

{ #category : #testing }
PBBlogHtmlView class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isBlog ]
]

{ #category : #accessing }
PBBlogHtmlView class >> label [
	^ super label , ' (Blog)'
]

{ #category : #'accessing-dynamic' }
PBBlogHtmlView >> batcher [
	^ batcher ifNil: [ batcher := WABatchedList new items: self posts; batchSize: 5 ]
]

{ #category : #'accessing-dynamic' }
PBBlogHtmlView >> children [
	^ super children, (Array with: self batcher) , (self batcher batch gather: [ :each | each componentsIn: self context ])
]

{ #category : #accessing }
PBBlogHtmlView >> posts [
	"Answer a default collection of posts."
	
	^ posts ifNil: [ posts := super posts reversed ]
]

{ #category : #accessing }
PBBlogHtmlView >> posts: aCollection [
	"Display aCollection of posts in the receiver, presumeably this is a subset of the currently available posts."
	
	posts := aCollection asSortedCollection: [ :a :b | a publication > b publication ].
	batcher := nil
]

{ #category : #rendering }
PBBlogHtmlView >> renderBatcherOn: html [
	(self batcher isOnFirstPage and: [ self batcher isOnLastPage ])
		ifFalse: [ html div class: 'batcher'; with: self batcher ]
]

{ #category : #rendering }
PBBlogHtmlView >> renderContentOn: html [
	super renderContentOn: html.
	self renderPosts: self batcher batch on: html.
	self renderBatcherOn: html.
	self renderRssOn: html
]
