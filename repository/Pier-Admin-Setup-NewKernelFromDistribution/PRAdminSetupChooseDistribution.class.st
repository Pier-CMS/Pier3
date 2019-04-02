Class {
	#name : #PRAdminSetupChooseDistribution,
	#superclass : #PRAdminSetupOverlaySupportBase,
	#instVars : [
		'selectedDistribution',
		'distributions',
		'selectDistributionComponent',
		'kernelName',
		'applicationPath'
	],
	#category : #'Pier-Admin-Setup-NewKernelFromDistribution'
}

{ #category : #accessing }
PRAdminSetupChooseDistribution >> applicationPath [
	^ applicationPath ifNil: [ applicationPath :=  self suggestApplicationPathFrom: self kernelName ]
]

{ #category : #accessing }
PRAdminSetupChooseDistribution >> applicationPath: anObject [
	applicationPath := anObject
]

{ #category : #'magritte descriptions' }
PRAdminSetupChooseDistribution >> applicationPathDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #applicationPath;
		label: 'Application path';
		priority: 50;
		beRequired;
		yourself
]

{ #category : #hooks }
PRAdminSetupChooseDistribution >> children [
	^ Array with: self selectDistributionComponent
]

{ #category : #'magritte descriptions' }
PRAdminSetupChooseDistribution >> descriptionContainer [
	<magritteContainer>
	^ super descriptionContainer
		componentRenderer: TWBSMagritteFormRenderer;
		twbsFormInline: true;
		yourself
]

{ #category : #private }
PRAdminSetupChooseDistribution >> distributions [
	^ distributions ifNil: [
		 distributions := (OrderedCollection withAll: PRAbstractKernelDistribution withAllConcreteClasses) sort: [ : a :b  | a name < b name ] ]
]

{ #category : #accessing }
PRAdminSetupChooseDistribution >> kernelName [
	^ kernelName ifNil: [ kernelName :=  self suggestKernelNameFrom: self selectedDistribution ]
]

{ #category : #accessing }
PRAdminSetupChooseDistribution >> kernelName: anObject [
	kernelName := anObject
]

{ #category : #'magritte descriptions' }
PRAdminSetupChooseDistribution >> kernelNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #kernelName;
		label: 'Kernel name';
		priority: 10;
		beRequired;
		yourself
]

{ #category : #accessing }
PRAdminSetupChooseDistribution >> pierKernelNames [
	^ PRAdminKernelPathPair kernelPathPairs collect: [ :each | each kernel name ]
]

{ #category : #rendering }
PRAdminSetupChooseDistribution >> renderAjaxSelectUpdateOn: html [
	"when the selected distribution changes the suggested kernel name and suggested application path are updated dynamically"
	html document addLoadScript: 
		((html jQuery: #selectDistributionFormContainer) on: 'change' selector: 'input[type="hidden"]' do: 
			(html jQuery ajax script: [ :s |
				| memento theSelectedDistribution theKernelName |
				memento := self selectDistributionComponent memento.
				theSelectedDistribution := memento readUsing: self selectedDistributionDescription.
				theKernelName := self suggestKernelNameFrom: theSelectedDistribution.
				memento write: theKernelName using: self kernelNameDescription.
				memento write: (self suggestApplicationPathFrom: theKernelName) using: self applicationPathDescription. 

				 s << (s jQuery: #selectDistributionFormContainer) html: self selectDistributionComponent ]; 
			serializeForm))
]

{ #category : #rendering }
PRAdminSetupChooseDistribution >> renderContentOn: html [
	html div
		id: #setupAdminKernelFromTemplate;
		with: [
			html div
				id: #selectDistributionFormContainer;
				with: self selectDistributionComponent.
				
			self renderAjaxSelectUpdateOn: html.
			
			self distributions isEmpty ifTrue: [
				self renderOverlayWithMessage: 'No templates found' containerId: #setupAdminKernelFromTemplate on: html ] ]
]

{ #category : #'magritte component' }
PRAdminSetupChooseDistribution >> selectDistributionComponent [
	^ selectDistributionComponent ifNil: [ 
		selectDistributionComponent := self asComponent
			addDecoration: 
				((TWBSMagritteFormDecoration buttons: (Array with: #save -> 'Create  kernel from template')) 
					formCss: 'form-inline';
					yourself);
			onAnswer: [ :model | self answer: model ];
			yourself ]
]

{ #category : #accessing }
PRAdminSetupChooseDistribution >> selectedDistribution [
	^ selectedDistribution ifNil: [ self distributions first ]
]

{ #category : #accessing }
PRAdminSetupChooseDistribution >> selectedDistribution: anObject [
	selectedDistribution := anObject
]

{ #category : #'magritte descriptions' }
PRAdminSetupChooseDistribution >> selectedDistributionDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
		options: self distributions;
		accessor: #selectedDistribution;
		label: 'Select template';
		componentClass: PRAdminSetupThumbnailChooser;
		priority: 100;
		cssClass: 'thumbnailChooser';
		beRequired;
		yourself
]

{ #category : #private }
PRAdminSetupChooseDistribution >> suggestApplicationPathFrom:  aKernelName [
	| suggestedPath |

	suggestedPath := aKernelName collect: [ : char | 
		Character space = char 
			ifTrue: [ $- ]
			ifFalse: [ char asLowercase ] ].
		
	^ suggestedPath select: [ :char | 
		PRPath isValidCharacter: char ]
]

{ #category : #private }
PRAdminSetupChooseDistribution >> suggestKernelNameFrom: distribution [
	| pierKernelNames suggestedName |
	
	suggestedName := distribution label.
	pierKernelNames := self pierKernelNames.
	pierKernelNames isEmpty ifTrue: [ ^ suggestedName ].

	[ pierKernelNames includes: suggestedName ] whileTrue: [	
	 suggestedName := suggestedName last isDigit
		ifTrue: [
			| digitSuffix |
			digitSuffix := (suggestedName last digitValue + 1) greaseString.
			suggestedName allButLast,  digitSuffix ]
		ifFalse: [
			suggestedName,  '1' ] ].
		
	^ suggestedName 
]
