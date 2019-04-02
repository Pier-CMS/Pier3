Extension { #name : #GRPackage }

{ #category : #'*pier-setup' }
GRPackage class >> pierSetup [
	^ self new
		name: 'Pier-Setup';
		description: 'A default setup with several templates to get started with Pier.';
		addDependency: 'Pier-Model';
		addDependency: 'Pier-Seaside';
		addDependency: 'Pier-Security';
		addDependency: 'Pier-Blog';
		addDependency: 'Pier-Book';
		addDependency: 'Pier-Documents';
		addDependency: 'Pier-EditorEnh';
		addDependency: 'Pier-LinkChecker';
		addDependency: 'Pier-Google';
		addDependency: 'Pier-JQuery';
		url: #pierAddonsUrl;
		yourself
]
