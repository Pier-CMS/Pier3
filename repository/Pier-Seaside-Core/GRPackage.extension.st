Extension { #name : #GRPackage }

{ #category : #'*pier-seaside' }
GRPackage class >> pierSeaside [
	^ self new
		name: 'Pier-Seaside';
		description: 'Seaside integration of the Pier content management system.';
		addDependency: 'Magritte-Seaside';
		addDependency: 'Pier-Model';
		url: #pierUrl;
		yourself
]
