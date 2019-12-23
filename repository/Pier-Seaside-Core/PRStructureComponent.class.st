Class {
	#name : #PRStructureComponent,
	#superclass : #MATextInputComponent,
	#category : #'Pier-Seaside-Magritte'
}

{ #category : #actions }
PRStructureComponent >> choose [
	| tree |
	tree := WATree root: self context root path: self context structure parents.
	tree
		labelBlock: [ :structure | structure title ];
		childrenBlock: [ :structure |
			(self context enumeratorFor: structure)
				contents ];
		canSelectBlock: [ :structure | 
			self magritteDescription isSatisfiedBy: structure ].
	self chooser: tree
]

{ #category : #rendering }
PRStructureComponent >> renderEditorOn: html [
	super renderEditorOn: html.
	html submitButton on: #choose of: self
]

{ #category : #rendering }
PRStructureComponent >> renderViewerOn: html [
	self value isNil
		ifTrue: [ ^ html render: self string ].
	html anchor
		goto: (self context structure: self value);
		with: self string
]
