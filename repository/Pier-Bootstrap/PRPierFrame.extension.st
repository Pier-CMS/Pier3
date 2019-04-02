Extension { #name : #PRPierFrame }

{ #category : #'*pier-bootstrap' }
PRPierFrame class >> configureBootstrapApplication: application [
	application configuration
		addParent: PRPierConfiguration instance.
	application
		addLibrary: JQDeploymentLibrary;
		addLibrary: TBSDeploymentLibrary;
		addLibrary: PRJavaScriptSupport
]

{ #category : #'*pier-bootstrap' }
PRPierFrame class >> registerAsBootstrapApplication: aString kernel: aKernel [
	"self registerAsApplication: 'pier' kernel: (PRKernel instanceNamed: 'pier')"

	| app |
	app := WAAdmin register: self asApplicationAt: aString.
	self configureBootstrapApplication: app.
	app preferenceAt: #kernel put: aKernel.
	^ app
]
