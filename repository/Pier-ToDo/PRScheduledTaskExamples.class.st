"
I am a list of methods that can be ran as automated tasks in pre-formatted text of PRToDoTask.  An alternative is to have the code directly in the task, however then the normal Smalltalk tools can't be used.

Instance Variables
	kernel:	<PRKernel>
	todo: 		<PRToDo>

Specifics:
Calling #reportOfImagesOnPageAt: can cause a deadlock since it retrieves external resources.  It may be required to stop the task and have it re-run after the network issues are resolved.

The class side ShouldCheckFSSpace is a flag for running the df command through LibC - it can be turned on/off with shouldCheckFSSpace/shouldNotCheckFSSpace and checked with: checkFSSpace.
"
Class {
	#name : #PRScheduledTaskExamples,
	#superclass : #Object,
	#instVars : [
		'kernel',
		'todo'
	],
	#classVars : [
		'CodeLock',
		'SequenceGenerator',
		'ShouldCheckFSSpace'
	],
	#category : #'Pier-ToDo'
}

{ #category : #asserting }
PRScheduledTaskExamples class >> checkFSSpace [
	ShouldCheckFSSpace ifNil: [ ShouldCheckFSSpace := true ].
	^ ShouldCheckFSSpace
]

{ #category : #accessing }
PRScheduledTaskExamples class >> codeLockCritical: aBlock [
	CodeLock ifNil: [ CodeLock := Semaphore forMutualExclusion  ].
	^ CodeLock critical: aBlock
]

{ #category : #accessing }
PRScheduledTaskExamples class >> isCodeLocked [
	^ CodeLock isSignaled not
]

{ #category : #'instance creation' }
PRScheduledTaskExamples class >> newForKernelNamed: aString [

	| closestKernel |
	closestKernel := PRKernel instances
		                 detect: [ :k | k name = aString ]
		                 ifNone: [ 
			                 PRKernel instances
				                 detect: [ :k | 
				                 (k name alike: aString) > aString size ]
				                 ifNone: [ PRKernel instanceNamed: aString ] ].
	^ self new
		  kernel: closestKernel;
		  yourself
]

{ #category : #'instance creation' }
PRScheduledTaskExamples class >> newForKernelNamed: aString andTodoPath: aPathString [
	| aKernel aToDo |
	aKernel := PRKernel instanceNamed: aString.
	^ (aToDo := PRPathLookup start: aKernel root path: aPathString)
		isToDo
		ifTrue: [ self newForKernelNamed: aString ]
		ifFalse: [ self new
				kernel: aKernel;
				todo: aToDo;
				yourself ]
]

{ #category : #accessing }
PRScheduledTaskExamples class >> nextSequenceCount [

	"self nextSequenceCount"

	SequenceGenerator ifNil: [ 
		SequenceGenerator := Generator on: [ :gen | 
			                     | count |
			                     count := 0.
			                     [ 
			                     count := count + 1.
			                     gen yield: count ] repeat ] ].
	^ SequenceGenerator next
]

{ #category : #asserting }
PRScheduledTaskExamples class >> shouldCheckFSSpace [
	ShouldCheckFSSpace := true
]

{ #category : #asserting }
PRScheduledTaskExamples class >> shouldNotCheckFSSpace [
	ShouldCheckFSSpace := false
]

{ #category : #wikibackup }
PRScheduledTaskExamples >> backupTo: aUrl as: aUsername authenticatedBy: aPassword [
	"Not sure why it must be in lowercase, but that is what works."

	[ PRKernelCodeExporter exportAsPier3Kernel: kernel name asLowercase.
	Gofer new
		url: aUrl username: aUsername password: aPassword;
		package: 'Pier-Exported-Code';
		commit: 'Saving the ' , self kernel printString , ' Pier config using the automated.' ]
		on: Error
		do: [ :exception | 
			Transcript
				show: 'Failed to backup due to: ';
				show: exception;
				cr ]
]

{ #category : #wikibackup }
PRScheduledTaskExamples >> copyImageFilesFrom: aStartPageName usingNaming: aNameBlock toExternalUsing: writePictureFilesAndReturnUrls reportOn: aPathString [
	"The report may have links to the PRFiles, so consider its location (having aStartPage as a parent prevents the file from being overwritten). User is responsible to select a aStartPageName that does not have private pictures under it"

	| reportPage files |
	self guessTodoFromPath: aPathString.
	(reportPage := PRPathLookup start: self kernel root path: aPathString)
		ifNotNil: [
			reportPage contents: (String streamContents: [ :outputStream |
					 | batchesOfFiles batchesOfFilesToLinks linksToFile pictureUrls errorLinks |
					 batchesOfFilesToLinks := Dictionary new.
					 files := (PRPathLookup
						           start: self kernel root
						           path: aStartPageName) enumerator everything select: [
						          :e | e isFile and: [ e isImage ] ].
					 files isEmpty ifTrue: [
						 outputStream nextPutAll: 'No files found' ].
					 files do: [ :file |
						 ((file title reject: [ :c | '-_.:' includes: c ])
							  isAllAlphaNumerics and: [ file title includes: $. ])
							 ifFalse: [
								 outputStream
									 nextPutAll: 'The file *';
									 nextPutAll: file absolutePath;
									 nextPutAll:
										 '* needs a title to be used for the file name, edit it to change the title.';
									 cr;
									 cr ]
							 ifTrue: [
								 file hasChildren
									 ifTrue: [
										 outputStream
											 nextPutAll: 'The file *';
											 nextPutAll: file absolutePath;
											 nextPutAll:
												 '* has children, these should be removed first.';
											 cr;
											 cr ]
									 ifFalse: [
										 file isRoot
											 ifTrue: [
												 outputStream
													 nextPutAll: 'The file *';
													 nextPutAll: file absolutePath;
													 nextPutAll:
														 '* should not be the root, removing this would be very bad.';
													 cr;
													 cr ]
											 ifFalse: [
												 ([
												  [
												  (aNameBlock value: file) asUrl retrieveContents isEmpty ]
													  on: ZnHttpUnsuccessful
													  do: [ true ] ]
													  on: ConnectionTimedOut
													  do: [ true ])
													 ifFalse: [
														 outputStream
															 nextPutAll: 'The file *';
															 nextPutAll: file absolutePath;
															 nextPutAll: '* should be replaced with: ';
															 nextPutAll: (aNameBlock value: file) asString;
															 cr;
															 cr ]
													 ifTrue: [
														 errorLinks := (linksToFile := self kernel root
															                               incomingReferences to:
														                               file) reject: [ :link |
															               link isEmbedded ].
														 linksToFile size = 0
															 ifTrue: [
																 outputStream
																	 nextPutAll: 'The file *';
																	 nextPutAll: file absolutePath;
																	 nextPutAll:
																		 '* has no links to it, need to wait until there is an embedded link to this.';
																	 cr;
																	 cr ]
															 ifFalse: [
																 errorLinks isNotEmpty
																	 ifTrue: [
																		 outputStream
																			 nextPutAll: 'The file *';
																			 nextPutAll: file absolutePath;
																			 nextPutAll: '* has a non-embedded link on *';
																			 nextPutAll: errorLinks anyOne owner absolutePath;
																			 nextPutAll: '* - this should be embedded.';
																			 cr;
																			 cr ]
																	 ifFalse: [
																	 batchesOfFilesToLinks at: file put: linksToFile ] ] ] ] ] ] ].
					 writePictureFilesAndReturnUrls value:
						 (batchesOfFiles := batchesOfFilesToLinks keys).
					 pictureUrls := batchesOfFiles collect: aNameBlock.
					 batchesOfFiles with: pictureUrls do: [ :prFile :urlString |
						 urlString isEmpty
							 ifTrue: [
								 outputStream
									 nextPutAll: 'URL for *';
									 nextPutAll: prFile absolutePath;
									 nextPutAll: '* is empty, unable to create the picture file.';
									 cr;
									 cr ]
							 ifFalse: [
								 ([ urlString asUrl retrieveContents isEmpty ]
									  on: ZnHttpUnsuccessful
									  do: [ true ])
									 ifTrue: [
										 outputStream
											 nextPutAll: 'URL for *';
											 nextPutAll: prFile absolutePath;
											 nextPutAll: '* is *';
											 nextPutAll: urlString;
											 nextPutAll:
												 '* - but has an error retrieving the contents.';
											 cr;
											 cr ]
									 ifFalse: [
										 (batchesOfFilesToLinks at: prFile) do: [ :link |
											 outputStream
												 nextPutAll: 'Updated: *';
												 nextPutAll: link owner absolutePath;
												 nextPutAll: '* to have *';
												 nextPutAll: urlString asString;
												 nextPutAll: '* for ==';
												 nextPutAll: prFile title;
												 nextPutAll: '==.';
												 cr;
												 cr ] ] ] ] ]) ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> ftpFileToReport: userString pass: pwString host: hostString file: fileString reportOnPageAt: aPathString [
	"FTP is not secure, but available everywhere."

	| reportPage client |
	self guessTodoFromPath: aPathString.
	(reportPage := PRPathLookup start: self kernel root path: aPathString)
		isNil
		ifFalse: [ reportPage
				contents:
					(String
						streamContents: [ :stream | 
							self printReportHeaderOn: stream fields: ''.
							[ client := FTPClient openOnHostNamed: hostString.
							[ client loginUser: userString password: pwString ]
								on: LoginFailedException
								do: [ stream
										nextPutAll: 'Unable to connect to user: ';
										nextPutAll: userString;
										nextPut: $..
									client := nil ] ]
								on: NetworkError
								do: [ stream
										nextPutAll: 'Unable to connect via ftp to ';
										nextPutAll: hostString;
										nextPut: $..
									client := nil ].
							client
								ifNotNil: [ [ [ stream
										nextPutAll: (client getFileNamed: fileString);
										cr.
									client quit ]
										on: TelnetProtocolError
										do: [ stream
												nextPutAll: 'Error with ftp for ';
												nextPutAll: hostString;
												nextPut: $:;
												nextPutAll: fileString;
												nextPut: $.;
												cr ] ]
										ensure: [ client close ] ] ]) ]
]

{ #category : #accessing }
PRScheduledTaskExamples >> guessTodoFromPath: aPathString [
	| aPage |
	todo
		ifNil: [ aPage := PRPathLookup start: self kernel root path: aPathString.
			[ aPage isRoot ]
				whileFalse: [ aPage isToDo
						ifTrue: [ ^ self todo: aPage ]
						ifFalse: [ aPage := aPage parent ] ] ]
]

{ #category : #accessing }
PRScheduledTaskExamples >> kernel [
	kernel ifNil: [ self kernel: PRKernel instances anyOne ].
	^ kernel
]

{ #category : #accessing }
PRScheduledTaskExamples >> kernel: aKernel [
	kernel := aKernel
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> printReportHeaderOn: stream fields: aString [
	"This displays when the report was generated on the remote server, not in my local time."
	stream
		nextPutAll: 'Report generated on ';
		nextPutAll: (self todo displayDateWithTimeZoneDifference: DateAndTime now);
		cr;
		cr.
	aString isEmptyOrNil
		ifFalse: [ 
			stream
				nextPutAll: aString;
				cr ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> reportCheck: checkBlock thenRetrieveLink: aUrlString using: contentCheckBlock onPageAt: aReportPathString [

	| urlContents |
	self guessTodoFromPath: aReportPathString.
	(PRPathLookup start: self kernel root path: aReportPathString) 
		ifNotNil: [ :reportPage | 
			urlContents := nil.
			reportPage contents: (String streamContents: [ :stream | 
					 stream
						 nextPutAll:
							 (self todo displayDateWithTimeZoneDifference: DateAndTime now);
						 nextPutAll: ' - '.
					 ([ checkBlock value: reportPage ]
						  on: Error
						  do: [ :ignore | false ])
						 ifFalse: [ 
							 stream
								 nextPutAll: 'Pre-Check reported no need to retrieve from ';
								 nextPutAll: aUrlString asUrl host ]
						 ifTrue: [ 
							 [ 
							 [ 
							 urlContents := ZnClient new
								                beOneShot;
								                timeout: 45;
								                retryDelay: 15;
								                numberOfRetries: 3;
								                get: aUrlString asUrl ]
								 on: NameLookupFailure
								 do: [ :ignoreError | 
									 stream
										 nextPutAll: 'Name lookup failed for: ''';
										 nextPutAll: aUrlString asUrl host ] ]
								 on: ConnectionTimedOut
								 do: [ :er | 
									 stream
										 nextPutAll: 'Timed out connecting to: ''';
										 nextPutAll: aUrlString ].
							 urlContents ifNotNil: [ 
								 stream nextPutAll: ([ contentCheckBlock value: urlContents ]
										  on: Error
										  do: [ :error | 'Content block failed.' ]) ] ] ]) ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> reportOfBrokenLinksOnPageAt: aPathString [
	self reportOfBrokenLinksOnPageAt: aPathString startingFrom: '/'
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> reportOfBrokenLinksOnPageAt: aPathString startingFrom: aStartPageName [
	| reportPage |
	self guessTodoFromPath: aPathString.
	(reportPage := PRPathLookup start: self kernel root path: aPathString)
		ifNotNil: [ reportPage
				contents:
					(String
						streamContents: [ :stream | 
							self printReportHeaderOn: stream fields: '|!Page|!Broken Link'.
							(PRPathLookup start: self kernel root path: aStartPageName)
								enumerator everything
								do: [ :page | 
									page outgoingReferences
										do: [ :link | 
											(link isInternal and: [ link isBroken ])
												ifTrue: [ stream
														nextPutAll: '|*';
														nextPutAll: page absolutePath;
														nextPut: $*.
													stream
														nextPutAll: '|==';
														nextPutAll: link text;
														nextPutAll: '==';
														cr ] ] ] ]) ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> reportOfFile: anOsPathAndFilename onPageAt: aPathString [

	self
		reportOfFile: anOsPathAndFilename
		onPageAt: aPathString
		modifyUsing: [ :str | str ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> reportOfFile: anOsPathAndFilename onPageAt: aPathString modifyUsing: aStringBlock [

	| reportPage |
	self guessTodoFromPath: aPathString.
	(reportPage := PRPathLookup start: self kernel root path: aPathString) 
		ifNotNil: [ 
			anOsPathAndFilename.
			(File exists: anOsPathAndFilename)
				ifFalse: [ 
					reportPage contents: (String streamContents: [ :stream | 
							 self
								 printReportHeaderOn: stream
								 fields:
								 'The file: ' , anOsPathAndFilename , ' does not exist.' ]) ]
				ifTrue: [ 
					((File isReadable: anOsPathAndFilename) and: [ 
						 File isRegular: anOsPathAndFilename ])
						ifFalse: [ 
							reportPage contents: (String streamContents: [ :stream | 
									 self
										 printReportHeaderOn: stream
										 fields:
										 'The file: ' , anOsPathAndFilename , ' is not read-able.' ]) ]
						ifTrue: [ 
							| file |
							file := File openForReadFileNamed: anOsPathAndFilename.
							[ 
							reportPage contents: (String streamContents: [ :stream | 
									 self
										 printReportHeaderOn: stream
										 fields: ( aStringBlock value: file contents asString ) ]) ] ensure: [ 
								file ifNotNil: [ file close ] ] ] ] ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> reportOfHealthCheckOnPageAt: aPathString [
	| reportPage pagesWithUnusualChildren linksWithRaw |
	self guessTodoFromPath: aPathString.
	pagesWithUnusualChildren := Set new.
	self kernel root enumerator with all
		do: [ :e | 
			(e childrenDecoration children
				anySatisfy: [ :child | 
					(#(#PRPage #PRToDo #PRFile #PBBlog #PRComponent #PBPost #PRToDoTask #PBComment #PRWorkoutLog)
						includes: child class name) not ])
				ifTrue: [ pagesWithUnusualChildren add: e decorated absolutePath ] ].
	linksWithRaw := Set new.
	self kernel root enumerator with all
		do: [ :page | 
			page outgoingReferences
				do: [ :link | 
					(link children anySatisfy: [ :child | child class = PRRaw ])
						ifTrue: [ linksWithRaw add: page absolutePath ] ] ].
	(reportPage := PRPathLookup start: self kernel root path: aPathString)
		ifNotNil: [ reportPage
				contents:
					(String
						streamContents: [ :stream | 
							self class checkFSSpace
								ifTrue: [ self
										printReportHeaderOn: stream
										fields:
											'|!!Count of Pages with Unusual Children|!!Links with Raw HTML|!!Image Size|!!Disk Space' ]
								ifFalse: [ self
										printReportHeaderOn: stream
										fields:
											'|!!Count of Pages with Unusual Children|!!Links with Raw HTML|!!Image Size' ].
							stream nextPut: $|.
							pagesWithUnusualChildren isEmpty
								ifTrue: [ stream nextPutAll: 'none' ]
								ifFalse: [ pagesWithUnusualChildren
										do: [ :string | 
											stream
												nextPut: $*;
												nextPutAll: string;
												nextPut: $*;
												space ] ].
							stream nextPut: $|.
							linksWithRaw isEmpty
								ifTrue: [ stream nextPutAll: 'none' ]
								ifFalse: [ linksWithRaw
										do: [ :string | 
											stream
												nextPut: $*;
												nextPutAll: string;
												nextPutAll: '* ' ] ].
							stream
								nextPutAll: ' | ';
								nextPutAll: Smalltalk imageFile humanReadableSize.
							self class checkFSSpace
								ifTrue: [ stream
										nextPutAll: ' | ';
										nextPutAll: self runCheckDiskSpace ] ]) ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> reportOfHistoryOnPageAt: aPathString [
	| reportPage |
	self guessTodoFromPath: aPathString.
	(reportPage := PRPathLookup start: self kernel root path: aPathString)
		ifNotNil: [ reportPage
				contents:
					(String
						streamContents: [ :stream | 
							self printReportHeaderOn: stream fields: '|!History Size|!Limit'.
							stream
								nextPut: $|;
								nextPutAll: self kernel persistency history size asString;
								nextPut: $|.
							stream nextPutAll: self kernel persistency maxHistory asString ]) ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> reportOfImagesOnPageAt: aPathString [
	| reportPage search |
	self guessTodoFromPath: aPathString.
	(reportPage := PRPathLookup start: self kernel root path: aPathString)
		ifNotNil: [ (search := PRFullTextSearch on: self kernel root)
				subString: 'src="http'.
			reportPage
				contents:
					(String
						streamContents: [ :stream | 
							self
								printReportHeaderOn: stream
								fields: '|!Source|!Link|!Contents Size'.
							search
								do: [ :page | 
									| address |
									page name ~= 'Report'
										ifTrue: [ page contents
												regex: '[sS][rR][cC]="[hH][Tt][Tt][Pp][^"]*"'
												matchesCollect: [ :substr | 
													stream
														nextPutAll: '|*';
														nextPutAll: (address := substr copyFrom: 6 to: substr size - 1);
														nextPut: $*.
													stream
														nextPutAll: '|*';
														nextPutAll: page absolutePath;
														nextPut: $*.
													[ | contents |
													contents := address asUrl retrieveContents.
													stream
														nextPut: $|;
														nextPutAll: contents size asString;
														cr ]
														on: NetworkError
														do: [ :exception | 
															stream
																nextPutAll: '|No Connection due to: ';
																nextPutAll: exception printString;
																cr ] ] ] ] ]) ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> reportOfSchedulerAt: pathToTodo onPageAt: aPathString [
	| reportPage scheduler |
	self guessTodoFromPath: pathToTodo.
	scheduler := self todo scheduler.
	(reportPage := PRPathLookup start: self kernel root path: aPathString)
		ifNotNil: [ reportPage
				contents:
					(String
						streamContents: [ :stream | 
							self
								printReportHeaderOn: stream
								fields: '|!Task Name|!Next Run|!Run Count'.
							scheduler tasks
								do: [ :task | 
									stream nextPut: $|.
									(PRPathLookup start: self todo path: task description)
										ifNil: [ stream nextPutAll: task description asString ]
										ifNotNil: [ stream
												nextPut: $*;
												nextPutAll: pathToTodo asString;
												nextPut: $/;
												nextPutAll: task description asString;
												nextPut: $* ].
									stream
										nextPut: $|;
										space;
										nextPutAll: (self todo displayDateWithTimeZoneDifference: task nextRunTime);
										nextPut: $|;
										nextPutAll: task runHistory size asString;
										cr ] ]) ]
]

{ #category : #private }
PRScheduledTaskExamples >> runCheckDiskSpace [
	| dfOutput |
	dfOutput := (LibC resultOfCommand: 'df -h .') lines last substrings.
	^ dfOutput size < 6
		ifTrue: [ 'Failed to retrieve df -h output, found: ' , dfOutput asString ]
		ifFalse: [ dfOutput size = 9
				ifTrue: [ (dfOutput at: 5) , ' of ' , dfOutput second ]
				ifFalse: [ (dfOutput last: 2) first , ' of ' , dfOutput second ] ]
]

{ #category : #accessing }
PRScheduledTaskExamples >> todo [
	todo ifNil: [ self todo: PRToDo allInstances anyOne ].
	^ todo
]

{ #category : #accessing }
PRScheduledTaskExamples >> todo: aPRToDo [
	todo := aPRToDo
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> updateRepeatingTasksForPath: aString [
	(PRPathLookup start: self kernel root path: aString) tasks
		do: [ :task | task updateDueDateToCurrent ]
]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> writeAfterAppendTextFileNamed: aFileString using: aStreamBlock on: aStream [

	| file fileStream convertStream |
	self printReportHeaderOn: aStream fields: ''.
	[
	(file := File named: aFileString) exists
		ifFalse: [
			aStream
				nextPutAll: 'ERROR: The file ';
				nextPutAll: aFileString asString;
				nextPutAll: ' does not exist!' ]
		ifTrue: [
			fileStream := ZnCharacterWriteStream
				              on: file writeStream
				              encoding: ZnCharacterEncoder ascii.
			[
			fileStream setToEnd.
			convertStream := ZnNewLineWriterStream on: fileStream.
			convertStream forPlatformLineEnding.
			self class codeLockCritical: [ aStreamBlock value: convertStream ] ]
				ensure: [ fileStream close ].
			aStream nextPutAll: 'INFO: Successfully appended to the file' ] ]
		on: FileException
		do: [
			aStream
				nextPutAll: 'ERROR: FS exception for: ';
				nextPutAll: aFileString asString ]
]

{ #category : #accessing }
PRScheduledTaskExamples >> writeAfterAppendTextFileNamed: aFileString using: aStreamBlock reportOnPageAt: aPathString [

	| reportPage |
	self guessTodoFromPath: aPathString.
	(reportPage := PRPathLookup start: self kernel root path: aPathString)
		ifNotNil: [
			reportPage contents: (String streamContents: [ :stream |
					 self
						 writeAfterAppendTextFileNamed: aFileString
						 using: aStreamBlock
						 on: stream ]) ]

]

{ #category : #'wiki updates' }
PRScheduledTaskExamples >> writeAfterTruncateTextFileNamed: aFileString using: aStreamBlock reportOnPageAt: aPathString [

	"An example that creates a 2 line file:
	  (PRScheduledTaskExamples newForKernelNamed: 'Pier') 
		writeAfterTruncateTextFileNamed: '/tmp/example.txt'
		using: [ :s | s nextPutAll: 'This replaces a file'; newLine; nextPutAll: 'append will add to a file'; newLine ]
		reportOnPageAt: '/Epic Win/Test Task/Report'
	This assumes that you created the file."

	| reportPage file fileStream convertStream |
	self guessTodoFromPath: aPathString.
	(reportPage := PRPathLookup start: self kernel root path: aPathString) 
		ifNotNil: [ 
			reportPage contents: (String streamContents: [ :stream | 
					 self printReportHeaderOn: stream fields: ''.
					 [ 
					 (file := File named: aFileString) exists
						 ifFalse: [ 
							 stream
								 nextPutAll: 'ERROR: The file';
								 nextPutAll: aFileString asString;
								 nextPutAll: ' does not exist!' ]
						 ifTrue: [ 
							 fileStream := ZnCharacterWriteStream
								               on: file writeStream
								               encoding: ZnCharacterEncoder ascii.
							 [ 
							 self class codeLockCritical: [ 
								 fileStream truncate.
								 convertStream := ZnNewLineWriterStream on: fileStream.
								 aStreamBlock value: convertStream ] ] ensure: [ 
								 fileStream close ].
							 stream nextPutAll:
								 'INFO: Successfully truncated and wrote file' ] ]
						 on: FileException
						 do: [ 
							 stream
								 nextPutAll: 'ERROR: FS exception for: ';
								 nextPutAll: aFileString asString ] ]) ]
]
