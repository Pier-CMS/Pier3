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
		'ShouldCheckFSSpace'
	],
	#category : #'Pier-ToDo'
}

{ #category : #asserting }
PRScheduledTaskExamples class >> checkFSSpace [
	ShouldCheckFSSpace ifNil: [ ShouldCheckFSSpace := true ].
	^ ShouldCheckFSSpace
]

{ #category : #'instance creation' }
PRScheduledTaskExamples class >> newForKernelNamed: aString [
	^ self new
		kernel: (PRKernel instanceNamed: aString);
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
	| reportPage urlContents |
	self guessTodoFromPath: aReportPathString.
	(reportPage := PRPathLookup
		start: self kernel root
		path: aReportPathString)
		ifNotNil: [ :arg | 
			urlContents := nil.
			reportPage
				contents:
					(String
						streamContents: [ :stream | 
							stream
								nextPutAll: (self todo displayDateWithTimeZoneDifference: DateAndTime now);
								nextPutAll: ' - '.
							([ checkBlock value: reportPage ]
								on: Error
								do: [ :err | false ])
								ifFalse: [ stream
										nextPutAll: 'Pre-Check reported no need to retrieve from ';
										nextPutAll: aUrlString asUrl host ]
								ifTrue: [ [ [ urlContents := aUrlString asUrl retrieveContents ]
										on: NameLookupFailure
										do: [ :err | 
											stream
												nextPutAll: 'Name lookup failed for: ''';
												nextPutAll: aUrlString asUrl host ] ]
										on: ConnectionTimedOut
										do: [ :err | 
											stream
												nextPutAll: 'Timed out connecting to: ''';
												nextPutAll: aUrlString ].
									urlContents
										ifNotNil: [ :arg | 
											stream
												nextPutAll:
													([ contentCheckBlock value: urlContents ]
														on: Error
														do: [ :err | 'Content block failed.' ]) ] ] ]) ]
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
	dfOutput := (LibC resultOfCommand: 'df -k .') lines last substrings.
	^ dfOutput size < 6
		ifTrue: [ 'Failed to retrieve df -k output, found: ' , dfOutput asString ]
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
