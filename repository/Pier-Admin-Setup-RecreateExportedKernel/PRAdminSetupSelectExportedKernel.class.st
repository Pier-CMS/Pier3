Class {
	#name : #PRAdminSetupSelectExportedKernel,
	#superclass : #PRAdminSetupOverlaySupportBase,
	#instVars : [
		'selectedKernel',
		'selectExportedKernelComponent'
	],
	#category : #'Pier-Admin-Setup-RecreateExportedKernel'
}

{ #category : #hooks }
PRAdminSetupSelectExportedKernel >> children [
	^ Array with: self selectExportedKernelComponent 
]

{ #category : #'magritte descriptions' }
PRAdminSetupSelectExportedKernel >> descriptionContainer [
	<magritteContainer>
	^ super descriptionContainer
		componentRenderer: TWBSMagritteFormRenderer;
		yourself
]

{ #category : #accessing }
PRAdminSetupSelectExportedKernel >> exportedKernels [
	^ PRKernelCreatorBase allSubclasses
]

{ #category : #'magritte descriptions' }
PRAdminSetupSelectExportedKernel >> exportedKernelsDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
		componentClass: PRAdminSetupExportedKernelsSelect;
		options: self exportedKernels;
		accessor: #selectedKernel;
		label: 'Exported kernels';
		beRequired;
		yourself
]

{ #category : #rendering }
PRAdminSetupSelectExportedKernel >> renderContentOn: html [
	html div
		id: #setupAdminRecreateExportedKernel;
		with: [
			html render: self selectExportedKernelComponent.
			
			self exportedKernels isEmpty ifTrue: [
				self renderOverlayWithMessage: 'No exported kernels found' containerId: #setupAdminRecreateExportedKernel on: html ] ]
]

{ #category : #'magritte component' }
PRAdminSetupSelectExportedKernel >> selectExportedKernelComponent [
	^ selectExportedKernelComponent ifNil: [ 
		selectExportedKernelComponent := self asComponent
			addDecoration: 
				((TWBSMagritteFormDecoration buttons:  (Array with: #save -> 'Recreate kernel'))
					formCss: 'form-horizontal';
					legend: 'Select an exported kernel';
					yourself);
			onAnswer: [ :model | self answer: model selectedKernel ];
			yourself ]
		
]

{ #category : #accessing }
PRAdminSetupSelectExportedKernel >> selectedKernel [
	^ selectedKernel ifNil: [ 
		self exportedKernels isEmpty 
			ifTrue: [ nil ]
			ifFalse: [ selectedKernel := self exportedKernels first ] ]
]

{ #category : #accessing }
PRAdminSetupSelectExportedKernel >> selectedKernel: anObject [
	selectedKernel := anObject
]
