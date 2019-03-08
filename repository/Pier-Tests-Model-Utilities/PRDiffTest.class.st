Class {
	#name : #PRDiffTest,
	#superclass : #TestCase,
	#category : #'Pier-Tests-Model-Utilities'
}

{ #category : #tests }
PRDiffTest >> testDeletionMany [
	| diff |
	diff := PRDiffAlgorithm from: #(a b c) to: #().
	self assert: diff patchset =  #((#- a) (#- b) (#- c))
]

{ #category : #tests }
PRDiffTest >> testDeletionSingle [
	| diff |
	diff := PRDiffAlgorithm from: #(a b c) to: #(a c).
	self assert: diff patchset =  #((= a) (#- b) (= c))
]

{ #category : #tests }
PRDiffTest >> testEqualityEmpty [
	| diff |
	diff := PRDiffAlgorithm from: #() to: #().
	self assert: diff patchset =  #()
]

{ #category : #tests }
PRDiffTest >> testEqualityMany [
	| diff |
	diff := PRDiffAlgorithm from: #(a b c) to: #(a b c).
	self assert: diff patchset =  #((= a) (= b) (= c))
]

{ #category : #tests }
PRDiffTest >> testInsertionMany [
	| diff |
	diff := PRDiffAlgorithm from: #() to: #(a b c).
	self assert: diff patchset =  #((+ a) (+ b) (+ c))
]

{ #category : #tests }
PRDiffTest >> testInsertionSingle [
	| diff |
	diff := PRDiffAlgorithm from: #(a c) to: #(a b c).
	self assert: diff patchset =  #((= a) (+ b) (= c))
]

{ #category : #'tests-specialized' }
PRDiffTest >> testLineDiff [
	| diff |
	diff := PRLineDiffAlgorithm from: 'foo
bar
zork' to: 'foo
zonk
zork'.
	self assert: diff patchset = #((= 'foo') (#- 'bar') (+ 'zonk') (= 'zork'))
]

{ #category : #tests }
PRDiffTest >> testReplacementMany [
	| diff |
	diff := PRDiffAlgorithm from: #(x y z) to: #(a b c).
	self assert: diff patchset =  #((#- x) (#- y) (#- z) (+ a) (+ b) (+ c))
]

{ #category : #tests }
PRDiffTest >> testReplacementSingle [
	| diff  |
	diff := PRDiffAlgorithm from: #(a x c) to: #(a b c).
	self assert: diff patchset =  #((= a) (#- x) (+ b) (= c))
]

{ #category : #'tests-specialized' }
PRDiffTest >> testWordDiff [
	| diff |
	diff := PRWordDiffAlgorithm from: 'foo bar zork' to: 'foo zonk zork'.
	self assert: diff patchset = #((= 'foo') (#- 'bar') (+ 'zonk') (= 'zork'))
]
