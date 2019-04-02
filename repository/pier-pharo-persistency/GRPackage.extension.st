Extension { #name : #GRPackage }

{ #category : #'*pier-pharo-persistency' }
GRPackage class >> pierPharoPersistency [
	^ self new
		name: 'Pier-Pharo-Persistency';
		addDependency: 'Pier-Model';
		addDependency: 'Pier-Seaside';
		url: #pierUrl;
		yourself
]
