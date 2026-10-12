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

	kernel := PRKernel instanceNamed: ('JustARandomMixFromLetterZoo' copy shuffle copyFrom: 1 to: 15).
	root := PRPage named: 'root'.
	todo := PRToDo named: 'todo'.
	task := PRToDoTask named: 'task'.
	report := PRPage named: 'report'.

	kernel root: root.
	root addChild: todo.
	todo addChild: task.
	task addChild: report
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
