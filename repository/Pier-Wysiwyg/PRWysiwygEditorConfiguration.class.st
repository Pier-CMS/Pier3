Class {
	#name : #PRWysiwygEditorConfiguration,
	#superclass : #Object,
	#instVars : [
		'allowWikiTextEditing',
		'allowWysiwygEditing',
		'editorCss',
		'editorExtraJS',
		'showSiteMapLinks',
		'resourceUrlRootBlock'
	],
	#category : #'Pier-Wysiwyg'
}

{ #category : #accessing }
PRWysiwygEditorConfiguration >> allowWikiTextEditing [
	^ allowWikiTextEditing ifNil: [ allowWikiTextEditing := true ]
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> allowWikiTextEditing: anObject [
	allowWikiTextEditing := anObject
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> allowWysiwygEditing [
	^ allowWysiwygEditing ifNil: [ allowWysiwygEditing := true ]
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> allowWysiwygEditing: anObject [
	allowWysiwygEditing := anObject
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> editorCss [
	^ editorCss ifNil: [editorCss := 'p.important, p.todo, p.note, p.advanced, pre {padding:0.8em; margin-bottom: 1em; border-radius:5px; background:#ebebeb;} .p.important {background:#e8e0ef;} p.todo {color:red} p.note {color: blue} pre {background: #eee}']
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> editorCss: anObject [
	editorCss := anObject
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> editorExtraJS [
	^ editorExtraJS ifNil: [ editorExtraJS := '' ]
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> editorExtraJS: anObject [
	editorExtraJS := anObject
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> resourceUrlRoot [
	^ self resourceUrlRootBlock value
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> resourceUrlRootBlock [
	^ resourceUrlRootBlock ifNil: [ resourceUrlRootBlock := [ 'uploads' ] ]
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> resourceUrlRootBlock: aResourceUrlRootBlock [
	^ resourceUrlRootBlock := aResourceUrlRootBlock
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> showSiteMapLinks [
	^ showSiteMapLinks ifNil: [ showSiteMapLinks := true ]
]

{ #category : #accessing }
PRWysiwygEditorConfiguration >> showSiteMapLinks: showOrNot [
	showSiteMapLinks := showOrNot
]
