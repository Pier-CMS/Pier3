"
Command to edit the design of the current page. This is a shortcut of the normal edit command on the associated environment pages.
"
Class {
	#name : #PRDesignCommand,
	#superclass : #PRChangeCommand,
	#category : #'Pier-Design'
}

{ #category : #accessing }
PRDesignCommand class >> accessKey [
	^ $d
]

{ #category : #testing }
PRDesignCommand class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRDesignCommand class >> label [
	^ 'Edit Design'
]

{ #category : #private }
PRDesignCommand >> descriptionsForGroup: aString selector: aSelector [
	^ self descriptionsForGroup: aString selector: aSelector index: nil
]

{ #category : #private }
PRDesignCommand >> descriptionsForGroup: aString selector: aSelector index: anInteger [
	"Now this is truly and utterly ugly. Don't look at it, ok?"

	| accessor description |
	accessor := MASelectorAccessor selector: aSelector.
	accessor := anInteger isNil
		            ifTrue: [ PRDocumentAccessor on: accessor ]
		            ifFalse: [
			            MAChainAccessor
				            on: accessor
				            accessor: (MADictionaryAccessor key: anInteger) ].
	description := anInteger isNil
		               ifTrue: [ PRDocumentDescription new ]
		               ifFalse: [ MAMemoDescription new cssClass: 'file' ].
	^ Array
		  with: (PRStructureDescription new
				   accessor: accessor;
				   label: 'Location';
				   group: aString;
				   beReadOnly;
				   yourself)
		  with: (description
				   instVarNamed: 'accessor' put: (MAChainAccessor
						    on: accessor
						    accessor: (MASelectorAccessor selector: (anInteger isNil
										      ifTrue: [ #document ]
										      ifFalse: [ #contents ])));
				   label: 'Contents';
				   group: aString;
				   yourself)
]

{ #category : #events }
PRDesignCommand >> doExecute [
	super doExecute.
	self structure styleSheets do: [ :each |
		each file
			filename: each file filename;	
			mimetype: 'text/css' ]
]

{ #category : #private }
PRDesignCommand >> magritteDescription [
	| description |
	description := MAContainer new.
	description addAll: (self 
		descriptionsForGroup: 'Template'
		selector: #environment).
	self structure styleSheets keysAndValuesDo: [ :index :each | 
		description addAll: (self 
			descriptionsForGroup: 'Style Sheets'
			selector: #styleSheets
			index: index) ].
	^ description
]
