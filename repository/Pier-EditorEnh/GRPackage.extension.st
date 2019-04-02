Extension { #name : #GRPackage }

{ #category : #'*pier-editorenh' }
GRPackage class >> piereditorEnh [
	^ self new
		name: 'Pier-EditorEnh';
		description: 'Improves usability of the wiki editor with a toolbar.';
		addDependency: 'Pier-Model';
		addDependency: 'Pier-Seaside';
		url: #pierAddonsUrl;
		yourself
]
