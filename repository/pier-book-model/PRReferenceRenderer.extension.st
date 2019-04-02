Extension { #name : #PRReferenceRenderer }

{ #category : #'*pier-book-model' }
PRReferenceRenderer >> visitReferenceLink: aLink [
	aLink target isFigure ifTrue: [
		^ self visit: (PRInternalLink new
			anchor: aLink target name;
			target: aLink target parent;
			add: (PRText content: aLink title);
			yourself) ].
	aLink target isPublication ifTrue: [
		^ self visit: (PRInternalLink new
			target: aLink target;
			add: (PRText content: aLink title);
			yourself) ].
	^ super visitReferenceLink: aLink
]
