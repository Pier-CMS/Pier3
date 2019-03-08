"
Smalltalk Diff Algorithm, based on the Javascript implementation by John Resig and Chu Alan.

http://jquery-ui.googlecode.com/svn/tags/1.7.2/external/jsdiff/jsdiff.js
"
Class {
	#name : #PRDiffAlgorithm,
	#superclass : #Object,
	#instVars : [
		'source',
		'sourceMap',
		'sourceText',
		'sourceRow',
		'target',
		'targetMap',
		'targetText',
		'targetRow'
	],
	#category : #'Pier-Model-Utilities'
}

{ #category : #'instance creation' }
PRDiffAlgorithm class >> from: aSourceSequence to: aTargetSequence [
	^ self basicNew initializeFrom: aSourceSequence to: aTargetSequence
]

{ #category : #initialization }
PRDiffAlgorithm >> initializeFrom: aSourceSequence to: aTargetSequence [
	self source: aSourceSequence.
	self target: aTargetSequence.
	self initializeMapping
]

{ #category : #initialization }
PRDiffAlgorithm >> initializeMapping [
	targetMap keysDo: [ :i |
		((targetMap at: i) size = 1 and: [ (sourceMap includesKey: i) and: [ (sourceMap at: i) size = 1 ] ]) ifTrue: [ 
			targetText at: (targetMap at: i) first put: (target at: (targetMap at: i) first).
			targetRow at: (targetMap at: i) first put: (sourceMap at: i) first.
			sourceText at: (sourceMap at: i) first put: (source at: (sourceMap at: i) first).
			sourceRow at: (sourceMap at: i) first put: (targetMap at: i) first ] ].
	1 to: target size - 1 do: [ :i |
		((targetText at: i) notNil 
			and: [ (targetText at: i + 1) isNil 
			and: [ (targetRow at: i) + 1 < source size 
			and: [ (sourceText at: (targetRow at: i) + 1) isNil 
			and: [ (target at: i + 1) = (source at: (targetRow at: i) + 1) ] ] ] ]) ifTrue: [
				targetText at: i + 1 put: (target at: i + 1).
				targetRow at: i + 1 put: (targetRow at: i) + 1.
				sourceText at: (targetRow at: i) + 1 put: (source at: (targetRow at: i) + 1).
				sourceRow at: (targetRow at: i) + 1 put: i + 1 ] ].
	target size to: 2 by: -1 do: [ :i |
		((targetText at: i) notNil 
			and: [ (targetText at: i - 1) isNil 
			and: [ (targetRow at: i) > 1
			and: [ (sourceText at: (targetRow at: i) - 1) isNil 
			and: [ (target at: i - 1) = (source at: (targetRow at: i) - 1) ] ] ] ]) ifTrue: [
				targetText at: i - 1 put: (target at: i - 1).
				targetRow at: i - 1 put: (targetRow at: i) - 1.
				sourceText at: (targetRow at: i) - 1 put: (source at: (targetRow at: i) - 1).
				sourceRow at: (targetRow at: i) - 1 put: i - 1 ] ]
]

{ #category : #patching }
PRDiffAlgorithm >> patchset [
	| patchset |
	patchset := OrderedCollection new.
	self patchsetDo: [ :operation :object :index | patchset addLast: (Array with: operation with: object) ].
	^ patchset asArray
]

{ #category : #patching }
PRDiffAlgorithm >> patchsetDo: aBlock [
	"Evaluate aBlock for every patch operation of the receiver. The first argument is the operation, where #= is identity, #+ is insertion, and #- is deletion. The second argument is the object. The third argument the index in the source or target list."

	| sourceIndex targetIndex |
	sourceIndex := targetIndex := 1.
	[ sourceIndex <= source size or: [ targetIndex <= target size ] ] whileTrue: [
		[ sourceIndex <= source size and: [ (sourceText at: sourceIndex) isNil ] ] whileTrue: [
			aBlock value: #- value: (source at: sourceIndex) value: sourceIndex.
			sourceIndex := sourceIndex + 1 ].
		[ targetIndex <= target size and: [ (targetText at: targetIndex) isNil ] ] whileTrue: [
			aBlock value: #+ value: (target at: targetIndex) value: targetIndex.
			targetIndex := targetIndex + 1 ].
		targetIndex <= target size
			ifTrue: [ aBlock value: #= value: (targetText at: targetIndex) value: targetIndex ].
		sourceIndex := sourceIndex + 1.
		targetIndex := targetIndex + 1 ]
]

{ #category : #accessing }
PRDiffAlgorithm >> source: aCollection [
	"Set the source sequence."

	source := aCollection asArray.
	sourceText := Array new: source size.
	sourceRow := Array new: source size.
	sourceMap := Dictionary new.
	source keysAndValuesDo: [ :index :each |
		(sourceMap at: each ifAbsentPut: [ OrderedCollection new ])
			addLast: index ]
]

{ #category : #accessing }
PRDiffAlgorithm >> target: aCollection [
	"Set the target sequence."

	target := aCollection asArray.
	targetText := Array new: target size.
	targetRow := Array new: target size.
	targetMap := Dictionary new.
	target keysAndValuesDo: [ :index :each | 
		(targetMap at: each ifAbsentPut: [ OrderedCollection new ])
			addLast: index ]
]
