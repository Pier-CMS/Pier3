"
PRAdminIFrameDecorator retrieves the head script and styles generated during the initial rendering phase (from the requestContext) and initialises the iframe's script and style cache. It removes itself from its decorated component after the first rendering.
"
Class {
	#name : #PRAdminIFrameDecorator,
	#superclass : #WADecoration,
	#category : #'Pier-Admin-UI'
}

{ #category : #rendering }
PRAdminIFrameDecorator >> renderContentOn: html [
	| initialHeadScripts initialHeadStyles |
	
	super renderContentOn: html.
	
	"populate with initial head scripts and styles"
	initialHeadScripts := self requestContext headScripts asJavascript.
	html script:  'window.parent.alreadyInstalledIFrameScripts = ', initialHeadScripts, ';'.
	
	initialHeadStyles := self requestContext headStyles asJavascript.
	html script:  'window.parent.alreadyInstalledIFrameStyles = ', initialHeadStyles, ';'.
	
	self remove. "remove this decoration - its only needed the first time"
]
