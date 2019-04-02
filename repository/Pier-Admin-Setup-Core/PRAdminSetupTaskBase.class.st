Class {
	#name : #PRAdminSetupTaskBase,
	#superclass : #WATask,
	#category : #'Pier-Admin-Setup-Core'
}

{ #category : #constants }
PRAdminSetupTaskBase class >> containerId [
	^ #setupAdminKernelFromTemplate
]

{ #category : #'admin ui tasks' }
PRAdminSetupTaskBase >> confirmApplicationReplacementAt: dispatcherPathName [
	^ self twbsConfirmError: [ :r | 
		r text: 'An application is already registered at: '. r anchor url: '/', dispatcherPathName; with:  '''/', dispatcherPathName, '''.'. r break.
		r text: 'If you continue this application will be replaced with the selected Pier instance. Continue?' ]

]

{ #category : #'admin ui tasks' }
PRAdminSetupTaskBase >> confirmCreateAdminInstanceFor: kernelName at: dispatcherName [
	| adminInstanceDispatcherName answer |
	adminInstanceDispatcherName := dispatcherName, '-admin'.
	
	answer := self twbsConfirmInfo: [ :html | 
		html text: 'Create a Pier Admin instance to manage the created kernel: ''', kernelName, ''', path: '. html anchor url: '/', dispatcherName; with: '/', dispatcherName. 
		html text: '?'; break.
		html text: 'The admin instance will be created at: '; break; break;
			code: [ html text: '/'; text: adminInstanceDispatcherName ]; break; break;
			text: 'Create Pier Admin instance?' ].
		
	^ answer
		ifTrue: [ adminInstanceDispatcherName ] 
		ifFalse: [ nil ]
]

{ #category : #'admin ui tasks' }
PRAdminSetupTaskBase >> createAdminInstanceFor: kernelName dispatcher: dispatcherName at: adminInstancePath [
	| kernelPathPair kernel |
	
	kernel := PRKernel instanceNamed: kernelName.
	kernelPathPair := PRAdminKernelPathPair kernel: kernel path: dispatcherName.
	
	PRAdminLogin registerAt: adminInstancePath administering: kernelPathPair
]

{ #category : #'admin ui tasks' }
PRAdminSetupTaskBase >> ifPresentConfirmRemovalOfApplicationAt: dispatcherPathName [
	| okToContinue |
	okToContinue := true.
	
	(self isApplicationAlreadyRegisteredAt: dispatcherPathName) ifTrue: [
		(self confirmApplicationReplacementAt: dispatcherPathName) 
			ifTrue: [ self removeApplicationRegisteredAt: dispatcherPathName]
			ifFalse: [ okToContinue := false ] ].
		
	^ okToContinue

]

{ #category : #'admin ui tasks' }
PRAdminSetupTaskBase >> informAdminInstanceCreatedAt: adminInstancePath [
	self twbsInformSuccess: [ :html | 
		html text: 'A Pier Admin instance has been created at: ' ; break; break.
		html anchor	url: '/', adminInstancePath; with: '/', adminInstancePath. 
		html break; break; text: 'Continue to login.' ]
]

{ #category : #'admin ui tasks' }
PRAdminSetupTaskBase >> informRedirectTo: path [
	self twbsInform: [ :html | 
		html text: 'Continue to redirect to: ' ; break; break.
		html anchor url: '/', path; with: '/', path ]
]

{ #category : #'admin ui tasks' }
PRAdminSetupTaskBase >> isApplicationAlreadyRegisteredAt: dispatcherPathName [
	| alreadyDefinedDispatcher |
	
	alreadyDefinedDispatcher := (WADispatcher default handlerAt: dispatcherPathName ifAbsent: [ nil ]).
	^ alreadyDefinedDispatcher notNil
]

{ #category : #accessing }
PRAdminSetupTaskBase >> numColumns [
	^ 7
]

{ #category : #'admin ui task main' }
PRAdminSetupTaskBase >> queryAdminUICreationFor: kernelName at: dispatcherName [
	| adminInstancePath |
	(adminInstancePath := self confirmCreateAdminInstanceFor: kernelName at: dispatcherName) notNil 
		ifTrue: [
			self createAdminInstanceFor: kernelName dispatcher: dispatcherName at: adminInstancePath.
			self informAdminInstanceCreatedAt: adminInstancePath.
			self redirectTo: adminInstancePath ]
		ifFalse: [
			self informRedirectTo: dispatcherName.
			self redirectTo: dispatcherName ]
]

{ #category : #'admin ui tasks' }
PRAdminSetupTaskBase >> redirectTo: path [
	self requestContext redirectTo: path
]

{ #category : #'admin ui tasks' }
PRAdminSetupTaskBase >> removeApplicationRegisteredAt: dispatcherPathName [
	| alreadyDefinedDispatcher existingKernel |
	
	alreadyDefinedDispatcher := WADispatcher default handlerAt: dispatcherPathName.
		
	[ existingKernel := alreadyDefinedDispatcher preferenceAt: #kernel ] on: WAAttributeNotFound do: [ :err | "do nothing" ].
	existingKernel notNil ifTrue: [
		PRKernel instances remove: existingKernel ifAbsent: [ nil ] ].
	
	WAAdmin unregister: dispatcherPathName.
	
	"also try to remove any associated admin instance"
	WAAdmin unregister: dispatcherPathName, '-admin'
]
