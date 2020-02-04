Class {
	#name : #PRViewsWidget,
	#superclass : #PRListWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-default' }
PRViewsWidget class >> defaultViewClasses [
	^ ((Array withAll: PRViewComponent withAllConcreteClasses)
		select: [ :each | each isListed ])
		sort: [ :a :b | a label caseInsensitiveLessOrEqual: b label ];
		yourself
]

{ #category : #testing }
PRViewsWidget class >> isAbstract [
	^ false
]

{ #category : #converting }
PRViewsWidget class >> label [
	^ 'Views'
]

{ #category : #'accessing-description' }
PRViewsWidget >> descriptionViewClasses [
	<magritteDescription>
	^ MAMultipleOptionDescription new
		default: self class defaultViewClasses;
		options: self class defaultViewClasses;
		componentClass: MAListCompositonComponent;
		reference: MAClassDescription new;
		accessor: #viewClasses;
		label: 'View Classes';
		priority: 200;
		beOrdered;
		beDistinct;
		beSorted;
		yourself
]

{ #category : #accessing }
PRViewsWidget >> items [
	| views |
	views := self context views.
	^ self viewClasses select: [ :each | views includes: each ]
]

{ #category : #accessing }
PRViewsWidget >> labelFor: anObject [
	^ anObject label
]

{ #category : #rendering }
PRViewsWidget >> renderItem: aClass on: html [
	html anchor
		title: aClass label;
		class: 'active' if: (self isActive: aClass);
		goto: (self context view: aClass);
		with: (self labelFor: aClass)
]

{ #category : #accessing }
PRViewsWidget >> selected [
	^ self context command isView
		ifTrue: [ self context command viewComponent class ]
]

{ #category : #accessing }
PRViewsWidget >> viewClasses [
	^ self readUsing: self descriptionViewClasses
]

{ #category : #accessing }
PRViewsWidget >> viewClasses: viewClasses [
	self write: viewClasses using: self descriptionViewClasses
]
