Class {
	#name : #BaselineOfPierCoreTests,
	#superclass : #BaselineOf,
	#category : #BaselineOfPierCoreTests
}

{ #category : #baselines }
BaselineOfPierCoreTests >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec
				baseline: 'ContainersPropertyEnvironment'
					with: [ spec repository: 'github://Ducasse/Containers-PropertyEnvironment' ];
				"Automation not working well, first load PierCore, then in Iceberg load Pillar-Tests-Core, then this.
				baseline: 'PierCore'
					with: [ spec repository: 'github://Pier-CMS/Pier3:LoadIn9/repository' ];
				baseline: 'PillarCore'
					with: [ spec
						repository: 'github://pillar-markup/pillar:dev-8';
						loads: #('tests') ];"
				baseline: 'PillarExporter'
					with: [ spec
						repository: 'github://pillar-markup/pillar:dev-8';
						loads: #('pillar exporter tests') ];
				package: 'pier-tests-model'
					with: [ spec requires: #('PillarExporter') ];
				package: 'Pier-Tests-Model-Utilities'
					with: [ spec requires: #('pier-tests-model') ];
				package: 'Pier-Tests-Model-Mocks'
					with: [ spec requires: #('Pier-Tests-Model-Utilities') ];
				package: 'Pier-Tests-Model-Structure'
					with: [ spec requires: #('Pier-Tests-Model-Mocks') ];
				package: 'Pier-Tests-Model-Kernel'
					with: [ spec requires: #('Pier-Tests-Model-Structure') ];
				package: 'Pier-Tests-Model-Document'
					with: [ spec requires: #('Pier-Tests-Model-Kernel') ];
				package: 'Pier-Tests-Model-Command'
					with: [ spec requires: #('Pier-Tests-Model-Document') ];
				package: 'Pier-Tests-Model-Persistence'
					with: [ spec requires: #('Pier-Tests-Model-Command') ];
				package: 'Pier-Tests-Pharo-Persistency'
					with: [ spec requires: #('Pier-Tests-Model-Persistence') ];
				package: 'pier-tests-security'
					with: [ spec requires: #('Pier-Tests-Pharo-Persistency') ];
				package: 'pier-tests-seaside-model'
					with: [ spec requires: #('pier-tests-security') ];
				package: 'Pier-Tests-Model-Magritte'
					with: [ spec requires: #('pier-tests-seaside-model') ];
				group: 'default' with: #('Pier-Tests-Model-Magritte') ]
]
