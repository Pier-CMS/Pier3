Extension { #name : #GRPackage }

{ #category : #'*pier-jquery' }
GRPackage class >> pierJQuery [
	^ self new
		name: 'Pier-JQuery';
		description: 'JQuery support for Pier';
		addDependency: 'Pier-Seaside';
		addDependency: 'JQuery-UI';
		url: #pierAddonsUrl;
		yourself
]
