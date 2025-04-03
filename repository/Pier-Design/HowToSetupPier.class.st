"
I represent a workspace for Pier setup, memory management, and export. If setting up a new Pier instance, start with:

	ProfStef goOn: self 

One can skip to the last two pages at the end if exporting an old running system.
"
Class {
	#name : #HowToSetupPier,
	#superclass : #AbstractTutorial,
	#category : #'Pier-Design'
}

{ #category : #lessons }
HowToSetupPier >> choosePersistency [

	^ Lesson
		  title: 'Choose Persistency'
		  lesson: '"Add persistency to your site - this can be done with:
	WebBrowser openOn: ''http://localhost:8080''.
Goto System / Mannagement and update the persistency to image storage - or use this:"

(PRKernel instances detect: [ :e | e name ~= ''pier_old'' ]) persistency:
	(PRImagePersistency new
         maxImages: 2;
         namePrefix: ''pier_backup_'';
         duration: 1 hour asDuration;
         maxHistory: 4096;
         yourself).

ProfStef next.'
]

{ #category : #lessons }
HowToSetupPier >> exportHistory [

	^ Lesson
		  title: 'Export the Wiki History from a Running Image'
		  lesson: '"Code for exporting history:"

| history fileStream recorded file |
history := ((PRKernel instances reject: [:e | e root name = ''root'']) detect: [:e | e name = ''pier'' or: [e name = ''Pier'']]) persistency history.
recorded := Set new: history size.
file := (File named: ''history.txt'').
fileStream := ZnCharacterWriteStream on: file writeStream encoding: ''utf8''.
(history reject: [:e | e command timestamp isNil or: [e user isNil]]) reverseDo: [:e || collection | 
	(recorded includes: e structure absolutePath)
		ifFalse: [
			fileStream nextPutAll: e structure absolutePath.
			fileStream tab.
			fileStream nextPutAll: e user name.
			fileStream tab.
			fileStream nextPutAll: e command timestamp printString.
			fileStream cr.			
			recorded add: e structure absolutePath] ].
fileStream close.
'
]

{ #category : #lessons }
HowToSetupPier >> exportPier [

	^ Lesson
		  title: 'Export the Wiki from a Running Image'
		  lesson: '"Code for exporting:"
| problemChars count |
"First stop the automated tasks:"
PRToDo allInstancesDo: [ :todo | todo scheduler ifNotNil: [ :sched | sched stop ] ].
"Consider changing the password if this code is shared:
PRKernel instances do: [ :kernel | kernel adminUser password: ''pier'' ]."
count := 0.
(problemChars := Dictionary new)
        at: (Character value: 8217) put: $'';
        at: (Character value: 8220) put: $";
        at: (Character value: 8221) put: $";
        at: (Character value: 8211) put: $-.
PRText allInstancesDo: [ :prText | (prText text includesAnyOf: problemChars keys) ifTrue: [ count := count + 1 .
               prText text: (prText text collect: [ :char | problemChars at: char ifAbsent: [ char ] ] ) ] ].
Transcript show: ''Updated ''; show: count; show: '' text blocks.''.
Transcript cr; flush.

"Remove the old"
#PRKernelCreatorForPier asClassIfPresent: [ : c | c removeFromSystem].
"Export the wiki:"
PRKernelCodeExporter exportAsPier3Kernel: ''pier''.
#PRKernelCreatorForPier asClassIfPresent: [ : c | c fileOut].

ProfStef next.'
]

{ #category : #lessons }
HowToSetupPier >> fileInPier [

	^ Lesson
		  title: 'File-in Pier Export'
		  lesson: '"Skip to the end if this is exporting:"
ProfStef next; next; next; next; next; next; next; next.

"If you have an export from a previous Pier installation, then copy the file to this directory and run:"
''PRKernelCreatorForPier.st'' asFileReference ifExists: [ :file | file fileIn ].

"Apply customized link code:"
(PRCustomLink isValidReference: ''google Pharo'') ifFalse: [PRCustomLink example].

"Rename the old kernel and create the new one (assumption at the end is that there is only 2):"
PRKernel instances size = 1 ifTrue: [
  PRKernel instances anyOne name: ''pier_old''.
  #PRKernelCreatorForPier asClassIfPresent: [ :c | c new createKernel ].
  (WAAdmin defaultDispatcher handlerAt: ''pier'') preferenceAt: #kernel put: (PRKernel instances detect: [ :e | e name ~= ''pier_old'' ]) ].

"Rename the new kernel if necessary"
(PRKernel instances detect: [ :e | e name ~= ''pier_old'' ]) root name: ''Test Pier''.

ProfStef next.'
]

{ #category : #lessons }
HowToSetupPier >> imageCleanup [

	^ Lesson
		  title: 'Image Cleanup'
		  lesson: '"Memory Updates for running a public site. Freeup anything unnecessary:"

(WAAdmin defaultDispatcher handlerAt: ''pier'') configuration at: #maximumRelativeAge put: 800.
(WAAdmin defaultDispatcher handlerAt: ''pier'') configuration at: #maximumSize put: 15000.
(WAAdmin defaultDispatcher handlerAt: ''pier'') initializeCache.

#PRKernelCreatorForPier asClass removeFromSystem.
PRKernel instances size = 2 ifTrue: [ PRKernel remove: ''pier_old'' ].
10 timesRepeat: [ Smalltalk garbageCollect ].
"Save the image and copy it to the server. No need to got to the next unless you are exporting changes."

ProfStef next.'
]

{ #category : #lessons }
HowToSetupPier >> importHistory [

	^ Lesson
		  title: 'Import History'
		  lesson: '"If updating an existing site import the history file of the latest changes for each page:"
| fileStream aKernel path owner timeStamp listOfTuples aPage aContext aCommand file |
aKernel := (PRKernel instances reject: [:e | e root name = ''root'']) detect: [:e | e name = ''pier'' or: [e name = ''Pier'']].
listOfTuples := OrderedCollection new: 1024 * 8.
(file := File named: ''history.txt'') exists ifFalse: [ self error: ''Missing history.txt in this directory.'' ].
fileStream := ZnCharacterReadStream on: file readStream encoding: ''utf8''.
[
	[fileStream atEnd] whileFalse: 
		[path :=  (fileStream upTo: Character tab).
		owner := (fileStream upTo: Character tab).
		timeStamp := (fileStream upTo: Character cr).
		listOfTuples add: (Array with: path with: owner with: timeStamp).
	].
	listOfTuples reverseDo: [ :array | path := array first.
		owner := array second.
		timeStamp := array third.
		aPage := PRPathLookup start: aKernel root path: path.
		aPage ifNotNil: [
			(aKernel users contains: [ :e | e name = owner ]) ifTrue: [ 
				aContext := PRContext
			 		kernel: aKernel
 			 		structure: aPage.
				aContext := aContext user: (aKernel users detect: [:e | e name = owner]).
				aCommand := (PREditCommand context: aContext)
					timestamp: (GRPlatform current magritteTimeStampClass fromString: timeStamp);
					propertyAt: #user put: (aKernel users detect: [:e | e name = owner]);
					isChecked;
					fields;
					yourself.
				aKernel persistency add: (aContext command: aCommand)]]
		]
] ensure: [ fileStream ifNotNil: [ fileStream close ] ].

ProfStef next.'
]

{ #category : #lessons }
HowToSetupPier >> pierLibraries [

	^ Lesson
		  title: 'Pier Libraries'
		  lesson: '"Libraries needed for accordions to work:"
(WAAdmin defaultDispatcher handlerAt: ''pier'') libraries size = 2
  ifTrue: [ (WAAdmin defaultDispatcher handlerAt: ''pier'')
    addLibrary: PRWysiwygFileLibrary;
    addLibrary: JQDeploymentLibrary;
    addLibrary: JQUiDeploymentLibrary;
    addLibrary: PRYUIEditorDeploymentLibrary;
    addLibrary: PRYUIEditorLibrary;
    addLibrary: JQOvercastTheme;
    addLibrary: JQWidgetBoxDeploymentLibrary ]
  ifFalse: [ Transcript show: ''WARNING: pier does not have two libraries! First should be PRBlueprintLibrary, second PRJavaScriptSupport''; cr ].

ProfStef next.'
]

{ #category : #lessons }
HowToSetupPier >> productionPierDefaults [

	^ Lesson
		  title: 'Production Pier Defaults'
		  lesson: '"Set the pier app as the default in seaside:"
WAAdmin defaultDispatcher defaultName: ''pier''.

"Removing the debugging code:"
WAAdmin applicationDefaults removeParent: WADevelopmentConfiguration instance.

ProfStef next.'
]

{ #category : #lessons }
HowToSetupPier >> productionSecureSeasideApps [

	^ Lesson
		  title: 'Secure the Seaside Apps'
		  lesson: '"Remove unnecessary seaside apps:"
WAAdmin defaultDispatcher unregister: (WAAdmin defaultDispatcher handlerAt: ''tools'').
WAAdmin defaultDispatcher unregister: (WAAdmin defaultDispatcher handlerAt: ''examples'').
WAAdmin defaultDispatcher unregister: (WAAdmin defaultDispatcher handlerAt: ''tests'').
WAAdmin defaultDispatcher unregister: (WAAdmin defaultDispatcher handlerAt: ''javascript'').
WAAdmin defaultDispatcher unregister: (WAAdmin defaultDispatcher handlerAt: ''bootstrap'').
WAAdmin defaultDispatcher unregister: (WAAdmin defaultDispatcher handlerAt: ''welcome'').
WAAdmin defaultDispatcher unregister: (WAAdmin defaultDispatcher handlerAt: ''browse'').
		
"Change the password from the default: seaside"
#(''status'' ''config'')
	do: [ :name |
		(WAAdmin defaultDispatcher handlerAt: name) configuration
			addParent: WAAuthConfiguration instance.
		(WAAdmin defaultDispatcher handlerAt: name)
			preferenceAt: #login put: ''admin'';
			preferenceAt: #passwordHash
				put: (GRPlatform current secureHashFor: ''seaside'');
			addFilter: WAAuthenticationFilter new ].

ProfStef next.'
]

{ #category : #lessons }
HowToSetupPier >> startAutomaticTasks [

	^ Lesson
		  title: 'Start Running Automatic Tasks'
		  lesson: '"If there are automted ToDo tasks, start them:"
#(''Scheduler Report'' ''Update Overdue Tasks'' ''Check Election Planning'' ''Check Image Save'') do:
	[ :title |
		(PRPathLookup start: (PRKernel instances detect: [ :e | e name ~= ''pier_old'' ]) root path: (''/Blog/Social Tasks/Democracy Action/'', title)) automate ].

ProfStef next.'
]

{ #category : #tutorial }
HowToSetupPier >> tutorial [

	^ #( #fileInPier #productionPierDefaults #pierLibraries
	     #productionSecureSeasideApps #startAutomaticTasks
	     #choosePersistency #importHistory #imageCleanup #exportPier #exportHistory )
]
