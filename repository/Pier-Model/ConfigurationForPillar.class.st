Class {
	#name : #ConfigurationForPillar,
	#superclass : #PRObject,
	#category : #'Pier-Model-Utilities'
}

{ #category : #description }
ConfigurationForPillar class >> chrysalDescriptions [
	"I'm a generated method. I'm just here to help remembering how the class was generated. I should only be executed in presence of the configurationBuilder contained in the Chrysal package. Indeed the item objects only exist at compile-time and STON will recreate them."
	 ^ STON fromString: '[
	PathConfigurationItem {
		#propertyName : #bibFile,
		#default : ''book.bib'',
		#explanation : ''Identify the file to be taken as input for the bibliography. This is the .bib file used to resolve the ${cite:ref=Key}$ annotation.''
	},
	StringConfigurationItem {
		#propertyName : #title,
		#default : ''my super cool book''
	},
	StringConfigurationItem {
		#propertyName : #attribution,
		#default : ''me, myself and I''
	},
	NumberConfigurationItem {
		#propertyName : #headingLevelOffset,
		#default : 0,
		#explanation : ''Indicate how to convert from the level of a Pillar heading to the level of heading in your exported document.\r\tFor example, a headingLevelOffset of 3 converts a 1st level Pillar heading to an <h4>in HTML''
	},
	StringConfigurationItem {
		#propertyName : #series,
		#default : ''Square Bracket Associate Collection''
	},
	StringConfigurationItem {
		#propertyName : #keywords,
		#default : ''Pharo''
	},
	PathConfigurationItem {
		#propertyName : #outputDirectory,
		#default : ''build''
	},
	FolderConfigurationItem {
		#propertyName : #baseDirectory,
		#default : ''.''
	},
	FileConfigurationItem {
		#propertyName : #outputFile,
		#default : ''output'',
		#explanation : ''If separateOutputFiles is false, indicate the name of the output file. This can also be a write stream.''
	},
	FileConfigurationItem {
		#propertyName : #mainDocument,
		#default : ''book''
	},
	FileConfigurationItem {
		#propertyName : #inputFile,
		#default : ''book'',
		#explanation : ''The Pillar file that must be transformed. You can also specify an input file at the end of the command-line interface. Previously there was no default value''
	},
	StringConfigurationItem {
		#propertyName : #latexTemplate,
		#default : ''_support/templates/main.latex.mustache''
	},
	BooleanConfigurationItem {
		#propertyName : #scrambledEmailAddresses,
		#default : ''false''
	},
	BooleanConfigurationItem {
		#propertyName : #separateOutputFiles,
		#default : ''false'',
		#explanation : ''If true, each input file is exported to one output file. If false (the default), all input files are exported to outputFile.''
	},
	BooleanConfigurationItem {
		#propertyName : #renderStructureAsSlide,
		#default : ''true'',
		#explanation : ''When true (the default), Pillar will create a dedicated slide for each Pillar header. This parameter is meaningless when generating a written document''
	},
	StringConfigurationItem {
		#propertyName : #latexChapterTemplate,
		#default : ''_support/templates/chapter.latex.mustache''
	},
	StringConfigurationItem {
		#propertyName : #htmlTemplate,
		#default : ''_support/templates/html.mustache''
	},
	StringConfigurationItem {
		#propertyName : #htmlChapterTemplate,
		#default : ''_support/templates/html.mustache''
	},
	NewLineConfigurationItem {
		#propertyName : #newLine,
		#default : #platform,
		#explanation : ''The string that separates lines in the exported document. This is often either LF or CR\\+LF but any string is possible. Values are #(#cr #lf #crlf #unix #mac #dos #platform)'',
		#defaultKey : #platform
	},
	StringConfigurationItem {
		#propertyName : #latexWriter,
		#default : #''latex:sbabook''
	},
	StringConfigurationItem {
		#propertyName : #htmlWriter,
		#default : #html
	},
	NumberConfigurationItem {
		#propertyName : #slideInTemplateForDeckJS,
		#default : 1,
		#explanation : ''Number of slides in Template: Indicate the number of slides created by the DeckJS template. This is important to create anchors.''
	},
	CodeBlockDefaultLanguageItem {
		#propertyName : #defaultScriptLanguage,
		#explanation : ''Indicate the language in scripts when none is specified. This language is used for syntax highlighting. The currently supported languages are bash, css, html, http, json, javascript, pillar, sql, ston, shellcommands and smalltalk''
	},
	CompositeConfigurationItem {
		#propertyName : #levelSpecification,
		#default : #PRTitlePrinterSpecification,
		#fields : [
			#level,
			#renderAs,
			#capitalization,
			#numbering,
			#headerSize
		]
	},
	ListConfigurationItem {
		#propertyName : #levels,
		#default : #OrderedCollection,
		#element : #levelSpecification
	},
	PathConfigurationItem {
		#propertyName : #tocFile,
		#default : ''.'',
		#explanation : ''Identify the file to be taken as input for the root of the table of contents. When it is not specified, the table of contents will not be computed and displayed''
	}
]'
]

