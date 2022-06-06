"
I am a baseline for loading the Pier Todo code, see http://myborden.com/pier/john-c-borden/smalltalk/pier/PierToDo
"
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
					with: [ spec repository: 'github://Pier-CMS/Pier3' ];
				baseline: 'Scheduler'
					with: [ spec repository: 'github://pharo-contributions/Scheduler' ];
				package: 'Pier-SW2-Sw1Features'
					with: [ spec requires: #('PierAddons') ];
				package: 'Pier-ToDo'
					with: [ spec requires: #('Pier-SW2-Sw1Features' 'Scheduler') ];
				package: 'Pier-Workout' with: [ spec requires: #('Pier-ToDo') ];
				package: 'Pier-Tests-Todo'
					with: [ spec requires: #('Pier-ToDo') ];
				package: 'Pier-Test-Workout'
					with: [ spec requires: #('Pier-Workout') ];
				group: 'default' with: #('Pier-Workout');
				group: 'tests' with: #('Pier-Tests-Todo' 'Pier-Test-Workout') ]
]
