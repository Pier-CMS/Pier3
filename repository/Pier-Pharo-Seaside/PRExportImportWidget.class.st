Class {
	#name : #PRExportImportWidget,
	#superclass : #PRWidget,
	#instVars : [
		'exporterImporter',
		'replace'
	],
	#category : #'Pier-Pharo-Seaside'
}

{ #category : #accessing }
PRExportImportWidget class >> groupLabel [
	^ 'Pier System'
]

{ #category : #testing }
PRExportImportWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRExportImportWidget class >> label [
	^ 'Export/Import'
]

{ #category : #actions }
PRExportImportWidget >> export: aKernel [
	self exporterImporter export: aKernel on: self requestContext
]

{ #category : #accessing }
PRExportImportWidget >> exporterImporter [
	^ exporterImporter ifNil: [ 
		self exporterImporter: PRReferenceStreamExporterImporter new.
		self exporterImporter ]
]

{ #category : #accessing }
PRExportImportWidget >> exporterImporter: anExporterImporter [
	exporterImporter := anExporterImporter owner: self
]

{ #category : #accessing }
PRExportImportWidget >> exporterImporterClass [
	^ self exporterImporter class
]

{ #category : #accessing }
PRExportImportWidget >> exporterImporterClass: aClass [
	self exporterImporter: aClass new
]

{ #category : #actions }
PRExportImportWidget >> import: aCollection into: aKernel [
	| newKernel |
	newKernel := self exporterImporter import: aCollection into: aKernel.
	self context: (self context structure: newKernel root)
]

{ #category : #initialization }
PRExportImportWidget >> initialize [
	super initialize.
	self replace: false
]

{ #category : #rendering }
PRExportImportWidget >> renderContentOn: html [
	html form 
		multipart; 
		with: [
			self renderSelectOn: html.
			self renderExportOn: html.
			self renderImportOn: html ]
]

{ #category : #rendering }
PRExportImportWidget >> renderExportOn: html [
	html heading level: 2; with: 'Export'.
	html paragraph: 'Exporting a snapshot of the kernel does not include the history or any external files. If you plan to move the site to a new location make sure to copy the complete directory structure below ' , MAFileDatabase baseDirectory fullName printString , ' separately. Depending on the size of your site it might take a while to generate and download the snapshot.'.
	html paragraph: [
		html submitButton
			callback: [ self export: self context kernel ];
			with: 'Export' ]
]

{ #category : #rendering }
PRExportImportWidget >> renderImportOn: html [
	| contents |
	html heading level: 2; with: 'Import'.
	html paragraph: 'Importing a snapshot either replaces the existing kernel or just adds all included pages to the current kernel. In either case, make sure to merge the external files into ' , MAFileDatabase baseDirectory fullName printString , ' and to check security properties.'.
	html paragraph: [
		html radioGroup: [ :group |
			html label: [
				html radioButton
					group: group;
					selected: self replace not;
					callback: [ self replace: false ].
				html text: 'Import Pages' ].
			html break.
			html label: [ 
				html radioButton
					group: group;
					selected: self replace;
					callback: [ self replace: true ].
				html text: 'Replace Kernel' ] ] ].
	html paragraph: [
		html fileUpload
			callback: [ :file | contents := file rawContents ] ].
	html paragraph: [
		html submitButton
			callback: [ self exporterImporter import: contents into: self context kernel ];
			with: 'Import' ]
]

{ #category : #rendering }
PRExportImportWidget >> renderSelectOn: html [
	html paragraph: 'Please select the importer/exporter to use:'.
	html paragraph: [
		html select
			labels: [ :value | value label ];
			selected: self exporterImporterClass;
			list: PRExporterImporter withAllConcreteClasses;
			callback: [ :value | self exporterImporterClass: value ] ]
]

{ #category : #accessing }
PRExportImportWidget >> replace [
	^ replace
]

{ #category : #accessing }
PRExportImportWidget >> replace: aBoolean [
	replace := aBoolean
]
