Class {
	#name : #PRWysiwygEditorComponent,
	#superclass : #PRDocumentComponent,
	#instVars : [
		'editor'
	],
	#category : #'Pier-Wysiwyg'
}

{ #category : #hooks }
PRWysiwygEditorComponent >> children [
	^ Array with: self editor
]

{ #category : #accessing }
PRWysiwygEditorComponent >> editor [
	^ editor ifNil: [
		editor := (PRWysiwygEditor new)
			siteMapSelectCallback: [ :id | self generateSiteMapSelect: id ];
			onFormSubmit: [ :value | self string: value ];
			structureOwner: self context structure;
			yourself.
			
		self setEditorPermissions: editor.
		editor ]
]

{ #category : #private }
PRWysiwygEditorComponent >> generateSiteMapSelect: id [
	| theContext user viewableStructures structurePaths renderedSelectHtml |

	theContext := self context.
	user :=  theContext user.
	viewableStructures := theContext kernel root enumerator with; all; select: [ :aStructure | aStructure securityDecoration hasPermission: (PUPermission on: PRViewCommand) for: user].
	
	structurePaths := viewableStructures collect: [ :aStructure | aStructure absolutePath].
	structurePaths := (Array with:  'OR select a location Url from site-map ...') , structurePaths.
	
	renderedSelectHtml := WAHtmlCanvas builder	
		render: [:html | 
			html select
				style: 'width: 260px';
				id: id;
				list: structurePaths ].

	renderedSelectHtml replaceAll: $" with: $'.	"subsitute double quotes for single quotes"

	^ renderedSelectHtml
]

{ #category : #rendering }
PRWysiwygEditorComponent >> renderEditorOn: html [
	self editor wikiText: self string.
	html render: self editor
]

{ #category : #rendering }
PRWysiwygEditorComponent >> setEditorPermissions: anEditor [
	| editorConfiguration |
	editorConfiguration := anEditor configuration.
	editorConfiguration allowWikiTextEditing: ((self context command: PRWikiTextEditingCommand new)  isValid).
]

{ #category : #updating }
PRWysiwygEditorComponent >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	JQDeploymentLibrary default updateRoot: anHtmlRoot.
	JQUiDeploymentLibrary default updateRoot: anHtmlRoot.
	anHtmlRoot stylesheet url: PRWysiwygFileLibrary / #modifiedjqueryui1812redmondCss.
]
