Class {
	#name : #PRAbstractKernelSystemManagementDistribution,
	#superclass : #PRAbstractKernelDistribution,
	#instVars : [
		'systemPage',
		'componentsPage',
		'systemManagementPage',
		'templatesPage',
		'contentsWidget',
		'metaEnvironmentPage',
		'breadcrumbWidget',
		'kernel',
		'googleAnalyticsWidget',
		'searchWidget',
		'footerPage',
		'poweredByPage',
		'rootStylesheetFile'
	],
	#category : #'Pier-Kernel-Distributions'
}

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> breadcrumbWidget [
	^ breadcrumbWidget ifNil: [ 
		breadcrumbWidget := (PRComponent named: 'breadcrumb')
			prototypeInstance: PRBreadcrumbWidget new;
			yourself ]
]

{ #category : #support }
PRAbstractKernelSystemManagementDistribution >> clearInternalLinkTargetsStartingAt: startingStructure [
	"PRDocumentItem content is created before all the parents and children have
	been wired together, resulting in incorrectly realised internal links. Here we clear
	the links target which will be reinitialised when the link is first visited."
	startingStructure enumerator with; all; do: [ :each |
		each outgoingReferences do: [ :link |
			(link isKindOf: PRInternalLink) ifTrue: [ link target: nil ] ] ]
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> components [
	self subclassResponsibility
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> componentsPage [
	^ componentsPage ifNil: [
		componentsPage := (PRPage named: 'components')
		contents: '*value:children|link*';
		yourself ]
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> contentsWidget [
	^ contentsWidget ifNil: [
		contentsWidget := (PRComponent named: 'contents')
			prototypeInstance: (PRContentsWidget new
				heading: '';
				yourself);
			yourself ]
]

{ #category : #creation }
PRAbstractKernelSystemManagementDistribution >> createRootOn: theKernel [
	self kernel: theKernel.
	
	self rootPage
		addChild: (self systemPage
			addChild: self contentsWidget;
			addChild: (self componentsPage
				addChild: self breadcrumbWidget;
				addChild: self rootStylesheetFile;
				yourself );
			addChild: self systemManagementPage;
			addChild: (self templatesPage
				addChild: self rootTemplate;
				addChild: self metaEnvironmentPage;
				addChild: self emptyEnvironment;
				yourself );
			yourself).
	
	self components do: [ :each | 
		self componentsPage addChild: each ].
	
	self templates do: [ :each | 
		self templatesPage addChild: each ].
	self templatesPage addChild: self rootEditingTemplate.
	
	self rootPage localEnvironment: self rootTemplate.
	self rootPage localStyleSheet: self rootStylesheetFile.
	self rootPage localEditingEnvironment: self rootEditingTemplate.
	
	self setAdminUserGroupStartingAtStructure: self rootPage. 

	self makePrivateWithAllChildren: self systemManagementPage.
	self makePrivateWithAllChildren: self templatesPage.
	self makePrivate: self systemPage.
	self makePrivate: self componentsPage.
	
	theKernel root: self rootPage.
	^ theKernel
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> emptyEnvironment [
	^ PRStructure emptyEnvironment
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> footerPage [
	^ footerPage ifNil: [
		footerPage := (PRPage named: 'footer')
		contents:
'{{{<div class="footer column span-24 last">
	<div class="column span-18"></div>
	<div class="column span-6 last">}}}+/system/components/poweredby+{{{</div>
</div>}}}';
		yourself ]
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> googleAnalyticsWidget [
	^ googleAnalyticsWidget ifNil: [ 
		googleAnalyticsWidget := (PRComponent named: 'googleanalytics')
			title: 'Google Analytics';
			prototypeInstance: PRGoogleAnalyticsWidget new;
			yourself ]
]

{ #category : #'sample content' }
PRAbstractKernelSystemManagementDistribution >> installationInstructions [
	^ 'Install Pier Admin with:

=Gofer it
=	squeaksource: ''MetacelloRepository'';
=  	package: ''ConfigurationOfPier3AddOns'';
=  	load.
=
=ConfigurationOfPier3AddOns load.

'
]

{ #category : #accessing }
PRAbstractKernelSystemManagementDistribution >> kernel [
	^ kernel
]

{ #category : #accessing }
PRAbstractKernelSystemManagementDistribution >> kernel: anObject [
	kernel := anObject
]

{ #category : #rights }
PRAbstractKernelSystemManagementDistribution >> makePrivate: structure [
	structure securityDecoration otherPermissions: #()
]

{ #category : #rights }
PRAbstractKernelSystemManagementDistribution >> makePrivateWithAllChildren: structure [
	structure enumerator
		with;
		all;
		do: [ :each |
			self makePrivate: each ]
]

{ #category : #templates }
PRAbstractKernelSystemManagementDistribution >> metaEnvironmentPage [
	^ metaEnvironmentPage ifNil: [
		metaEnvironmentPage := (PRPage named: 'metaenvironment')
		title: '_Meta Environment';
"		hideFromMenus: true;"
		contents: 
'{{{<div class="container metaenvironment">
	<div class="span-24 last metaheader">
		Meta page: }}}+/system/components/breadcrumb+{{{
	</div>
	<div class="span-24 last">
		}}}+/system/contents+{{{
	</div>
</div>}}}';
		yourself ]
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> poweredPage [
	^ poweredByPage ifNil: [
		poweredByPage := (PRPage named: 'poweredby')
			title: 'Powered By';
			contents:  'Powered by *Pier>http://www.piercms.com*';
			yourself ]
]

{ #category : #support }
PRAbstractKernelSystemManagementDistribution >> removeNode: nodeStructure [
	self rootPage incomingReferences
		toAll: (nodeStructure enumerator
			everything contents);
		do: [ :each | each target: nil ].
	nodeStructure remove. 
]

{ #category : #templates }
PRAbstractKernelSystemManagementDistribution >> rootEditingTemplate [
	^ self emptyEnvironment
		name: 'rootEditingTemplate';
		yourself
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> rootPage [
	self subclassResponsibility
]

{ #category : #stylesheets }
PRAbstractKernelSystemManagementDistribution >> rootStyleSheetContents [
	self subclassResponsibility
]

{ #category : #stylesheets }
PRAbstractKernelSystemManagementDistribution >> rootStylesheetFile [
	| styleSheetName |
	"name each sheet after the distribution so that we don't have caching issues"
	styleSheetName := self class name greaseString, '.css'.

	^ rootStylesheetFile ifNil: [ 
		"use an MAMemoryFileModel so that the image can be moved without worrying
		about stylesheet files in the filesystem"
		rootStylesheetFile := (PRFile named: styleSheetName)
			file: MAMemoryFileModel new;
			filename: styleSheetName;
			mimetype: 'text/css';
			contents: self rootStyleSheetContents;
			yourself ]
]

{ #category : #templates }
PRAbstractKernelSystemManagementDistribution >> rootTemplate [
	^ self subclassResponsibility
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> searchWidget [
	^ searchWidget ifNil: [
		searchWidget := (PRComponent named: 'search')
			prototypeInstance: (PRAjaxSearchWidget new
				filter: (PRStructure withAllConcreteClasses reject: [ :each | each = PRPage or: [ each = PBPost ] ]);
				yourself);
			yourself ]
]

{ #category : #rights }
PRAbstractKernelSystemManagementDistribution >> setAdminUserGroupStartingAtStructure: startingStructure [
	startingStructure enumerator
		with;
		all;
		do: [ :each |
			each securityDecoration owner: self kernel adminUser.
			each securityDecoration group: self kernel adminGroup ]
]

{ #category : #creation }
PRAbstractKernelSystemManagementDistribution >> showCustomizeUIOn: calleeComponent thenAddRootToKernel: theKernel [
	| theMagritteCustomizeUIDescription |
	theMagritteCustomizeUIDescription := self magritteDescription.
	theMagritteCustomizeUIDescription isEmpty  
		ifFalse: [
			calleeComponent call: ((theMagritteCustomizeUIDescription asComponentOn: self)
				addDecoration: 
					((TWBSMagritteFormDecoration buttons: (Array with: #save -> 'Create kernel'))
						formCss: 'form-horizontal';
						legend: 'Customize ', self class label;
						yourself);
				yourself) ].
	
	^ self createRootOn: theKernel
			
	 
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> systemManagementPage [
	^ systemManagementPage ifNil: [
		systemManagementPage := 
			(PRPage named: 'management')
				title: 'Management';
				addChild: ((PRComponent named: 'users')
					prototypeInstance: PUUsersWidget new;
					yourself);
				addChild: ((PRComponent named: 'groups')
					prototypeInstance: PUGroupsWidget new;
					yourself);
				addChild: ((PRComponent named: 'persistency')
					prototypeInstance: PRPersistencySettings new;
					yourself);
				addChild: ((PRComponent named: 'kernel')
					prototypeInstance: PRKernelSettings new;
					yourself);
				addChild: ((PRComponent named: 'file')
					prototypeInstance: PRFileSettings new;
					yourself);
				addChild: ((PRComponent named: 'linkchecker')
					title: 'Link Checker';
					prototypeInstance: PULinksWidget new;
					yourself);
				contents: '!Users
+users+

!User Group
+groups+

!Persistency
+persistency+

!Kernel Settings
+kernel+

!File Settings
+file+

!Link Checker
+linkchecker+';
				yourself ]
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> systemPage [
	^ systemPage ifNil: [
		systemPage := (PRPage named: 'system')
			localEnvironment: ((PRComponent named: 'contents') "minimal environment"
				prototypeInstance: (PRContentsWidget new
				heading: '';
				yourself));
			contents: '*value:children|link*';
			yourself ]
]

{ #category : #templates }
PRAbstractKernelSystemManagementDistribution >> templates [
	self subclassResponsibility
]

{ #category : #components }
PRAbstractKernelSystemManagementDistribution >> templatesPage [
	^ templatesPage ifNil: [
		templatesPage := (PRPage named: 'templates')
			contents: '*value:children|link*';
			yourself ]
]
