Extension { #name : #GRPackage }

{ #category : #'*pier-pharo-model' }
GRPackage class >> pierPharoModel [
	^ self new
		name: 'Pier-Pharo-Model';
		addDependency: 'Pier-Model';
		addDependency: 'Magritte-Pharo-Model';
		addDependency: 'Grease-Pharo-Core';
		url: #pierUrl;
		yourself
]
