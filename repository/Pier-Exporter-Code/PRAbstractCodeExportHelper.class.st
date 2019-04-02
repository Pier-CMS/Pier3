Class {
	#name : #PRAbstractCodeExportHelper,
	#superclass : #GRObject,
	#instVars : [
		'recursiveMethods'
	],
	#category : #'Pier-Exporter-Code'
}

{ #category : #'instance creation' }
PRAbstractCodeExportHelper class >> recursiveMethods: recursiveMethodsCollection [
	^ self new
		recursiveMethods: recursiveMethodsCollection;
		yourself
]

{ #category : #'export helpers' }
PRAbstractCodeExportHelper >> asCodeFor: structure description: description value: value on: stream [
	stream << '	(structure magritteDescription detect: [ :each | each label = ''' << description label << ''' ]) accessor write: ' << value << ' to: structure. '
]

{ #category : #'export helpers' }
PRAbstractCodeExportHelper >> handlerPRComponent: aPRComponent initialisationOn: stream [
	self subclassResponsibility
]

{ #category : #accessing }
PRAbstractCodeExportHelper >> recursiveMethods [
	^ recursiveMethods
]

{ #category : #accessing }
PRAbstractCodeExportHelper >> recursiveMethods: anObject [
	recursiveMethods := anObject
]
