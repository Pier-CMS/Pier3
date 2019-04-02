Class {
	#name : #PRPier1or2ToPier3ExportHelper,
	#superclass : #PRAbstractCodeExportHelper,
	#category : #'Pier-Exporter-Code'
}

{ #category : #'export helpers' }
PRPier1or2ToPier3ExportHelper >> handlerPRComponent: aPRComponent initialisationOn: stream [
	stream << '	structure prototypeInstance: (' << aPRComponent componentClass name << ' new' << String cr.
	aPRComponent settings associationsDo: [ :aDescriptionValuePair |
		| accessor |
		accessor := aDescriptionValuePair key accessor.
		(accessor class canUnderstand: #readSelector) ifTrue: [
			stream << '		' << accessor readSelector << ': ' << aDescriptionValuePair value asCode << ';' << String cr ].
		
		"if the value is a structure we need to make sure we avoid a recursive loop "
		(aDescriptionValuePair value isKindOf: PRStructure) ifTrue: [ 
			self recursiveMethods add: aDescriptionValuePair value asSelector ] ].
	stream << '		yourself).' << String cr.
]
