Class {
	#name : #PBPostFilter,
	#superclass : #PRWidget,
	#instVars : [
		'blog',
		'showCount',
		'maxItems'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #accessing }
PBPostFilter class >> groupLabel [
	^ 'Pier Blog'
]

{ #category : #accessing }
PBPostFilter >> blog [
	"Answer the currently browsed blog or nil."
	
	^ blog ifNil: [ blog := self findBlog ]
]

{ #category : #'accessing-descriptions' }
PBPostFilter >> descriptionMaxItems [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The maximum number of items to show.';
		parameterName: 'max-items';
		accessor: #maxItems;
		label: 'Max Items';
		priority: 200;
		default: 10;
		bePositive;
		beInteger;
		yourself
]

{ #category : #'accessing-descriptions' }
PBPostFilter >> descriptionShowCount [
	<magritteDescription>
	^ MABooleanDescription new
		parameterName: 'show-count';
		accessor: #showCount;
		label: 'Show Count';
		default: true;
		priority: 210;
		yourself
]

{ #category : #actions }
PBPostFilter >> filter: aCollection [
	| newContext |
	newContext := self context structure: self blog.
	newContext command viewComponent posts: aCollection.
	self context: newContext
]

{ #category : #private }
PBPostFilter >> findBlog [
	^ self context structure findAncestor: [ :each | each isBlog ]
]

{ #category : #private }
PBPostFilter >> findPost [
	^ self context structure findAncestor: [ :each | each isPost ]
]

{ #category : #accessing }
PBPostFilter >> maxItems [
	^ maxItems
]

{ #category : #accessing }
PBPostFilter >> maxItems: anObject [
	maxItems := anObject
]

{ #category : #events }
PBPostFilter >> onChangeContext: aContext [
	super onChangeContext: aContext.
	self blog = self findBlog
		ifFalse: [ self refresh ]
]

{ #category : #accessing }
PBPostFilter >> posts [
	"Answer the currently displayed blog posts."
	
	^ self blog allPostsIn: self context
]

{ #category : #actions }
PBPostFilter >> refresh [
	blog := nil
]

{ #category : #rendering }
PBPostFilter >> renderBlogOn: html [
	self subclassResponsibility
]

{ #category : #rendering }
PBPostFilter >> renderContentOn: html [
	self blog isNil
		ifTrue: [ html text: '(no blog found)' ]
		ifFalse: [ self renderBlogOn: html ]
]

{ #category : #rendering }
PBPostFilter >> renderFilter: aCollection with: aRenderBlock on: html [
	html anchor
		callback: [ self filter: aCollection ];
		with: aRenderBlock.
	self showCount
		ifTrue: [ html text: ' ('; render: aCollection size; text: ')' ]
]

{ #category : #accessing }
PBPostFilter >> showCount [
	^ showCount
]

{ #category : #accessing }
PBPostFilter >> showCount: anObject [
	showCount := anObject
]
