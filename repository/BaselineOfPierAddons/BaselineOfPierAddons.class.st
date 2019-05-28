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
		do:
			[ "package: 'Pier-Book-Deprecated' depends: BOPublication, which is in structures, structures depends on BOSubsection which is in deprecated.'"
			spec blessing: #baseline.
			spec
				baseline: 'ContainersPropertyEnvironment'
					with: [ spec repository: 'github://Ducasse/Containers-PropertyEnvironment' ];
				baseline: 'PierCore'
					with: [ spec repository: 'github://jborden23/Pier3' ];
				package: 'Pier-Blog-Model' with: [ spec requires: #('PierCore') ];
				package: 'pier-blog-seaside'
					with: [ spec requires: #('Pier-Blog-Model') ];
				package: 'pier-blog'
					with: [ spec requires: #('pier-blog-seaside') ];
				package: 'Pier-Shout' with: [ spec requires: #('pier-blog') ];
				package: 'Pier-Book-Structures'
					with: [ spec requires: #('Pier-Shout') ];
				package: 'Pier-Book-Deprecated'
					with: [ spec requires: #('Pier-Book-Structures') ] ]
]
