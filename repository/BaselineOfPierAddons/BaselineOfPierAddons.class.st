"
Additional packages that can be used with Pier.
"
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
		do: [ spec blessing: #baseline.
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
				package: 'Pier-Book-Structures'
					with: [ spec requires: #('pier-blog') ];
				package: 'pier-book-model'
					with: [ spec requires: #('Pier-Book-Structures') ];
				package: 'Pier-Book-Latex'
					with: [ spec requires: #('pier-book-model') ];
				package: 'Pier-Book-Utilities'
					with: [ spec requires: #('Pier-Book-Latex') ];
				package: 'Pier-Book-View'
					with: [ spec requires: #('Pier-Book-Utilities') ];
				package: 'pier-book' with: [ spec requires: #('Pier-Book-View') ];
				package: 'Pier-Setup' with: [ spec requires: #('pier-book') ];
				package: 'Pier-TagCloud' with: [ spec requires: #('Pier-Setup') ];
				package: 'Pier-EditorEnh' with: [ spec requires: #('pier-book') ];
				package: 'Pier-Wysiwyg'
					with: [ spec requires: #('Pier-EditorEnh' 'pier-book') ];
				package: 'Pier-Kernel-Distributions'
					with: [ spec requires: #('Pier-Wysiwyg' 'pier-book' 'Pier-TagCloud') ];
				package: 'Pier-Admin-Setup-Core'
					with: [ spec requires: #('Pier-TagCloud') ];
				package: 'Pier-Admin-Setup-NewKernelFromDistribution'
					with: [ spec requires: #('Pier-Admin-Setup-Core') ];
				package: 'Pier-Admin-Setup-RecreateExportedKernel'
					with: [ spec requires: #('Pier-Admin-Setup-Core') ];
				package: 'Pier-Admin-UI'
					with: [ spec requires: #('Pier-Admin-Setup-Core') ];
				package: 'Pier-Admin-Setup-ExistingKernel'
					with: [ spec requires: #('Pier-Admin-UI') ];
				package: 'Javascript-Jasmine'
					with: [ spec requires: #('Pier-Wysiwyg') ];
				package: 'Pier-Tests-Wysiwyg'
					with: [ spec requires: #('Javascript-Jasmine') ] ]
]
