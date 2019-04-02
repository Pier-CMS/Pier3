Class {
	#name : #PRPier3ToPier3ExportHelper,
	#superclass : #PRAbstractCodeExportHelper,
	#category : #'Pier-Exporter-Code'
}

{ #category : #'export helpers' }
PRPier3ToPier3ExportHelper >> handlerPRComponent: aPRComponent initialisationOn: stream [
	| defaultValueComponent prototypeInstance |
	
	stream << '	structure prototypeInstance: (' << aPRComponent componentClass name << ' new' << String cr.
	
	defaultValueComponent := aPRComponent componentClass new.
	prototypeInstance := aPRComponent prototypeInstance.
	
	prototypeInstance magritteDescription do: [ :aDescription |
		| value |
		
		value := prototypeInstance readUsing: aDescription.
		"only write values which are different from the defaults"
		(value ~= (defaultValueComponent readUsing: aDescription)) ifTrue: [
			| accessor |
			accessor := aDescription stringAccessor.
			(accessor = #default) ifTrue: [ self halt ].
			(accessor = #alternate) ifTrue: [ self halt ].
			(accessor class canUnderstand: #readSelector) ifTrue: [
				stream << '		' << accessor readSelector << ': ' << value asCode << ';' << String cr ].
		
			"if the value is a structure we need to make sure we avoid a recursive loop "
			(value isKindOf: PRStructure) ifTrue: [ 
				self recursiveMethods add: value asSelector ] ] ].
	
	stream << '		yourself).' << String cr.	
]
