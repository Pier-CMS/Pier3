"
I am a baseline for loading the minimal Pier code.  I'm based on BaselineOfPillarCore


"
Class {
	#name : #BaselineOfPierCore,
	#superclass : #BaselineOf,
	#category : #BaselineOfPierCore
}

{ #category : #baselines }
BaselineOfPierCore >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec
				baseline: 'ContainersPropertyEnvironment'
					with: [ spec repository: 'github://Ducasse/Containers-PropertyEnvironment' ];
				baseline: 'Seaside3'
					with: [ spec repository: 'github://SeasideSt/Seaside' ];
				baseline: 'Magritte'
					with: [ spec repository: 'github://jborden23/magritte' ];
				baseline: 'Pillar'
					with: [ spec repository: 'github://pillar-markup/pillar:dev-7' ];
				baseline: 'PillarExporter'
					with: [ spec repository: 'github://pillar-markup/pillar:dev-7' ];
				package: 'Bootstrap-Core-Libraries'
					with: [ spec requires: #('Seaside3' 'Magritte' 'Pillar' 'PillarExporter') ] ]
]
