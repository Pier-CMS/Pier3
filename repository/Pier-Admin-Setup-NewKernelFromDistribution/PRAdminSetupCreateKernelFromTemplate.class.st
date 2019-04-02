"
I create a kernel from a selected template and create an admin user with the specified user name and password.

"
Class {
	#name : #PRAdminSetupCreateKernelFromTemplate,
	#superclass : #PRAdminSetupTaskBase,
	#category : #'Pier-Admin-Setup-NewKernelFromDistribution'
}

{ #category : #'main task' }
PRAdminSetupCreateKernelFromTemplate >> chooseDistribution [
	| choosenDistributionInfo |
		
	[ choosenDistributionInfo isNil or:  [choosenDistributionInfo selectedDistribution  isNil ] ] whileTrue: [
		choosenDistributionInfo := (self call: PRAdminSetupChooseDistribution new).
		(self ifPresentConfirmRemovalOfApplicationAt:  choosenDistributionInfo applicationPath) ifFalse: [ choosenDistributionInfo := nil ] ].
	
	^ choosenDistributionInfo
	

]

{ #category : #tasks }
PRAdminSetupCreateKernelFromTemplate >> createKernelNamed: kernelName adminUserPassword:  adminUserPassword [
	| kernel adminUser |
	kernel := PRKernel named: kernelName.

	adminUser := ((PUUser named: adminUserPassword getName)
		password: adminUserPassword password; 
		addGroup: kernel adminGroup;
		superuser: true;
		yourself).
	
	kernel propertyAt: #users put: (Set with: adminUser).
	kernel propertyAt: #adminUser put: adminUser.
	
	^ kernel
]

{ #category : #tasks }
PRAdminSetupCreateKernelFromTemplate >> createSiteAt: dispatcherName forDistribution: selectedDistribution onKernel: kernel [
	| distribution result |
	distribution := selectedDistribution new.
	result := distribution showCustomizeUIOn: self thenAddRootToKernel: kernel.
	result notNil ifTrue: [
		self registerApplicationAtPath: dispatcherName kernel: kernel ].
	
	^ result notNil
	

]

{ #category : #tasks }
PRAdminSetupCreateKernelFromTemplate >> defineAdminUserForDistribution: selectedDistribution [
	| adminUserComponent |
	adminUserComponent := PRAdminSetupDefineAdminUser new asComponent 
		addDecoration: 
			((TWBSMagritteFormDecoration buttons: (Array with: #save -> 'Register admin user')) 
				formCss: 'form-horizontal';
				legend: 'Create an admin user';
				yourself);
		twbsAddInfoMessage: [ :r | r text: 'You have selected: '; strong: selectedDistribution label ];
		yourself.

	^ self call: adminUserComponent
]

{ #category : #running }
PRAdminSetupCreateKernelFromTemplate >> go [
	| kernelNamedispatcherNamePair |
	
	kernelNamedispatcherNamePair := self selectAndCreateFromTemplateDistribution.
	self queryAdminUICreationFor: kernelNamedispatcherNamePair kernelName at: kernelNamedispatcherNamePair dispatcherName
	

]

{ #category : #accessing }
PRAdminSetupCreateKernelFromTemplate >> numColumns [
	^ 12
]

{ #category : #tasks }
PRAdminSetupCreateKernelFromTemplate >> registerApplicationAtPath: path kernel: kernel [ 
	| app |
	app := PRPierFrame registerAsApplication: path kernel: kernel.
	"have to include this lot if you want users to have a rich editing experience in the comments and 
	be able to upload comment files"
	app
		preferenceAt: #scriptGeneratorClass put: JQScriptGenerator;
		preferenceAt: #rootDecorationClasses put: #();
		addLibrary: JQDeploymentLibrary;
		addLibrary: JQUiDeploymentLibrary;
		addLibrary: JQBaseTheme;
		addLibrary: 	SPHighlightedStyle.

	app
		configuration addParent: NAFileUploadConfigurator instance
]

{ #category : #'main task' }
PRAdminSetupCreateKernelFromTemplate >> selectAndCreateFromTemplateDistribution [
	|  dispatcherNameKernelNamePair  siteCreated firstTimeRound  |
	
	siteCreated := false.
	firstTimeRound := true.
	
	[ siteCreated ] whileFalse: [
		| kernel choosenDistributionInfo adminUserNamePasswordPair |
		
		choosenDistributionInfo :=  self chooseDistribution.
		adminUserNamePasswordPair isNil ifTrue: [
			adminUserNamePasswordPair := (self defineAdminUserForDistribution: choosenDistributionInfo selectedDistribution) ].
		
		kernel := self createKernelNamed: choosenDistributionInfo  kernelName adminUserPassword: adminUserNamePasswordPair.
		firstTimeRound ifTrue: [
			self twbsInformSuccess: 'Created admin user named: ''', adminUserNamePasswordPair getName contents, '''. Continue to create the site.' ].
		siteCreated := self createSiteAt: choosenDistributionInfo applicationPath forDistribution: choosenDistributionInfo selectedDistribution onKernel: kernel.
		
		firstTimeRound := false.
		dispatcherNameKernelNamePair := PRAdminSetupDistributionKernelNameDispatcherName kernelName: choosenDistributionInfo kernelName dispatcherName: choosenDistributionInfo applicationPath ].
	
	^ dispatcherNameKernelNamePair
	

]
