Class {
	#name : #PRDocumentWidget,
	#superclass : #PRWidget,
	#instVars : [
		'specification',
		'default',
		'inherited'
	],
	#category : #'Pier-Documents'
}

{ #category : #testing }
PRDocumentWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRDocumentWidget class >> label [
	^ 'Document'
]

{ #category : #private }
PRDocumentWidget >> buildSpecification [
	^ self descriptionDefault
		accessor: (PRDocumentWidgetAccessor on: #documents key: self owner name);
		yourself
]

{ #category : #accessing }
PRDocumentWidget >> children [
	^ (PROutgoingReferences on: self document) embeddedComponents
		collect: [ :each | self context componentFor: each ]
]

{ #category : #accessing }
PRDocumentWidget >> default [
	^ default
]

{ #category : #accessing }
PRDocumentWidget >> default: anObject [
	default := anObject
]

{ #category : #'accessing-descriptions' }
PRDocumentWidget >> descriptionDefault [
	<magritteDescription>
	^ PRDocumentWidgetDescription new
		parameterName: 'default';
		accessor: #default;
		label: 'Default';
		priority: 120;
		yourself
]

{ #category : #'accessing-descriptions' }
PRDocumentWidget >> descriptionInherited [
	<magritteDescription>
	^ MABooleanDescription new
		parameterName: 'inherited';
		accessor: #inherited;
		label: 'Inherited';
		default: false;
		priority: 110;
		beRequired;
		yourself
]

{ #category : #accessing }
PRDocumentWidget >> document [
	^ self documentOf: self context structure
]

{ #category : #accessing }
PRDocumentWidget >> documentOf: aStructure [
	"Answer the document to be displayed."

	^ (self specification accessor read: aStructure) ifNil: [
		(self inherited and: [ aStructure parent notNil ])
			ifTrue: [ self documentOf: aStructure parent ]
			ifFalse: [ self default ] ]
]

{ #category : #accessing }
PRDocumentWidget >> inherited [
	^ inherited
]

{ #category : #accessing }
PRDocumentWidget >> inherited: anObject [
	inherited := anObject
]

{ #category : #testing }
PRDocumentWidget >> isEditing [
	^ self context command isEdit
]

{ #category : #rendering }
PRDocumentWidget >> renderContentOn: html [
	self isEditing 
		ifTrue: [ self renderEditOn: html ] 
		ifFalse: [ self renderViewOn: html ]
]

{ #category : #rendering }
PRDocumentWidget >> renderEditOn: html [
	| id |
	html textArea
		value: self text;
		class: 'wiki-inline';
		id: (id := html nextId);
		callback: [ :value | self text: value ];
		onKeyUp: 'pier_document_widget_update(' , id asJavascript , ')'.
	html document
		addLoadScript: 'pier_document_widget_register(' , id asJavascript , ')'
]

{ #category : #rendering }
PRDocumentWidget >> renderViewOn: html [
	html rendererInstance withinContentDo: [ 
		html rendererInstance
			continue: self document 
			in: self on: html ]
]

{ #category : #accessing }
PRDocumentWidget >> script [
	^ self isEditing ifTrue: [ 
'function pier_document_widget_update(id) {
	var source = document.getElementById(id);
	var target = document.getElementById(id + "_copy");
	target.value = source.value;
}
function pier_document_widget_register(id) {
	for (i = 0; i < document.forms.length; i++) {
		var form = document.forms[i];
		if (new RegExp("(^|\\s)magritte(\\s|$)").test(form.className)) {
			var source = document.getElementById(id);
			var target = document.createElement("input");
			target.setAttribute("name", source.name);
			target.setAttribute("id", id + "_copy");
			target.setAttribute("type", "hidden");
			form.appendChild(target);
			pier_document_widget_update(id);
			return;
		}
	}
}' ]
]

{ #category : #accessing }
PRDocumentWidget >> specification [
	"Answer a description representing the receiving document."
	
	^ specification ifNil: [ specification := self buildSpecification ]
]

{ #category : #'accessing-editing' }
PRDocumentWidget >> text [
	^ self specification 
		toString: (self context command fields 
			at: self specification
			ifAbsentPut: [ 
				self specification accessor
					read: self context structure ])
]

{ #category : #'accessing-editing' }
PRDocumentWidget >> text: aString [
	| document |
	document := self specification fromString: aString.
	document isNil
		ifFalse: [ document owner: self context structure ].
	self context command fields
		at: self specification
		put: document
]
