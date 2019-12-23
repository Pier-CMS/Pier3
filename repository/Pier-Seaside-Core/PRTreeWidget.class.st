Class {
	#name : #PRTreeWidget,
	#superclass : #PRStructuresWidget,
	#instVars : [
		'expanded'
	],
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-defaults' }
PRTreeWidget class >> defaultAutoCollapse [
	^ true
]

{ #category : #'accessing-defaults' }
PRTreeWidget class >> defaultAutoExpand [
	^ true
]

{ #category : #'accessing-defaults' }
PRTreeWidget class >> defaultDisplayRoot [
	^ true
]

{ #category : #'accessing-defaults' }
PRTreeWidget class >> defaultLevel [
	^ nil
]

{ #category : #testing }
PRTreeWidget class >> isAbstract [
	^ false
]

{ #category : #converting }
PRTreeWidget class >> label [
	^ 'Tree'
]

{ #category : #'accessing-properties' }
PRTreeWidget >> autoCollapse [
	^ self readUsing: self descriptionAutoCollapse
]

{ #category : #'accessing-properties' }
PRTreeWidget >> autoCollapse: autoCollapse [ 
	self write: autoCollapse using: self descriptionAutoCollapse
]

{ #category : #'accessing-properties' }
PRTreeWidget >> autoExpand [
	^ self readUsing: self descriptionAutoExpand
]

{ #category : #'accessing-properties' }
PRTreeWidget >> autoExpand: autoExpand [
	self write: autoExpand using: self descriptionAutoExpand
]

{ #category : #actions }
PRTreeWidget >> collapseStructure: aStructure [
	expanded remove: aStructure ifAbsent: [ "should never happen" ]
]

{ #category : #'accessing-description' }
PRTreeWidget >> descriptionAutoCollapse [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Automatically collaps structures not currently active.';
		default: self class defaultAutoCollapse;
		parameterName: 'auto-collapse';
		accessor: #autoCollapse;
		label: 'Auto Collapse';
		priority: 310;
		yourself
]

{ #category : #'accessing-description' }
PRTreeWidget >> descriptionAutoExpand [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Automatically expand to current structure.';
		default: self class defaultAutoExpand;
		parameterName: 'auto-expand';
		accessor: #autoExpand;
		label: 'Auto Expand';
		priority: 300;
		yourself
]

{ #category : #'accessing-description' }
PRTreeWidget >> descriptionDisplayRoot [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Whether the root node of the tree should be displayed';
		default: self class defaultDisplayRoot;
		parameterName: 'display-root';
		accessor: #displayRoot;
		label: 'Display Root';
		priority: 320;
		yourself
]

{ #category : #'accessing-description' }
PRTreeWidget >> descriptionDropdownList [
	<magritteDescription>
	^ nil
]

{ #category : #'accessing-description' }
PRTreeWidget >> descriptionLevel [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The level from which the tree should be displayed.';
		default: self class defaultLevel;
		parameterName: 'level';
		accessor: #level;
		label: 'Level';
		priority: 230;
		beInteger;
		min: 0;
		yourself
]

{ #category : #'accessing-properties' }
PRTreeWidget >> displayRoot [
	^ self readUsing: self descriptionDisplayRoot
]

{ #category : #'accessing-properties' }
PRTreeWidget >> displayRoot: displayRoot [
	self write: displayRoot using: self descriptionDisplayRoot
]

{ #category : #'accessing-properties' }
PRTreeWidget >> dropdownList [
	^ false
]

{ #category : #actions }
PRTreeWidget >> expandStructure: aStructure [
	expanded add: aStructure
]

{ #category : #initialization }
PRTreeWidget >> initialize [
	super initialize.
	expanded := Set new
]

{ #category : #testing }
PRTreeWidget >> isExpanded: aNode [
	^ expanded includes: aNode
]

{ #category : #'accessing-properties' }
PRTreeWidget >> level [
	^ self readUsing: self descriptionLevel
]

{ #category : #'accessing-properties' }
PRTreeWidget >> level: aLevel [
	self write: aLevel using: self descriptionLevel

]

{ #category : #events }
PRTreeWidget >> onChangeContext: aContext [
	super onChangeContext: aContext.
	self autoCollapse
		ifTrue: [ expanded removeAll: expanded copy ].
	self autoExpand
		ifTrue: [ expanded addAll: aContext structure parents ]
]

{ #category : #rendering }
PRTreeWidget >> renderContentOn: html [
	| root |
	root := self context root.
	self level notNil ifTrue: [
		root := self context structure parents
			at: self level
			ifAbsent: [ ^ self ] ].
	self displayRoot
		ifFalse: [ self renderStructureChildren: root on: html ]
		ifTrue: [ html unorderedList: [ self renderStructure: root on: html ] ]
]

{ #category : #'rendering-items' }
PRTreeWidget >> renderStructure: aStructure on: html [
	html listItem: [
		self renderStructureButton: aStructure on: html.
		self renderStructureLabel: aStructure on: html.
		self renderStructureChildren: aStructure on: html ]
]

{ #category : #'rendering-items' }
PRTreeWidget >> renderStructureButton: aStructure on: html [
	| isExpanded |
	html span class: 'button'; with: [
		(self childrenOf: aStructure) isEmpty
			ifTrue: [ html space ]
			ifFalse: [
				isExpanded := self isExpanded: aStructure.
				html anchor
					callback: [
						isExpanded
							ifTrue: [ self collapseStructure: aStructure ]
							ifFalse: [ self expandStructure: aStructure ] ];
					with: (isExpanded
						ifTrue: [ '-' ]
						ifFalse: [ '+' ]) ] ]
]

{ #category : #'rendering-items' }
PRTreeWidget >> renderStructureChildren: aStructure on: html [
	| children |
	(self isExpanded: aStructure)
		ifFalse: [ ^ self ].
	children := self childrenOf: aStructure.
	children isEmpty ifTrue: [ ^ self ].
	html unorderedList: [
		children do: [ :each |
			self renderStructure: each on: html ] ]
]

{ #category : #'rendering-items' }
PRTreeWidget >> renderStructureLabel: aStructure on: html [
	self renderItem: aStructure on: html
]

{ #category : #accessing }
PRTreeWidget >> states [
	^ Array with: expanded
]

{ #category : #accessing }
PRTreeWidget >> unfilteredItems [
	self shouldNotImplement
]
