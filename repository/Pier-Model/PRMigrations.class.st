Class {
	#name : #PRMigrations,
	#superclass : #PRBasicObject,
	#category : #'Pier-Model-Utilities'
}

{ #category : #initialization }
PRMigrations class >> initialize [
	self migrateParameters.
	self migrateChildren.
	self migrateTableCells.
	self migrateLinkOwner.
	self migrateObsoleteWidgets.
	self migrateChildrenArray
]

{ #category : #migrations }
PRMigrations class >> migrateChildren [
	GRPlatform current 
		magritteAllSubInstancesOf: PRChildren
		do: 
			[ :each | 
			(each children isKindOf: Dictionary) ifTrue: [ each setChildren: each children asOrderedCollection ] ]
]

{ #category : #migrations }
PRMigrations class >> migrateChildrenArray [
	GRPlatform current magritteAllSubInstancesOf: PRChildren do: [ :each |
		(each children isKindOf: OrderedCollection)
			ifTrue: [ each setChildren: each children ] ]
]

{ #category : #migrations }
PRMigrations class >> migrateLinkOwner [
	GRPlatform current 
		magritteAllSubInstancesOf: PRStructure
		do: 
			[ :structure | 
			structure outgoingReferences
				continue: [ :link | false ];
				do: [ :link | link owner isNil ifTrue: [ link owner: structure ] ] ]
]

{ #category : #migrations }
PRMigrations class >> migrateObsoleteWidgets [
	| componentClass |
	componentClass := (GRPlatform current magritteClassNamed: #PRComponent) ifNil: [ ^ self ].
	GRPlatform current 
		magritteAllSubInstancesOf: componentClass
		do: 
			[ :component | 
			
			[ :className :descriptionSelector | 
			| widgetClass theDescription |
			widgetClass := GRPlatform current magritteClassNamed: className.
			(widgetClass notNil and: [ component componentClass includesBehavior: widgetClass ]) ifTrue: 
				[ theDescription := widgetClass perform: descriptionSelector.
				component settings 
					at: theDescription
					ifPresent: 
						[ :classes | 
						component settings 
							at: theDescription
							put: (classes reject: [ :each | each isObsolete ]) ] ] ]
				value: #PRViewsWidget
					value: #descriptionViewClasses;
				value: #PRCommandsWidget
					value: #descriptionCommandClasses ]
]

{ #category : #migrations }
PRMigrations class >> migrateParameters [
	GRPlatform current 
		magritteAllSubInstancesOf: PRLink
		do: [ :each | each parameters isNil ifTrue: [ each parameters: #() ] ]
]

{ #category : #migrations }
PRMigrations class >> migrateTableCells [
	GRPlatform current 
		magritteAllSubInstancesOf: PRTableCell
		do: [ :each | each heading isNil ifTrue: [ each heading: false ] ]
]
