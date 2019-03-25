Class {
	#name : #WARequestFieldsTests,
	#superclass : #TestCase,
	#category : #'Pier-Tests-Model-Utilities'
}

{ #category : #tests }
WARequestFieldsTests >> testRemoveKey [
	| map removed |
	map := (WARequestFields new: 2)
		add: 1 -> 'one';
		add: 2 -> 'two';
		yourself.
	self shouldnt: [ removed := map removeKey: 2 ] raise: SubscriptOutOfBounds.
	self assert: removed equals: #('two')
]
