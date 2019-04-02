"
I am display social widgets from http://www.addthis.com/.
To use:
 1) Edit the blog
 2) In ""Social Sharing class"" entry enter: PBSocialWidgetsAddThis
 3) Save changes
 4) Your blog entries should now contain the social widgets from http://www.addthis.com/.

"
Class {
	#name : #PBSocialWidgetsAddThis,
	#superclass : #WAPresenter,
	#category : #'Pier-Blog-Seaside'
}

{ #category : #rendering }
PBSocialWidgetsAddThis >> renderWidgetForEntry: anEntry on: html [
	| entryContext url |
	entryContext := self context structure: anEntry.
	url := entryContext url withoutQuery withoutFragment.
	
	html div class: 'addthis_toolbox addthis_default_style '; attributeAt: 'addthis:url' put: url greaseString; with: [
      	html anchor attributeAt: 'fb:like:layout' put: 'button_count'; class: 'addthis_button_facebook_like'.
		html anchor class: 'addthis_button_twitter'.
		html anchor class: 'addthis_button_google_plusone'.
		html anchor class: 'addthis_button_email'.
		html anchor class: 'addthis_button_print'.
		html span class: 'addthis_separator'; with: '|'.
		html anchor class: 'addthis_button_compact' ]
]

{ #category : #updating }
PBSocialWidgetsAddThis >> updateRoot: anHtmlRoot [ 
	super updateRoot: anHtmlRoot.

	anHtmlRoot javascript url: 'http://s7.addthis.com/js/250/addthis_widget.js'
]
