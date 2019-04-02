Class {
	#name : #PRPier1or2ToPier1or2ExportHelper,
	#superclass : #PRAbstractCodeExportHelper,
	#category : #'Pier-Exporter-Code'
}

{ #category : #'export helpers' }
PRPier1or2ToPier1or2ExportHelper >> asCodeFor: structure description: description value: value on: stream [
	| structureClass |
	structureClass := structure class greaseString.
	stream << '(' << structureClass << ' description detect: [ :each | each label = ''' << description label << ''' ]) accessor write: ' << value << ' to: structure. '
]

{ #category : #'export helpers' }
PRPier1or2ToPier1or2ExportHelper >> handlerPRComponent: aPRComponent initialisationOn: stream [
	aPRComponent settings associationsDo: [ :aDescriptionValuePair |
		stream << '	structure write: ' << aDescriptionValuePair value asCode << 
			' using: ' << aPRComponent componentClass name << ' ' 
				<< (self selectorFromDescription: aDescriptionValuePair key onClass: aPRComponent componentClass)
				<< '.' << String cr.
		
		"if the value is a structure we need to make sure we avoid a recursive loop "
		(aDescriptionValuePair value isKindOf: PRStructure) ifTrue: [ 
			recursiveMethods add: aDescriptionValuePair value asSelector ] ]
]

{ #category : #'export helpers' }
PRPier1or2ToPier1or2ExportHelper >> selectorFromDescription: aDescription onClass: aClass [
	| descriptionDefinitionsSelectors descriptionSelectors |
	descriptionSelectors := aClass class allSelectors select: [ :each | each isDescriptionSelector ].
	descriptionDefinitionsSelectors := SortedCollection withAll: (descriptionSelectors select: [ :each | each isDescriptionDefinition ]).	
	
	^ descriptionDefinitionsSelectors 
		detect: [ :selector | | selectorDescription |
			"create description for selector taking into account description extensions"
			selectorDescription := (descriptionSelectors select: [ :each | each isDescriptionExtension: selector ])
				inject: (aClass perform: selector)
				into: [ :result :each | aClass perform: each with: result ].
				
			"have we found the selector which generates this description?"
			selectorDescription = aDescription ]
		ifNone: [ Transcript show: 'Class: ', aClass greaseString, ' unable to find description: "', aDescription greaseString, '"'; cr.  
			descriptionDefinitionsSelectors first ]
]
