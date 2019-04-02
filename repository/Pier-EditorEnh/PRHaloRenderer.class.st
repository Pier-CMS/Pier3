Class {
	#name : #PRHaloRenderer,
	#superclass : #PRViewRenderer,
	#category : #'Pier-EditorEnh'
}

{ #category : #buttons }
PRHaloRenderer >> editContextFor: aContext [
	<button: 'Edit' class: 'pr-edit' priority: 2.0>
	
	^ aContext command: PREditCommand new
]

{ #category : #buttons }
PRHaloRenderer >> groupContextFor: aContext [
	<button: 'Change Group' class: 'pr-group' priority: 4.1>
	
	^ aContext command: PUChangeOwner new
]

{ #category : #buttons }
PRHaloRenderer >> moveContextFor: aContext [
	<button: 'Move' class: 'pr-move' priority: 3.0>
	
	^ aContext command: PRMoveCommand new
]

{ #category : #buttons }
PRHaloRenderer >> otherContextFor: aContext [
	<button: 'Change Other' class: 'pr-other' priority: 4.2>
	
	^ aContext command: PUChangeOther new
]

{ #category : #buttons }
PRHaloRenderer >> ownerContextFor: aContext [
	<button: 'Change Owner' class: 'pr-owner' priority: 4.0>
	
	^ aContext command: PUChangeOwner new
]

{ #category : #buttons }
PRHaloRenderer >> removeContextFor: aContext [
	<button: 'Remove' class: 'pr-remove' priority: 3.1>
	
	^ aContext command: PRRemoveCommand new
]

{ #category : #public }
PRHaloRenderer >> renderButtonsFor: aStructure in: aContext [
	| priority answer context |
	priority := 1.
	answer := aContext view: PRHaloView.
	(Pragma allNamed: #button:class:priority: in: self class sortedByArgument: 3)
		do: [ :pragma | 
			priority = pragma arguments third truncated
				ifFalse: [ html div ].
			priority := pragma arguments third truncated.
			context := self perform: pragma methodSelector with: (aContext structure: aStructure).
			context isValid
				ifTrue: [ context command
						successAnswer: answer;
						cancelAnswer: answer.
					html anchor
						goto: context;
						attributeAt: 'title' put: pragma arguments first;
						attributeAt: 'class' put: pragma arguments second;
						with: [ html span ] ] ]
]

{ #category : #buttons }
PRHaloRenderer >> settingsContextFor: aContext [
	<button: 'Settings' class: 'pr-settings' priority: 2.1>
	
	^ aContext command: PRSettingsCommand new
]

{ #category : #public }
PRHaloRenderer >> structure: aStructure during: aBlock [
	html div
		class: 'pr-halo';
		script: PRHaloShine new;
		title: (self titleFor: aStructure);
		with: [
			html div
				class: 'pr-halo-tools';
				with: [ self renderButtonsFor: aStructure in: self context ].
			super structure: aStructure during: aBlock ]
]

{ #category : #public }
PRHaloRenderer >> titleFor: aStructure [
	^ aStructure title , ' - ' , aStructure absolutePath
]

{ #category : #buttons }
PRHaloRenderer >> viewContextFor: aContext [
	<button: 'Browse' class: 'pr-view' priority: 1.0>
	
	^ aContext view: PRHaloView
]
