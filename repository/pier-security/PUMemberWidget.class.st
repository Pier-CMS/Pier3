Class {
	#name : #PUMemberWidget,
	#superclass : #PRWidget,
	#instVars : [
		'report'
	],
	#category : #'Pier-Security-Widgets'
}

{ #category : #accessing }
PUMemberWidget class >> groupLabel [
	^ 'Pier System'
]

{ #category : #actions }
PUMemberWidget >> add: aString [
	aString isEmptyOrNil
		ifTrue: [ ^ self ].
	self members do: [ :each |
		each name = aString ifTrue: [ 
			self show: (WAFormDialog new
				addMessage: 'A member with the name ' , aString printString , ' already exists.';
				yourself) ] ].
	self
		edit: (self memberClass named: aString) title: 'Add'
		do: [ :member | 
			self members add: member.
			self refresh	]
]

{ #category : #private }
PUMemberWidget >> buildReport [
	| component members |
	members := self members asArray.
	component := MAReport
		rows: members
		description: (members first magritteDescription
			select: [ :each | each hasProperty: #report ]).
	component addColumn: (MACommandColumn new
		visible: self isSuperuser;
		addCommandOn: self selector: #edit: text: 'edit';
		addCommandOn: self selector: #remove: text: 'remove';
		yourself).
	^ component
]

{ #category : #accessing }
PUMemberWidget >> children [
	^ Array with: self report
]

{ #category : #actions }
PUMemberWidget >> edit: aMember [
	self edit: aMember title: 'Edit' do: [ :member | self refresh ]
]

{ #category : #actions }
PUMemberWidget >> edit: aMember title: aString do: aBlock [
	self isSuperuser 
		ifFalse: [ ^ nil ].
	self 
		show: (aMember asComponent
			addMessage: aString;
			addValidatedForm;
			yourself)
		onAnswer: [ :answer | 
			answer notNil
				ifTrue: [ aBlock value: answer ] ]
]

{ #category : #accessing }
PUMemberWidget >> memberClass [
	self subclassResponsibility
]

{ #category : #accessing }
PUMemberWidget >> members [
	self subclassResponsibility
]

{ #category : #events }
PUMemberWidget >> onChangeContext: aContext [
	super onChangeContext: aContext.
	self report columns last visible: self isSuperuser
]

{ #category : #actions }
PUMemberWidget >> refresh [
	self report rows: self members asArray
]

{ #category : #actions }
PUMemberWidget >> remove: aMember [
	self remove: aMember do: [ :answer | ]
]

{ #category : #actions }
PUMemberWidget >> remove: aMember do: aBlock [
	self isSuperuser 
		ifFalse: [ ^ nil ].
	self
		show: (WAYesOrNoDialog new
			addMessage: 'Are you sure to remove ' , aMember name printString , '?';
			yourself)
		onAnswer: [ :answer |
			answer ifTrue: [
				self members remove: aMember.
				self refresh.
				aBlock value: aMember ] ]
]

{ #category : #rendering }
PUMemberWidget >> renderAddOn: html [
	self isSuperuser
		ifFalse: [ ^ self ].
	html break.
	html form: [
		html textInput
			callback: [ :value | self add: value ].
		html submitButton
			text: 'add' ]
]

{ #category : #rendering }
PUMemberWidget >> renderContentOn: html [
	self renderReportOn: html.
	self renderAddOn: html
]

{ #category : #rendering }
PUMemberWidget >> renderReportOn: html [
	html render: self report
]

{ #category : #accessing }
PUMemberWidget >> report [
	^ report ifNil: [ report := self buildReport ]
]
