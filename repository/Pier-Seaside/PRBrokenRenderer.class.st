"
I am the class that renders broken links to allow logged in users to create new pages.
"
Class {
	#name : #PRBrokenRenderer,
	#superclass : #PRLinkRenderer,
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #private }
PRBrokenRenderer >> anchorFor: aLink [
	^ (super anchorFor: aLink)
		class: 'broken';
		yourself
]

{ #category : #'visiting-document' }
PRBrokenRenderer >> visitInternalLink: aLink [
	"Allow users to add new content, if they have the appropriate permissions."

	| lookup context |
	lookup := self context structure
		lookupIncompletePath: aLink reference.
	context := self context
		structure: lookup key
		command: PRAddCommand new.
	context command
		link: aLink;
		suggestName: lookup value.
	(self anchorFor: aLink)
		goto: context;
		with: [ self visitLink: aLink ]
]
