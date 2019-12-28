Class {
	#name : #PRBreadcrumbWidget,
	#superclass : #PRStructuresWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-defaults' }
PRBreadcrumbWidget class >> defaultAllButLast [
	^ false
]

{ #category : #testing }
PRBreadcrumbWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRBreadcrumbWidget class >> label [
	^ 'Breadcrumb'
]

{ #category : #accessing }
PRBreadcrumbWidget >> allButLast [
	^ self readUsing: self descriptionAllButLast
]

{ #category : #accessing }
PRBreadcrumbWidget >> allButLast: aBoolean [ 
	self write: aBoolean using: self descriptionAllButLast
]

{ #category : #'accessing-descriptions' }
PRBreadcrumbWidget >> descriptionAllButLast [
	<magritteDescription>
	^ MABooleanDescription new
		default: self class defaultAllButLast;
		parameterName: 'all-but-last';
		accessor: #allButLast;
		label: 'All But Last';
		priority: 300;
		yourself
]

{ #category : #accessing }
PRBreadcrumbWidget >> unfilteredItems [
	| items |
	items := self context structure parents.
	self allButLast ifTrue: [ items := items allButLast ].
	^ items
]
