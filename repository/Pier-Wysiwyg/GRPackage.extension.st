Extension { #name : #GRPackage }

{ #category : #'*pier-wysiwyg' }
GRPackage class >> pierWysiwyg [
	^ self new
		name: 'Pier-Wysiwyg';
		description: 'A Wysiwyg editor for Pier.';
		addDependency: 'Pier-Seaside';
		addDependency: 'Pier-EditorEnh';
		addDependency: 'Pier-Security';
		addDependency: 'JQuery-UI';
		url: #pierUrl;
		yourself
]
