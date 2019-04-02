Extension { #name : #PRStructure }

{ #category : #'*pier-admin' }
PRStructure >> descriptionEditingEnvironment [
	<magritteDescription>
	^ PRStructureDescription new
		accessor: #localEditingEnvironment;
		group: 'Layout Settings';
		label: 'Editing Template';
		priority: 810;
		beSetting;
		yourself
]

{ #category : #'*pier-admin' }
PRStructure >> editingEnvironment [
	"Answer the (inherited) environment structure of the receiver, if none is available a default one is created."

	^ self localEditingEnvironment ifNil: [
		self isRoot
			ifTrue: [ 
				self localEditingEnvironment: self class emptyEnvironment. 
				self localEditingEnvironment ]
			ifFalse: [ self parent editingEnvironment ] ]
]

{ #category : #'*pier-admin' }
PRStructure class >> emptyEnvironment [
	^ (PRComponent named: 'emptyEnvironment') prototypeInstance: PRContentsWidget new; yourself
]

{ #category : #'*pier-admin' }
PRStructure >> localEditingEnvironment [
	^ self propertyAt: #localEditingEnvironment ifAbsent: [ nil ]
]

{ #category : #'*pier-admin' }
PRStructure >> localEditingEnvironment: aStructure [
	self propertyAt: #localEditingEnvironment put: aStructure
]
