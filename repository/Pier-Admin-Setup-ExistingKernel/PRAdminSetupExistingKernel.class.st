Class {
	#name : #PRAdminSetupExistingKernel,
	#superclass : #WATask,
	#category : #'Pier-Admin-Setup-ExistingKernel'
}

{ #category : #tasks }
PRAdminSetupExistingKernel >> adminInstanceAlreadyAssociatedWithKernel: kernelPathPair [
	PRAdminSetup recursiveDispatcherHandersDo: [ :handler :handlerPath |
		[ (handler isApplication and: [ kernelPathPair = handler pierAdminKernelPathPair ]) ifTrue: [ ^ handlerPath ]
		 ] 
		"no
		      WARequestHandler>>#preferenceAt:ifAbsent: 
	 	so have to handle the exception"
		on: WAAttributeNotFound do: [ :err | "do nothing" ] ].	
	
	^ nil
]

{ #category : #tasks }
PRAdminSetupExistingKernel >> chooseExistingKernel [
	^ self call: PRAdminSetupChooseExistingKernel new

]

{ #category : #tasks }
PRAdminSetupExistingKernel >> confirmAdminInstance: adminInstancePath alreadyAssociatedWith: selectedKernelPathPair [
	^ self twbsConfirmError:  [ : r | 
		r 
			text: 'The kernel you selected: '; break; break;
			strong: selectedKernelPathPair; break; break;
			text: 'is already associated with admin instance at:'; break; break.
		r anchor url: adminInstancePath; with: adminInstancePath.
		r break; break; text: 'Do you want to continue by logging into: '.
		r anchor url: adminInstancePath; with: adminInstancePath ]
]

{ #category : #running }
PRAdminSetupExistingKernel >> createAdminInstance: selectedKernelPathPair [
	^ PRAdminLogin registerForAdministering: selectedKernelPathPair
]

{ #category : #running }
PRAdminSetupExistingKernel >> go [
	| selectedKernelPathPair adminInstancePath |
	
	 [ adminInstancePath isNil ] whileTrue: [
		selectedKernelPathPair := self chooseExistingKernel.
		adminInstancePath :=  self adminInstanceAlreadyAssociatedWithKernel: selectedKernelPathPair.
		
		adminInstancePath isNil
			ifTrue: [
				adminInstancePath := self createAdminInstance: selectedKernelPathPair.
				self informInstanceCreatedForPath: adminInstancePath kernel: selectedKernelPathPair ] 
		
			ifFalse: [ 
				(self confirmAdminInstance: adminInstancePath alreadyAssociatedWith: selectedKernelPathPair) 
					ifFalse: [ adminInstancePath := nil ] ] ].
			
	self redirectTo: adminInstancePath

]

{ #category : #tasks }
PRAdminSetupExistingKernel >> informInstanceCreatedForPath: adminInstancePath kernel: selectedKernelPathPair [
	self twbsInformSuccess: [ :html | 
		html text: 'Admin instance created at: '; break; break.
		html anchor url: adminInstancePath; with: adminInstancePath.
		html break; break; text: 'for: '; break; break.
		html strong: selectedKernelPathPair; break; break.
		html text: 'Continue to redirect to admin instance.' ]
]

{ #category : #accessing }
PRAdminSetupExistingKernel >> numColumns [
	^ 7
]

{ #category : #tasks }
PRAdminSetupExistingKernel >> redirectTo: path [
	self requestContext redirectTo: path
]
