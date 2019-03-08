Extension { #name : #GRPackage }

{ #category : #'*pier-model' }
GRPackage >> pierAddonsUrl [
	^ 'http://source.lukas-renggli.ch/pier2addons'
]

{ #category : #'*pier-model' }
GRPackage class >> pierModel [
	^ self new
		name: 'Pier-Model';
		description: 'The Pier is a content management system.';
		addDependency: 'Magritte-Model';
		addDependency: 'Grease-Core';
		url: #pierUrl;
		yourself
]

{ #category : #'*pier-model' }
GRPackage >> pierUrl [
	^ 'http://source.lukas-renggli.ch/pier2'
]
