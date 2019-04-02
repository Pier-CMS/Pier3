Extension { #name : #GRPackage }

{ #category : #'*pier-tagcloud' }
GRPackage class >> pierTagCloud [
	^ self new
		name: 'Pier-TagCloud';
		description: 'A tag cloud for Pier.';
		addDependency: 'Pier-Model';
		addDependency: 'Pier-Seaside';
		url: #pierAddonsUrl;
		yourself
]
