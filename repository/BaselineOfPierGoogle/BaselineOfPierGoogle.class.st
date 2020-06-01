Class {
	#name : #BaselineOfPierGoogle,
	#superclass : #BaselineOf,
	#category : #BaselineOfPierGoogle
}

{ #category : #baselines }
BaselineOfPierGoogle >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.		
			spec
				baseline: 'XMLParser'
					with: [ spec repository: 'github://pharo-contributions/XML-XMLParser' ];
				package: 'Pier-Google'
					with: [ spec requires: #('XMLParser') ] ]
]
