Class {
	#name : #PRAdminSetupChooseExistingKernel,
	#superclass : #PRAdminSetupOverlaySupportBase,
	#instVars : [
		'selectKernelComponent',
		'selectedKernelPathPair',
		'kernelPathsPairs'
	],
	#category : #'Pier-Admin-Setup-ExistingKernel'
}

{ #category : #hooks }
PRAdminSetupChooseExistingKernel >> children [
	^ Array with: self selectKernelComponent
]

{ #category : #'magritte descriptions' }
PRAdminSetupChooseExistingKernel >> descriptionContainer [
	<magritteContainer>
	^ super descriptionContainer
		componentRenderer: TWBSMagritteFormRenderer;
		yourself
]

{ #category : #accessing }
PRAdminSetupChooseExistingKernel >> kernelPathsPairs [
	^ kernelPathsPairs ifNil: [ 
		kernelPathsPairs := PRAdminKernelPathPair kernelPathPairs select: [ :each |
			| possibleAdminPath |
			possibleAdminPath := each path, '-admin'.
			(WADispatcher default handlerAt: possibleAdminPath ifAbsent: [ nil ]) isNil ] ]
		
]

{ #category : #rendering }
PRAdminSetupChooseExistingKernel >> renderContentOn: html [
	html div
		id: #setupAdminExistingKernel; 
		with: [
			html render: self selectKernelComponent.

			self kernelPathsPairs isEmpty ifTrue: [
				self renderOverlayWithMessage: 'No unmanaged kernels found' containerId: #setupAdminExistingKernel on: html ] ]
]

{ #category : #'magritte component' }
PRAdminSetupChooseExistingKernel >> selectKernelComponent [
	^ selectKernelComponent ifNil: [ 
		selectKernelComponent := self asComponent
			addDecoration: (TWBSMagritteFormDecoration buttons:  (Array with: #save -> 'Select Existing Kernel'));
			onAnswer: [ :model | self answer: self selectedKernelPathPair ];
			yourself ]
		
]

{ #category : #accessing }
PRAdminSetupChooseExistingKernel >> selectedKernelPathPair [
	^ selectedKernelPathPair
		ifNil: [ 
			self kernelPathsPairs isEmpty
				ifFalse: [ selectedKernelPathPair := self kernelPathsPairs first ] ]
]

{ #category : #accessing }
PRAdminSetupChooseExistingKernel >> selectedKernelPathPair: anObject [
	^ selectedKernelPathPair := anObject
]

{ #category : #'magritte descriptions' }
PRAdminSetupChooseExistingKernel >> selectedKernelPathPairDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
		options: self kernelPathsPairs;
		accessor: #selectedKernelPathPair;
		label: 'Select kernel';
		componentClass: MASelectListRowsComponent;
		beRequired;
		yourself
]
