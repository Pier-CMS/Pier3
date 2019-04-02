Extension { #name : #GRPackage }

{ #category : #'*pier-tests-model' }
GRPackage class >> pierTestsModel [
	^ self new
		name: 'Pier-Tests-Model';
		description: 'Tests for the Pier contennt management system.';
		addDependency: 'Pier-Model';
		addDependency: 'Magritte-Tests-Model';
		url: #pierUrl;
		yourself
]
