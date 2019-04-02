"
I am the root class of Pier Admin Setup. I help generate Pier and Pier admin instances, giving the user the choice to:
# Generate a Pier Admin instance from a existing Pier instance
# Generate a Pier instance (and optional Pier Admin instance) from a Pier kernel template.
# Generate a Pier instance (and optional Pier Admin instance) from a Pier kernel exported using ==Pier-Exporter-Code==.!
"
Class {
	#name : #PRAdminSetup,
	#superclass : #WAComponent,
	#instVars : [
		'tabWidget'
	],
	#category : #'Pier-Admin-Setup-Core'
}

{ #category : #initialization }
PRAdminSetup class >> initialize [
	| piersetup |
	[ piersetup := (WAAdmin register: self asApplicationAt: 'piersetup')
		preferenceAt: #useCookies put: false;
		preferenceAt: #scriptGeneratorClass put: JQScriptGenerator;
		preferenceAt: #rootDecorationClasses put: #();
		yourself.
	piersetup addLibrary: JQDeploymentLibrary ]
		on: WAAttributeNotFound
		do: [  ]
]

{ #category : #private }
PRAdminSetup class >> recursiveDispatcherHandersDo: aBlock [
	self recursiveHandersOn: WADispatcher default path: '' do: aBlock 
]

{ #category : #private }
PRAdminSetup class >> recursiveHandersOn: aDispatcher path: path do: aBlock [
	aDispatcher handlers associationsDo: [ :each | 
		| handlerPath |
		handlerPath := path, '/', each key.
		aBlock value: each value value: handlerPath.
		
		each value isDispatcher ifTrue: [ 
			self recursiveHandersOn: each value path: handlerPath do: aBlock ] ]
]

{ #category : #hooks }
PRAdminSetup >> children [
	^ Array with: self tabWidget
]

{ #category : #rendering }
PRAdminSetup >> renderContentOn: html [
	html twbsContainer: [
		self renderTitleOn: html.
		self renderTitleStrapLineOn: html.
		self renderTabsOn: html ]
]

{ #category : #rendering }
PRAdminSetup >> renderTabsOn: html [
	html render: self tabWidget
]

{ #category : #rendering }
PRAdminSetup >> renderTitleOn: html [
	html twbsRow: [
		html twbsSpan: 12 with: [
			html heading
				level1;
				class: 'setupAdminPierTitle';
				with: [
					html text: 'Welcome to '.
					html image url:  PRAdminFileLibrary / #pierlogo75x35Png.
					html text: ' admin setup' ] ] ]
]

{ #category : #rendering }
PRAdminSetup >> renderTitleStrapLineOn: html [
	html twbsRow: [
		html twbsSpan: 12 with: [
			html heading level1; with: [
				html small: 'Pier admin setup creates sites and admin instances' ].
			html paragraph: ' Choose from:' ] ]
]

{ #category : #accessing }
PRAdminSetup >> tabWidget [
	^ tabWidget
		ifNil: [ tabWidget := TWBSTabWidget new.
			tabWidget
				addTabWithTitle: 'Configured instances'
					component: PRAdminListConfiguredInstances new
					columnSpan: 12;
				addTabWithTitle: 'New from template'
					component: PRAdminSetupCreateKernelFromTemplate new
					columnSpan: 12;
				addTabWithTitle: 'Recreate an exported kernel'
					component: PRAdminSetupRecreateExportedKernel new
					columnSpan: 7;
				addTabWithTitle: 'Administer an existing kernel'
					component: PRAdminSetupExistingKernel new
					columnSpan: 7;
				addTabWithTitle: 'About'
					component: PRAdminSetupAbout new
					columnSpan: 7.
			tabWidget ]
]

{ #category : #updating }
PRAdminSetup >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	anHtmlRoot title: 'Pier Admin Setup'.
	PRAdminSetupFileLibrary default updateRoot: anHtmlRoot.
	TWBSDevelopmentLibrary default updateRoot: anHtmlRoot.

]
