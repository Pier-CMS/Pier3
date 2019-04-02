Class {
	#name : #PRWysiwygEditorExample,
	#superclass : #PRWysiwygEditor,
	#category : #'Pier-Wysiwyg'
}

{ #category : #testing }
PRWysiwygEditorExample class >> canBeRoot [
	^ true
]

{ #category : #initialization }
PRWysiwygEditorExample class >> editorSupportInfo [
	^ 'Currently the editor supports the following markup:
# ""Bold""
# ''''Italic''''
# __Underline__
# ==code==
# --strikeout--
# Headings
# line-breaks and paragraphs
# ordered and unordered lists.
# super^^script^^ and sub@@script@@
# horizontal line

_'
]

{ #category : #'initialize-release' }
PRWysiwygEditorExample class >> register [
	(WAAdmin register: self asApplicationAt: 'wysiwygtest')
		addLibrary: JQDeploymentLibrary;
		addLibrary: JQUiDeploymentLibrary;
		preferenceAt: #scriptGeneratorClass put: JQScriptGenerator.
]

{ #category : #'callback-support' }
PRWysiwygEditorExample >> generateSiteMapSelect: id [
	| renderedSelectHtml kernel user viewableStructures structurePaths |
	
	"I want to see how the site map appears to a non-admin user, so add myself to the kernel if I'm not already there"
	kernel := PRKernel instances anyOne.
	user :=  kernel userNamed: 'nick.ager@gmail.com' ifNone: [ kernel users add: ((PUUser named: 'nick.ager@gmail.com') password: 'apassword'; yourself) ].
	viewableStructures := kernel root enumerator with; all; select: [ :aStructure | aStructure securityDecoration hasPermission: (PUPermission on: PRViewCommand) for: user].
	
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

{ #category : #initialization }
PRWysiwygEditorExample >> initialize [
	super initialize.
	self siteMapSelectCallback: [:id | self generateSiteMapSelect: id ].
	self setExampleText
	
]

{ #category : #rendering }
PRWysiwygEditorExample >> renderContentOn: html [
	html form: [ super renderContentOn: html ]
]

{ #category : #initialization }
PRWysiwygEditorExample >> setExampleText [
	self wikiText: '!A Wysiwyg editor for Pier

', self class editorSupportInfo, '
The translator also supports the following, although there are no editor buttons to support it:
- definition list and definitions
- preformatted.
- shout code formatting.
- named anchors
- email addresses: *mail me>nick.ager@gmail.com*
- annotated paragraphs
- book keywords
- book references
@ananchor

@@note an annotated paragraph

= Some preformed text
= more preformed stuff
= Pillar changes require a space after the equal sign

A Definition List:
;Wysiwyg
:What you see is what you get
;Editor
:A computer program enabling the user to alter or rearrange online text

Still to come support for tables. Support for internal links still needs to be expanded.

!!! Support verbatim, embedded links and value links
The editor attempts to support all the Pier Wiki markup, so the Wysiwyg editor can be used interchangeably with the standard editor without fear of loosing any markup so, for example, it should be possible to use for editing Pier book content. I''ve taken the approach of preserving verbatim, embedded and value links in the Wysiwyg editor, but not making them editable. The editor could be extended with custom dialogs in which the raw wiki syntax could be edited.

Some non-editable wiki content:
{{{<div class="pierIcon">verbatim test</div>}}}
+value:date+
_

!!! Thoughts and questions
Some features should only be enabled for users with sufficient permissions. For example you don''t want untrusted users to be able to insert verbatim html or edit the content in the wiki standard view. However, is it acceptable to make the Wysiwyg editor dependent on Pier-Security? 
I propose we enable/disable features based on the following permissions:
- ==PRVerbatiumMarkupPermission==
- ==PRWikiTextEditingPermission==
- ==PREmbeddedLinksPermission==
- ==PRValueLinksPermission==

!!!Useful links
- *http://developer.yahoo.com/yui/editor/*
- *http://yuiblog.com/assets/pdf/cheatsheets/editor.pdf*
- *http://developer.yahoo.com/yui/examples/editor/toolbar_editor.html*
- *http://developer.yahoo.com/yui/docs/editor.js.html*
- *http://developer.yahoo.com/yui/examples/editor/cal_editor.html*
- *http://developer.yahoo.com/yui/examples/editor/flickr_editor.html*'
]

{ #category : #updating }
PRWysiwygEditorExample >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	PREditorScripts default updateRoot: anHtmlRoot.
	anHtmlRoot stylesheet url: PRWysiwygFileLibrary / #modifiedjqueryui1812redmondCss.

]
