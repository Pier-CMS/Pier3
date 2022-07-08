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
				baseline: 'Chrysal'
					with: [ spec repository: 'github://Ducasse/Chrysal/src' ];
				baseline: 'PillarExporter'
					with: [ spec
						repository: 'github://pillar-markup/pillar:dev-8';
						loads: #('pillar exporter' 'text exporter') ];
				package: 'Pier-Model-Document'
					with: [ spec
						requires: #('Bootstrap' 'Magritte' 'Seaside3' 'Chrysal' 'PillarExporter') ];
				group: 'default' with: #('Pier-Model-Document') ]
]
