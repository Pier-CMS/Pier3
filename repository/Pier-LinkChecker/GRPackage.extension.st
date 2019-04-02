Extension { #name : #GRPackage }

{ #category : #'*pier-linkchecker' }
GRPackage class >> pierLinkChecker [
	^ self new
		name: 'Pier-LinkChecker';
		description: 'Checks and fixes links on a Pier site.';
		addDependency: 'Pier-Model';
		addDependency: 'Pier-Security';
		addDependency: 'Pier-Seaside';
		url: #pierAddonsUrl;
		yourself
]
