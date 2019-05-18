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
					with: [ spec
						repository: 'github://jborden23/magritte';
						loads: #('Seaside') ];
				baseline: 'Pillar'
					with: [ spec repository: 'github://pillar-markup/pillar:dev-7' ];
				baseline: 'PillarExporter'
					with: [ spec repository: 'github://pillar-markup/pillar:dev-7' ];
				package: 'Bootstrap-Core-Libraries'
					with: [ spec requires: #('Seaside3' 'Magritte' 'Pillar' 'PillarExporter') ];
				package: 'Bootstrap-Core-Component'
					with: [ spec requires: #('Bootstrap-Core-Libraries') ];
				package: 'Bootstrap-Core-Canvas'
					with: [ spec requires: #('Bootstrap-Core-Component') ];
				package: 'Bootstrap-Jasny-Libraries'
					with: [ spec requires: #('Bootstrap-Core-Canvas') ];
				package: 'Bootstrap-Jasny-Canvas'
					with: [ spec requires: #('Bootstrap-Jasny-Libraries') ];
				package: 'Bootstrap-Widgets-Libraries'
					with: [ spec requires: #('Bootstrap-Jasny-Canvas') ];
				package: 'Bootstrap-Widgets-Components'
					with: [ spec requires: #('Bootstrap-Widgets-Libraries') ];
				package: 'bootstrap-widgets'
					with: [ spec requires: #('Bootstrap-Widgets-Components') ];
				package: 'Bootstrap-Examples-Core'
					with: [ spec requires: #('bootstrap-widgets') ];
				package: 'Bootstrap-Examples-Jasny'
					with: [ spec requires: #('Bootstrap-Examples-Core') ];
				package: 'Bootstrap-Examples-Browser'
					with: [ spec requires: #('Bootstrap-Examples-Jasny') ];
				package: 'Bootstrap-Examples-Widgets-Components'
					with: [ spec requires: #('Bootstrap-Examples-Browser') ];
				package: 'Bootstrap-Examples-Widgets-Canvas'
					with: [ spec requires: #('Bootstrap-Examples-Widgets-Components') ];
				package: 'Bootstrap-Examples-Widgets-Table'
					with: [ spec requires: #('Bootstrap-Examples-Widgets-Canvas') ];
				package: 'Bootstrap-Examples-Widgets-VerticalTabs'
					with: [ spec requires: #('Bootstrap-Examples-Widgets-Table') ];
				package: 'RSS-Core-Model'
					with: [ spec requires: #('Bootstrap-Examples-Widgets-VerticalTabs') ];
				package: 'RSS-Core-Tags'
					with: [ spec requires: #('RSS-Core-Model') ];
				package: 'RSS-Core' with: [ spec requires: #('RSS-Core-Tags') ];
				package: 'Pier-Model-Document'
					with: [ spec requires: #('RSS-Core') ];
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
				package: 'pier-seaside' with: [ spec requires: #('Pier-Model') ];
				package: 'Pier-Documents'
					with: [ spec requires: #('pier-seaside') ];
				package: 'pier-pharo-model'
					with: [ spec requires: #('Pier-Documents') ];
				package: 'pier-security'
					with: [ spec requires: #('pier-pharo-model') ];
				package: 'pier-jquery'
					with: [ spec requires: #('pier-security') ];
				package: 'Pier-Bootstrap'
					with: [ spec requires: #('pier-jquery') ];
				package: 'pier-admin'
					with: [ spec requires: #('Pier-Bootstrap') ];
				package: 'pier-pharo-persistency'
					with: [ spec requires: #('pier-admin') ];
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
					with: [ spec requires: #('jqwidgetbox-formexample-core') ] ]
]
