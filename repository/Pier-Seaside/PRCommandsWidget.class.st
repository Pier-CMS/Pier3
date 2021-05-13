Class {
	#name : #PRCommandsWidget,
	#superclass : #PRListWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-defaults' }
PRCommandsWidget class >> defaultCommandClasses [
	^ (Array withAll: PRCommand withAllConcreteClasses)
		sort: [ :a :b | a label caseInsensitiveLessOrEqual: b label ];
		yourself
]

{ #category : #testing }
PRCommandsWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRCommandsWidget class >> label [
	^ 'Commands'
]

{ #category : #accessing }
PRCommandsWidget >> commandClasses [
	^ self readUsing: self descriptionCommandClasses
]

{ #category : #accessing }
PRCommandsWidget >> commandClasses: commandClasses [
	self write: commandClasses using: self descriptionCommandClasses
]

{ #category : #'accessing-description' }
PRCommandsWidget >> descriptionCommandClasses [
	<magritteDescription>
	^ MAMultipleOptionDescription new
		default: self class defaultCommandClasses;
		options: self class defaultCommandClasses;
		componentClass: MAListCompositionComponent;
		reference: MAClassDescription new;
		accessor: #commandClasses;
		label: 'Command Classes';
		priority: 200;
		beOrdered;
		beDistinct;
		beSorted;
		yourself
]

{ #category : #accessing }
PRCommandsWidget >> items [
	| commands |
	commands := self context commands.
	^ self commandClasses select: [ :each | commands includes: each ]
]

{ #category : #accessing }
PRCommandsWidget >> labelFor: anObject [
	^ anObject shortLabel
]

{ #category : #rendering }
PRCommandsWidget >> renderItem: aClass on: html [
	html anchor
		class: 'active' if: (self isActive: aClass);
		accessKey: aClass accessKey;
		goto: (self context
			structure: self context structure
			command: aClass new);
		with: (self labelFor: aClass)
]

{ #category : #accessing }
PRCommandsWidget >> selected [
	^ self context command class
]
