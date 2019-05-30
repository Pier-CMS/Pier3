Class {
	#name : #BaselineOfPierTodo,
	#superclass : #BaselineOf,
	#category : #BaselineOfPierTodo
}

{ #category : #baselines }
BaselineOfPierTodo >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec
				baseline: 'ContainersPropertyEnvironment'
					with: [ spec repository: 'github://Ducasse/Containers-PropertyEnvironment' ];
				baseline: 'PierAddons'
					with: [ spec repository: 'github://jborden23/Pier3' ];
				baseline: 'Scheduler'
					with: [ spec repository: 'github://seandenigris/Scheduler' ];
				package: 'Pier-SW2-Sw1Features'
					with: [ spec requires: #('PierAddons') ];
				package: 'Pier-ToDo'
					with: [ spec requires: #('Pier-SW2-Sw1Features' 'Scheduler') ];
				package: 'Pier-Workout' with: [ spec requires: #('Pier-ToDo') ];
				package: 'Pier-Tests-Todo'
					with: [ spec requires: #('Pier-ToDo') ];
				package: 'Pier-Test-Workout'
					with: [ spec requires: #('Pier-Workout') ] ]
]