{ #category : #testing }
ConfigurationForPillar class >> isAbstract [
	^ false
]

{ #category : #accessing }
ConfigurationForPillar >> attribution [
	"generated code"
	^ self propertyAt: #attribution ifAbsent: ['me, myself and I']
]

{ #category : #accessing }
ConfigurationForPillar >> attribution: aValue [
	"generated code"
	^ self propertyAt: #attribution put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> baseDirectory [
	"generated code"
	^ self propertyAt: #baseDirectory ifAbsent: [(FileSystem workingDirectory / '.')]
]

{ #category : #accessing }
ConfigurationForPillar >> baseDirectory: aValue [
	"generated code"
	^ self propertyAt: #baseDirectory put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> bibFile [
	"generated code"
	^ self propertyAt: #bibFile ifAbsent: [Path from: 'book.bib']
]

{ #category : #accessing }
ConfigurationForPillar >> bibFile: aValue [
	"generated code"
	^ self propertyAt: #bibFile put: aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertAttribution: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertBaseDirectory: aValue [
	"generated code"
	^ (FileSystem workingDirectory / aValue)
]

{ #category : #conversion }
ConfigurationForPillar >> convertBibFile: aValue [
	"generated code"
	^ Path from: aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertDefaultScriptLanguage: aValue [
	"generated code"
	^ PRAbstractScriptLanguage for: aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertHeadingLevelOffset: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertHtmlChapterTemplate: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertHtmlTemplate: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertHtmlWriter: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertInputFile: aValue [
	"generated code"
	^ (FileSystem workingDirectory / aValue)
]

{ #category : #conversion }
ConfigurationForPillar >> convertKeywords: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertLatexChapterTemplate: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertLatexTemplate: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertLatexWriter: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertLevelSpecification: aValue [
	"generated code"
	| composite |
	composite := PRTitlePrinterSpecification new.
	aValue do: [:v | 
		    "We ignore undeclared fields"
			(#(#level #renderAs #capitalization #numbering #headerSize) includes: v key asSymbol)
				ifTrue: [ 
					| value |
					"if the element has been described we convert"
					(self declaredItems includes: v key asSymbol)
						ifTrue: [ value := self perform: (#convert, v key capitalized, ':') asSymbol with: v value ]
						ifFalse: [ value := v value ].		
					composite 
								perform:  (v key, ':') asSymbol 
								with: value].
		].
	^ composite
]

{ #category : #conversion }
ConfigurationForPillar >> convertLevels: aValue [
	"generated code"
	| elements |
	elements := OrderedCollection new.
	aValue do: [:v | 
		 elements add: (self convertLevelSpecification: v ) ].
	^ elements
]

{ #category : #conversion }
ConfigurationForPillar >> convertMainDocument: aValue [
	"generated code"
	^ (FileSystem workingDirectory / aValue)
]

{ #category : #conversion }
ConfigurationForPillar >> convertNewLine: aValue [
	"generated code"
	^ (Dictionary
			newFrom:
				{(#cr -> String cr).
				(#lf -> UnixPlatform new lineEnding).
				(#crlf -> Win32Platform new lineEnding).
				(#unix -> UnixPlatform new lineEnding).
				(#mac -> UnixPlatform new lineEnding).
				(#dos -> Win32Platform new lineEnding)}) at: aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertOutputDirectory: aValue [
	"generated code"
	^ Path from: aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertOutputFile: aValue [
	"generated code"
	^ (FileSystem workingDirectory / aValue)
]

{ #category : #conversion }
ConfigurationForPillar >> convertRenderStructureAsSlide: aValue [
	"generated code"
	^ aValue 
]

{ #category : #conversion }
ConfigurationForPillar >> convertScrambledEmailAddresses: aValue [
	"generated code"
	^ aValue 
]

{ #category : #conversion }
ConfigurationForPillar >> convertSeparateOutputFiles: aValue [
	"generated code"
	^ aValue 
]

{ #category : #conversion }
ConfigurationForPillar >> convertSeries: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertSlideInTemplateForDeckJS: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertTitle: aValue [
	"generated code"
	^ aValue
]

{ #category : #conversion }
ConfigurationForPillar >> convertTocFile: aValue [
	"generated code"
	^ Path from: aValue
]

{ #category : #'declared items' }
ConfigurationForPillar >> declaredItems [
	"generated code"
	^ #( #bibFile #title #attribution #headingLevelOffset #series #keywords #outputDirectory #baseDirectory #outputFile #mainDocument #inputFile #latexTemplate #scrambledEmailAddresses #separateOutputFiles #renderStructureAsSlide #latexChapterTemplate #htmlTemplate #htmlChapterTemplate #newLine #latexWriter #htmlWriter #slideInTemplateForDeckJS #defaultScriptLanguage #levelSpecification #levels #tocFile )
]

{ #category : #accessing }
ConfigurationForPillar >> defaultScriptLanguage [
	"generated code"
	^ self propertyAt: #defaultScriptLanguage ifAbsent: [(PRRealScriptLanguage for: nil)]
]

{ #category : #accessing }
ConfigurationForPillar >> defaultScriptLanguage: aValue [
	"generated code"
	^ self propertyAt: #defaultScriptLanguage put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> headingLevelOffset [
	"generated code"
	^ self propertyAt: #headingLevelOffset ifAbsent: [0]
]

{ #category : #accessing }
ConfigurationForPillar >> headingLevelOffset: aValue [
	"generated code"
	^ self propertyAt: #headingLevelOffset put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> htmlChapterTemplate [
	"generated code"
	^ self propertyAt: #htmlChapterTemplate ifAbsent: ['_support/templates/html.mustache']
]

{ #category : #accessing }
ConfigurationForPillar >> htmlChapterTemplate: aValue [
	"generated code"
	^ self propertyAt: #htmlChapterTemplate put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> htmlTemplate [
	"generated code"
	^ self propertyAt: #htmlTemplate ifAbsent: ['_support/templates/html.mustache']
]

{ #category : #accessing }
ConfigurationForPillar >> htmlTemplate: aValue [
	"generated code"
	^ self propertyAt: #htmlTemplate put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> htmlWriter [
	"generated code"
	^ self propertyAt: #htmlWriter ifAbsent: ['html']
]

{ #category : #accessing }
ConfigurationForPillar >> htmlWriter: aValue [
	"generated code"
	^ self propertyAt: #htmlWriter put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> inputFile [
	"generated code"
	^ self propertyAt: #inputFile ifAbsent: [(FileSystem workingDirectory / 'book')]
]

{ #category : #accessing }
ConfigurationForPillar >> inputFile: aValue [
	"generated code"
	^ self propertyAt: #inputFile put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> keywords [
	"generated code"
	^ self propertyAt: #keywords ifAbsent: ['Pharo']
]

{ #category : #accessing }
ConfigurationForPillar >> keywords: aValue [
	"generated code"
	^ self propertyAt: #keywords put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> latexChapterTemplate [
	"generated code"
	^ self propertyAt: #latexChapterTemplate ifAbsent: ['_support/templates/chapter.latex.mustache']
]

{ #category : #accessing }
ConfigurationForPillar >> latexChapterTemplate: aValue [
	"generated code"
	^ self propertyAt: #latexChapterTemplate put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> latexTemplate [
	"generated code"
	^ self propertyAt: #latexTemplate ifAbsent: ['_support/templates/main.latex.mustache']
]

{ #category : #accessing }
ConfigurationForPillar >> latexTemplate: aValue [
	"generated code"
	^ self propertyAt: #latexTemplate put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> latexWriter [
	"generated code"
	^ self propertyAt: #latexWriter ifAbsent: ['latex:sbabook']
]

{ #category : #accessing }
ConfigurationForPillar >> latexWriter: aValue [
	"generated code"
	^ self propertyAt: #latexWriter put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> levelSpecification [
	"generated code"
	^ self propertyAt: #levelSpecification ifAbsent: [ PRTitlePrinterSpecification new ]
]

{ #category : #accessing }
ConfigurationForPillar >> levelSpecification: aValue [
	"generated code"
	^ self propertyAt: #levelSpecification put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> levels [
	"generated code"
	^ self propertyAt: #levels ifAbsent: [ OrderedCollection new ]
]

{ #category : #accessing }
ConfigurationForPillar >> levels: aValue [
	"generated code"
	^ self propertyAt: #levels put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> mainDocument [
	"generated code"
	^ self propertyAt: #mainDocument ifAbsent: [(FileSystem workingDirectory / 'book')]
]

{ #category : #accessing }
ConfigurationForPillar >> mainDocument: aValue [
	"generated code"
	^ self propertyAt: #mainDocument put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> newLine [
	^ Smalltalk os lineEnding
]

{ #category : #accessing }
ConfigurationForPillar >> newLine: aValue [
	"generated code"
	^ self propertyAt: #newLine put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> outputDirectory [
	"generated code"
	^ self propertyAt: #outputDirectory ifAbsent: [Path from: 'build']
]

{ #category : #accessing }
ConfigurationForPillar >> outputDirectory: aValue [
	"generated code"
	^ self propertyAt: #outputDirectory put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> outputFile [
	"generated code"
	^ self propertyAt: #outputFile ifAbsent: [(FileSystem workingDirectory / 'output')]
]

{ #category : #accessing }
ConfigurationForPillar >> outputFile: aValue [
	"generated code"
	^ self propertyAt: #outputFile put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> renderStructureAsSlide [
	"generated code"
	^ self propertyAt: #renderStructureAsSlide ifAbsent: [true]
]

{ #category : #accessing }
ConfigurationForPillar >> renderStructureAsSlide: aValue [
	"generated code"
	^ self propertyAt: #renderStructureAsSlide put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> scrambledEmailAddresses [
	"generated code"
	^ self propertyAt: #scrambledEmailAddresses ifAbsent: [false]
]

{ #category : #accessing }
ConfigurationForPillar >> scrambledEmailAddresses: aValue [
	"generated code"
	^ self propertyAt: #scrambledEmailAddresses put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> separateOutputFiles [
	"generated code"
	^ self propertyAt: #separateOutputFiles ifAbsent: [false]
]

{ #category : #accessing }
ConfigurationForPillar >> separateOutputFiles: aValue [
	"generated code"
	^ self propertyAt: #separateOutputFiles put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> series [
	"generated code"
	^ self propertyAt: #series ifAbsent: ['Square Bracket Associate Collection']
]

{ #category : #accessing }
ConfigurationForPillar >> series: aValue [
	"generated code"
	^ self propertyAt: #series put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> slideInTemplateForDeckJS [
	"generated code"
	^ self propertyAt: #slideInTemplateForDeckJS ifAbsent: [1]
]

{ #category : #accessing }
ConfigurationForPillar >> slideInTemplateForDeckJS: aValue [
	"generated code"
	^ self propertyAt: #slideInTemplateForDeckJS put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> title [
	"generated code"
	^ self propertyAt: #title ifAbsent: ['my super cool book']
]

{ #category : #accessing }
ConfigurationForPillar >> title: aValue [
	"generated code"
	^ self propertyAt: #title put: aValue
]

{ #category : #accessing }
ConfigurationForPillar >> tocFile [
	"generated code"
	^ self propertyAt: #tocFile ifAbsent: [Path from: '.']
]

{ #category : #accessing }
ConfigurationForPillar >> tocFile: aValue [
	"generated code"
	^ self propertyAt: #tocFile put: aValue
]
