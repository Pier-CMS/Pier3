"
I am the new baseline for loading Pier!

""2022-Jul-2 - What happens if I just define the baseline locally?""
Metacello new
	baseline: 'Pier';
	repository: 'github://Pier-CMS/Pier3:LoadIn9/repository';
	onConflictUseLoaded;
	load.
""2022-Jul-5 - Loading with the above loading Pier-Model-Document, but JQuery-* package had uncommitted changes (JQuery-JSON is up-to-doate).
Need to make sure that PRValueLink isn't defined elsewhere.
""

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #BaselineOfPier,
	#superclass : #BaselineOf,
	#category : #BaselineOfPier
}

{ #category : #baselines }
BaselineOfPier >> baseline: spec [

	<baseline>
	| pharoDeps |
	pharoDeps := #(  ).
	spec for: #'pharo9.x' do: [ pharoDeps := #( 'Pier-Pharo9' ) ].	
	spec for: #common do: [ 
		spec blessing: #baseline.
		spec
			baseline: 'ContainersPropertyEnvironment'
			with: [ 
				spec repository: 'github://Ducasse/Containers-PropertyEnvironment' ];
			baseline: 'Bootstrap'
			with: [ spec repository: 'github://astares/Seaside-Bootstrap' ];
			baseline: 'Seaside3' with: [ 
				spec
					repository: 'github://SeasideSt/Seaside';
					loads: #( 'RSS' ) ];
			baseline: 'Magritte' with: [ 
			spec
				repository: 'github://magritte-metamodel/magritte';
				loads: #( 'Seaside' 'Tests' ) ];
			baseline: 'Chrysal'
			with: [ spec repository: 'github://Ducasse/Chrysal/src' ];
			baseline: 'PillarExporter' with: [ 
			spec
				repository: 'github://pillar-markup/pillar:dev-8';
				loads: #( 'pillar exporter' 'text exporter' ) ];
			package: 'Pier-Model-Document' with: [ 
			spec requires:
				#( 'Bootstrap' 'Magritte' 'Seaside3' 'Chrysal' 'PillarExporter' ) ];
			package: 'Pier-Model-Magritte' with: [ 
			spec requires:
				#( 'Bootstrap' 'Magritte' 'Seaside3' 'Chrysal' 'PillarExporter' ) ];
			package: 'Pier-Model-Visitor' with: [ 
			spec requires:
				#( 'Bootstrap' 'Magritte' 'Seaside3' 'Chrysal' 'PillarExporter' ) ];
			package: 'Pier-Model-Command' with: [ 
			spec requires:
				#( 'Bootstrap' 'Magritte' 'Seaside3' 'Chrysal' 'PillarExporter' ) ];
			package: 'Pier-Model-Structure' with: [ 
			spec requires:
				#( 'Bootstrap' 'Magritte' 'Seaside3' 'Chrysal' 'PillarExporter' ) ];
			package: 'Pier-Model' with: [ 
			spec requires:
				#( 'Bootstrap' 'Magritte' 'Seaside3' 'Chrysal' 'PillarExporter' ) ];
			package: 'pier-seaside-converting'
			with: [ spec requires: #( 'Pier-Model-Command' ), pharoDeps ];
			package: 'pier-seaside-defaults'
			with: [ spec requires: #( 'Pier-Model-Magritte' ) ];
			package: 'pier-seaside-protected'
			with: [ 
			spec requires: #( 'Pier-Model-Structure' 'Pier-Model-Command' ) ];
			package: 'Pier-Seaside' with: [ 
			spec requires:
				#( 'Pier-Model' 'Pier-Model-Command' 'Pier-Model-Document'
				   'Pier-Model-Structure' ) ];
			package: 'Pier-Documents'
			with: [ spec requires: #( 'Pier-Model-Structure'
			   'Pier-Seaside' ) ];
			package: 'pier-pharo-model'
			with: [ spec requires: #( 'Pier-Model-Structure' ) ];
			package: 'pier-security'
			with: [ spec requires: #( 'Pier-Seaside' ) ];
			package: 'pier-seaside-accessing'
			with: [ spec requires: #( 'Pier-Model' 'Pier-Model-Structure' ) ];
			package: 'pier-jquery'
			with: [ spec requires: #( 'Pier-Model-Document' ) ];
			package: 'Pier-Bootstrap'
			with: [ spec requires: #( 'pier-security' ) ];
			package: 'pier-pharo-persistency'
			with: [ spec requires: #( 'Pier-Model' ) ];
			package: 'Pier-Exporter-Code'
			with: [ spec requires: #( 'Pier-Model-Structure' ) ];
			package: 'Pier-Exporter-Pharo' with: [ 
			spec requires:
				#( 'Bootstrap' 'Magritte' 'Seaside3' 'Chrysal' 'PillarExporter' ) ];
			package: 'Pier-Pharo-Seaside'
			with: [ spec requires: #( 'Pier-Seaside' ) ];
			package: 'Pier-LinkChecker'
			with: [ 
			spec requires: #( 'pier-security' 'Pier-Seaside' 'Pier-Model' ) ];
			package: 'JQWidgetBox-Core-Libraries'
			with: [ spec requires: #( 'Bootstrap' 'Magritte' 'Seaside3' ) ];
			package: 'jqwidgetbox-uilayout-core'
			with: [ spec requires: #( 'JQWidgetBox-Core-Libraries' ) ];
			package: 'jqwidgetbox-formexample-core'
			with: [ spec requires: #( 'Bootstrap' 'Magritte' 'Seaside3' ) ];
			package: 'Pier-JQuery-Widgets' with: [ 
			spec requires:
				#( 'Pier-Seaside' 'Pier-Model-Magritte' 'JQWidgetBox-Core-Libraries' ) ];
			package: 'JQWidgetBox-Cycle-Core'
			with: [ spec requires: #( 'JQWidgetBox-Core-Libraries' ) ];
			package: 'pier-seaside-testing'
			with: [ 
			spec requires: #( 'Pier-Model-Command' 'Pier-Model-Structure' ) ];
			package: 'Pier-Design' with: [ 
			spec
				requires: #( 'Pier-Model-Command' );
				postLoadDoIt: #registerPierInSeaside ];
			group: 'default'
			with:
				#( 'Pier-Documents' 'Pier-Model-Visitor' 'pier-seaside-protected'
				   'pier-seaside-converting' 'pier-seaside-defaults'
				   'pier-pharo-model' 'pier-seaside-accessing'
				   'pier-jquery' 'Pier-Bootstrap' 'pier-pharo-persistency'
				   'Pier-Exporter-Code' 'Pier-Exporter-Pharo'
				   'Pier-Pharo-Seaside' 'Pier-LinkChecker' 'jqwidgetbox-uilayout-core'
				   'jqwidgetbox-formexample-core' 'Pier-JQuery-Widgets'
				   'JQWidgetBox-Cycle-Core' 'pier-seaside-testing'
				   'Pier-Design' );
			package: 'Pier-Blog-Model' with: [ spec requires: #( 'default' ) ];
			package: 'pier-blog-seaside'
			with: [ spec requires: #( 'default' ) ];
			package: 'pier-blog' with: [ spec requires: #( 'default' ) ];
			package: 'Pier-Book-Structures'
			with: [ spec requires: #( 'default' ) ];
			package: 'pier-book-model' with: [ spec requires: #( 'default' ) ];
			package: 'Pier-Book-Latex' with: [ spec requires: #( 'default' ) ];
			package: 'Pier-Book-Utilities'
			with: [ spec requires: #( 'default' ) ];
			package: 'Pier-Book-View' with: [ spec requires: #( 'default' ) ];
			package: 'pier-book' with: [ spec requires: #( 'default' ) ];
			package: 'Pier-Setup' with: [ spec requires: #( 'default' ) ];
			package: 'Pier-TagCloud' with: [ spec requires: #( 'default' ) ];
			package: 'Pier-EditorEnh' with: [ spec requires: #( 'default' ) ];
			package: 'Pier-Wysiwyg' with: [ spec requires: #( 'default' ) ];
			package: 'Pier-Kernel-Distributions'
			with: [ spec requires: #( 'Pier-Wysiwyg' ) ];
			package: 'Javascript-Jasmine'
			with: [ spec requires: #( 'default' ) ];
			package: 'Pier-Tests-Wysiwyg'
			with: [ spec requires: #( 'Pier-Wysiwyg' ) ];
			group: 'addons'
			with:
				#( 'Pier-Blog-Model' 'pier-blog-seaside' 'pier-blog' 'Pier-Book-Structures'
				   'pier-book-model' 'Pier-Book-Latex' 'Pier-Book-Utilities'
				   'Pier-Book-View' 'pier-book' 'Pier-Setup' 'Pier-TagCloud'
				   'Pier-EditorEnh' 'Pier-Kernel-Distributions'
				   'Javascript-Jasmine' 'Pier-Tests-Wysiwyg' );
			baseline: 'Scheduler'
			with: [ spec repository: 'github://pharo-contributions/Scheduler' ];
			package: 'Pier-SW2-Sw1Features'
			with: [ spec requires: #( 'addons' ) ];
			package: 'Pier-ToDo'
			with: [ spec requires: #( 'addons' 'Scheduler' ) ];
			package: 'Pier-Workout' with: [ spec requires: #( 'Pier-ToDo' ) ];
			group: 'todo' with: #( 'Pier-SW2-Sw1Features'
			   'Pier-Workout' );
			baseline: 'XMLParser'
			with: [ 
			spec repository: 'github://pharo-contributions/XML-XMLParser' ];
			package: 'Pier-Google'
			with: [ spec requires: #( 'XMLParser' 'default' ) ];
			group: 'google' with: #( 'Pier-Google' ) ]
]

{ #category : #'do-its' }
BaselineOfPier >> registerPierInSeaside [
	^ PRPierFrame
		registerAsApplication: 'pier'
		kernel: (PRKernel instanceNamed: 'pier')
]
