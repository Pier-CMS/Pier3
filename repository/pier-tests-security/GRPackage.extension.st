Extension { #name : #GRPackage }

{ #category : #'*pier-tests-security' }
GRPackage class >> pierTestsSecurity [
	^ self new
		name: 'Pier-Tests-Security';
		description: 'Tests for the Pier security plugin.';
		addDependency: 'Pier-Security';
		addDependency: 'Pier-Tests-Model';
		url: #pierUrl;
		yourself
]
