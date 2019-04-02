Extension { #name : #PRStructure }

{ #category : #'*pier-documents-accessing' }
PRStructure >> documents [
	"Answer some additional documents to be displayed and edited using the PRDocumentWidget."
	
	^ self propertyAt: #documents ifAbsentPut: [ Dictionary new ]
]

{ #category : #'*pier-documents-accessing' }
PRStructure >> magritteDescription [ 
	| documents |
	documents := self documents.
	documents isEmpty ifTrue: [ ^ super magritteDescription ].

	^ super magritteDescription copy
		addAll: (documents keys collect: [ :each |
			PRDocumentWidgetDescription new
				parameterName: 'default';
				accessor: (PRDocumentWidgetAccessor on: #documents key: each);
				label: 'Default';
				priority: 120;
				yourself ]);
		yourself
]
