Class {
	#name : #BaselineOfPierTemporary,
	#superclass : #BaselineOf,
	#category : #BaselineOfPierTemporary
}

{ #category : #baselines }
BaselineOfPierTemporary >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec
				baseline: 'ContainersPropertyEnvironment'
					with: [ spec repository: 'github://Ducasse/Containers-PropertyEnvironment' ];
				baseline: 'Bootstrap'
					with: [ spec repository: 'github://astares/Seaside-Bootstrap' ];
				baseline: 'Seaside3'
					with: [ spec
						repository: 'github://SeasideSt/Seaside';
						loads: #('RSS') ];
				baseline: 'Magritte'
					with: [ spec
						repository: 'github://magritte-metamodel/magritte';
						loads: #('Seaside' 'Tests') ];
				baseline: 'Pillar'
					with: [ spec repository: 'github://pillar-markup/pillar:dev-7' ];
				baseline: 'PillarExporter'
					with: [ spec repository: 'github://pillar-markup/pillar:dev-7' ];
				package: 'Pier-Model-Document'
					with: [ spec
						requires: #('Bootstrap' 'Magritte' 'Pillar' 'PillarExporter' 'Seaside3') ];
				package: 'Pier-Model-Magritte'
					with: [ spec requires: #('Pier-Model-Document') ];
				package: 'Pier-Model-Visitor'
					with: [ spec requires: #('Pier-Model-Magritte') ];
				package: 'Pier-Model-Command'
					with: [ spec requires: #('Pier-Model-Visitor') ];
				package: 'Pier-Model-Structure'
					with: [ spec requires: #('Pier-Model-Command') ];
				package: 'pier-seaside-converting'
					with: [ spec requires: #('Pier-Model-Structure') ];
				package: 'pier-seaside-defaults'
					with: [ spec requires: #('pier-seaside-converting') ];
				package: 'pier-seaside-protected'
					with: [ spec requires: #('pier-seaside-defaults') ];
				package: 'Pier-Model'
					with: [ spec requires: #('pier-seaside-protected') ] ]
]
