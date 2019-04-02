Extension { #name : #PRLinkRenderer }

{ #category : #'*pier-book' }
PRLinkRenderer >> visitIndexLink: aLink [
	html anchor name: aLink title.
	parent visitAll: aLink children
]
