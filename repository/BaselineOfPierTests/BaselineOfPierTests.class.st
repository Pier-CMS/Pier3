"
This is a hack, a good design would make this part of BaselineOfPier. The problem is Pillar does not cleanly load with BaselineOfPillarCore. For loading some tests do the following:

# Load your favorite Pier code, like:
  Metacello new
	baseline: 'Pier';
	repository: 'github://Pier-CMS/Pier3:LoadIn9/repository';
	onConflictUseLoaded;
	load: #('google').
# Open Iceberg, select Pillar, load the package Pillar-Tests-Core & Pillar-Tests-Model
# Load these tests:
  Metacello new
	baseline: 'PierTests';
	repository: 'github://Pier-CMS/Pier3:LoadIn9/repository';
	onConflictUseLoaded;
	load: #('default').

"
Class {
	#name : #BaselineOfPierTests,
	#superclass : #BaselineOf,
	#category : #BaselineOfPierTests
}

{ #category : #baselines }
BaselineOfPierTests >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec
				baseline: 'ContainersPropertyEnvironment'
					with: [ spec repository: 'github://Ducasse/Containers-PropertyEnvironment' ];
				package: 'pier-tests-model';
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
				group: 'default' with: #('Pier-Tests-Model-Magritte');
				package: 'Pier-Tests-Todo' with: [ spec requires: #('default') ];
				package: 'Pier-Tests-SW2-Sw1Features'
					with: [ spec requires: #('default') ];
				package: 'Pier-Test-Workout'
					with: [ spec requires: #('default') ];
				group: 'todo'
					with: #('Pier-Tests-Todo' 'Pier-Test-Workout' 'Pier-Tests-SW2-Sw1Features') ]
]
