Class {
	#name : #BaselineOfPierAddons,
	#superclass : #BaselineOf,
	#category : #BaselineOfPierAddons
}

{ #category : #baselines }
BaselineOfPierAddons >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec
				baseline: 'ContainersPropertyEnvironment'
					with: [ spec repository: 'github://Ducasse/Containers-PropertyEnvironment' ];
				baseline: 'PierCore'
					with: [ spec repository: 'github://jborden23/Pier3' ];
				package: 'Pier-Blog-Model' with: [ spec requires: #('PierCore') ] ]
]
