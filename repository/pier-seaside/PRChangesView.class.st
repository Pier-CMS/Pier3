Class {
	#name : #PRChangesView,
	#superclass : #PRHistoryView,
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRChangesView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRChangesView class >> label [
	^ 'Changes'
]

{ #category : #private }
PRChangesView >> buildReport [
	^ super buildReport
		addColumn: (MACommandColumn new
			addCommand: [ :value | self open: value copy ] text: 'open';
			yourself);
		yourself
]

{ #category : #private }
PRChangesView >> isVisible: aContext [
	^ aContext command isEdit and: [ super isVisible: aContext ]
]
