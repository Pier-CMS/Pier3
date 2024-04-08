Class {
	#name : #PBPostHtmlView,
	#superclass : #PBHtmlView,
	#instVars : [
		'post',
		'comment',
		'command',
		'component'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBPostHtmlView class >> isAbstract [
	^ false
]

{ #category : #testing }
PBPostHtmlView class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isPost ]
]

{ #category : #accessing }
PBPostHtmlView class >> label [
	^ super label , ' (Post)'
]

{ #category : #private }
PBPostHtmlView >> buildCommand [
	^ (self context
		structure: self comment
		command: self comment editCommandClass new)
			command
]

{ #category : #private }
PBPostHtmlView >> buildComment [
	^ PBComment new
		title: self context structure title;
		yourself
]

{ #category : #private }
PBPostHtmlView >> buildComponent [
	^ (self buildDescription asComponentOn: self command)
		onAnswer: [ :result | self execute: result ];
		addValidatedForm;
		yourself
]

{ #category : #private }
PBPostHtmlView >> buildDescription [
	^ self command magritteDescription select: [ :each |
		each propertyAt: #public ifAbsent: [ false ] ]
]

{ #category : #accessing }
PBPostHtmlView >> children [
	^ super children, (Array with: self component)
]

{ #category : #accessing }
PBPostHtmlView >> command [
	^ command ifNil: [ command := self buildCommand ]
]

{ #category : #accessing }
PBPostHtmlView >> comment [
	^ comment ifNil: [ comment := self buildComment ]
]

{ #category : #accessing }
PBPostHtmlView >> comments [
	^ self context structure allCommentsIn: self context
]

{ #category : #accessing }
PBPostHtmlView >> component [
	^ component ifNil: [ component := self buildComponent ]
]

{ #category : #private }
PBPostHtmlView >> execute: anEditCommand [

	| addCommand |
	comment := component := command := nil.
	anEditCommand ifNil: [ ^ self ].
	addCommand := PRAddCommand new.
	self context command: addCommand.
	addCommand
		name: (addCommand uniqueName: 'comment' in: self context structure);
		type: #############PBComment;
		beUnchecked;
		execute.
	self context
		structure: addCommand successAnswer structure
		command: anEditCommand.
	anEditCommand
		beUnchecked;
		execute
]

{ #category : #testing }
PBPostHtmlView >> isCommentEnabled [
	^ self post publication notNil and: [ self post publication + self blog commentTimeout >= GRPlatform current magritteTimeStampClass now ]
]

{ #category : #accessing }
PBPostHtmlView >> post [
	^ post ifNil: [ post := self find: PBPost ]
]

{ #category : #rendering }
PBPostHtmlView >> renderAuthor: anEntry on: html [
	(anEntry isPost or: [ anEntry website isEmptyOrNil ])
		ifTrue: [ ^ super renderAuthor: anEntry on: html ].
	html span class: 'author'; with: [
		html text: 'by '.
		html anchor
			url: anEntry website;
			with: (anEntry author
				ifNil: [ anEntry website ]) ].
	html text: ' '
]

{ #category : #rendering }
PBPostHtmlView >> renderComments: aCollection on: html [
	html anchor name: #comments.
	aCollection isEmpty
		ifFalse: [
			html heading level: 2; with: 'Comments' ].
	aCollection do: [ :each |
		html div class: 'comment'; with: [
			html anchor name: each uuid.
			self render: each on: html.
			self renderMeta: each on: html ] ]
]

{ #category : #rendering }
PBPostHtmlView >> renderContentOn: html [
	self render: self post on: html.
	self renderMeta: self post on: html.
	html div class: 'comments'; with: [
		self renderComments: self comments on: html.
		self isCommentEnabled
			ifTrue: [ self renderLeaveCommentOn: html ] ].
	self renderRssOn: html
]

{ #category : #rendering }
PBPostHtmlView >> renderLeaveCommentOn: html [
	html div class: 'leavecomment'; with: [
		html heading level: 2; with: 'Leave your comment'.
		html render: self component ]
]
