Class {
	#name : #PRAdminSetupRecreateExportedKernel,
	#superclass : #PRAdminSetupTaskBase,
	#category : #'Pier-Admin-Setup-RecreateExportedKernel'
}

{ #category : #tasks }
PRAdminSetupRecreateExportedKernel >> createExportedKernel: kernelCreator [
	kernelCreator register.
	self twbsInformSuccess: [ :html |
		html text: 'Created kernel: '''; strong: kernelCreator kernelName; text: ''', path: '.
		html anchor url: kernelCreator dispatcherPathName; with: kernelCreator dispatcherPathName ]
]

{ #category : #running }
PRAdminSetupRecreateExportedKernel >> go [
	| kernelCreator |
	
	 [ kernelCreator isNil ] whileTrue: [
		kernelCreator := self selectExportedKernelComponent.
		(self ifPresentConfirmRemovalOfApplicationAt: kernelCreator dispatcherPathName) ifFalse: [ kernelCreator := nil ] ].
		
	self createExportedKernel: kernelCreator.
	self queryAdminUICreationFor: kernelCreator kernelName at: kernelCreator dispatcherPathName
]

{ #category : #tasks }
PRAdminSetupRecreateExportedKernel >> selectExportedKernelComponent [
	| selectedExportedKernelClass |
	selectedExportedKernelClass :=  self call: PRAdminSetupSelectExportedKernel new.
	^ selectedExportedKernelClass new
]
