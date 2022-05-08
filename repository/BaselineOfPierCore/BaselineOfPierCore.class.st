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
	"baselines"

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
				baseline: 'PillarApp'
					with: [ spec repository: 'github://pillar-markup/pillar:dev-8';
						loads: #('parser') ];
				package: 'Pier-Model-Document'
					with: [ spec
						requires: #('Bootstrap' 'Magritte' 'PillarApp' 'Seaside3') ];
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
					with: [ spec requires: #('pier-seaside-protected') ];
				package: 'Pier-Seaside' with: [ spec requires: #('Pier-Model') ];
				package: 'Pier-Documents'
					with: [ spec requires: #('Pier-Seaside') ];
				package: 'pier-pharo-model'
					with: [ spec requires: #('Pier-Documents') ];
				package: 'pier-security'
					with: [ spec requires: #('pier-pharo-model') ];
				package: 'pier-seaside-accessing'
					with: [ spec requires: #('pier-security') ];
				package: 'pier-jquery'
					with: [ spec requires: #('pier-security') ];
				package: 'Pier-Bootstrap'
					with: [ spec requires: #('pier-jquery') ];
				package: 'pier-pharo-persistency'
					with: [ spec requires: #('Pier-Bootstrap') ];
				package: 'Pier-Exporter-Code'
					with: [ spec requires: #('pier-pharo-persistency') ];
				package: 'Pier-Exporter-Pharo'
					with: [ spec requires: #('Pier-Exporter-Code') ];
				package: 'Pier-Pharo-Seaside'
					with: [ spec requires: #('Pier-Exporter-Pharo') ];
				package: 'Pier-LinkChecker'
					with: [ spec requires: #('Pier-Pharo-Seaside') ];
				package: 'JQWidgetBox-Core-Libraries'
					with: [ spec requires: #('Pier-LinkChecker') ];
				package: 'JQWidgetBox-JSTree-Core'
					with: [ spec requires: #('JQWidgetBox-Core-Libraries') ];
				package: 'jqwidgetbox-uilayout-core'
					with: [ spec requires: #('JQWidgetBox-JSTree-Core') ];
				package: 'jqwidgetbox-formexample-core'
					with: [ spec requires: #('jqwidgetbox-uilayout-core') ];
				package: 'Pier-JQuery-Widgets'
					with: [ spec requires: #('jqwidgetbox-formexample-core') ];
				package: 'JQWidgetBox-Cycle-Core'
					with: [ spec requires: #('Pier-JQuery-Widgets') ];
				package: 'Pier-Design'
					with: [ spec requires: #('Pier-JQuery-Widgets') ];
				package: 'pier-seaside-testing'
					with: [ spec
						requires: #('Pier-Design');
						postLoadDoIt: #registerPierInSeaside ] ]
]

{ #category : #doits }
BaselineOfPierCore >> registerPierInSeaside [
	^ PRPierFrame
		registerAsApplication: 'pier'
		kernel: (PRKernel instanceNamed: 'pier')
]
