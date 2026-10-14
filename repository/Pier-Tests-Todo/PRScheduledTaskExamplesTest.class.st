"
This class contains tests. The tearDown includes removing the name of the kernel created in #setUp so that PRKernel instances does not fill up with test artifacts.
"
Class {
	#name : #PRScheduledTaskExamplesTest,
	#superclass : #TestCase,
	#instVars : [
		'kernel',
		'root',
		'todo',
		'task',
		'report'
	],
	#category : #'Pier-Tests-Todo'
}

{ #category : #running }
PRScheduledTaskExamplesTest >> setUp [

	super setUp.

	kernel := PRKernel instanceNamed:
		          ('JustARandomMixFromTheLetterZoo' copy shuffle
			           copyFrom: 1
			           to: 15).
	root := PRPage named: 'root'.
	todo := PRToDo named: 'todo'.
	task := PRToDoTask named: 'task'.
	report := PRPage named: 'report'.

	kernel root: root.
	root addChild: todo.
	todo addChild: task.
	task addChild: report
]

{ #category : #running }
PRScheduledTaskExamplesTest >> tearDown [

	PRKernel remove: kernel name.

	super tearDown
]

{ #category : #tests }
PRScheduledTaskExamplesTest >> testReportOfBrokenLinksOnPageAtStartingFrom [
	| childPage |
	childPage := PRPage named: 'Child'.
	childPage contents: 'First test is for a page with no links.'.
	root addChild: childPage.
	
	(PRScheduledTaskExamples newForKernelNamed: kernel name)
		reportOfBrokenLinksOnPageAt: report absolutePath 
		startingFrom: childPage absolutePath.
	self assert: report contents lines size equals: 3.
	childPage contents: 'Second test is for a page with a *broken links>/This/Does/Not/Exist*.'.
	(PRScheduledTaskExamples newForKernelNamed: kernel name)
		reportOfBrokenLinksOnPageAt: report absolutePath 
		startingFrom: childPage absolutePath.
	self assert: report contents lines size equals: 4
]

{ #category : #tests }
PRScheduledTaskExamplesTest >> testReportOfOnPageAt [

	| testValue |
	testValue := 'Test has not ran'.
	PRScheduledTaskExamples new
		reportOf: [ testValue := 'Test has ran' ]
		onPageAt: report absolutePath.
	self assert: testValue equals: 'Test has ran'
]
