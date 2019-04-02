Class {
	#name : #PRAdminListConfiguredInstances,
	#superclass : #PRAdminSetupOverlaySupportBase,
	#instVars : [
		'configuredInstancesKernelPathsPairs'
	],
	#category : #'Pier-Admin-Setup-ConfiguredInstances'
}

{ #category : #accessing }
PRAdminListConfiguredInstances >> configuredInstancesKernelPathsPairs [
	^ configuredInstancesKernelPathsPairs ifNil: [ 
		configuredInstancesKernelPathsPairs := PRAdminKernelPathPair kernelPathPairs select: [ :each |
			| possibleAdminPath |
			possibleAdminPath := each path, '-admin'.
			(WADispatcher default handlerAt: possibleAdminPath ifAbsent: [ nil ]) notNil ] ]
]

{ #category : #accessing }
PRAdminListConfiguredInstances >> numColumns [
	^ 12
]

{ #category : #rendering }
PRAdminListConfiguredInstances >> renderConfiguredInstancesTableOn: html [
	html table
		class: 'table table-striped table-bordered';
		with: [
			html tableHead: [
				html tableRow: [
					html tableHeading: 'Kernel name'.
					html tableHeading: 'instance url'.
					html tableHeading: 'admin url' ] ].
			html tableBody: [
				self configuredInstancesKernelPathsPairs do: [ :each | 
					html tableRow: [
						html tableData: each kernel name.
						html tableData: [ html anchor url: each path; with: each path ].
						html tableData: [ html anchor url: each path, '-admin'; with: each path, '-admin' ] ] ] ] ]

]

{ #category : #rendering }
PRAdminListConfiguredInstances >> renderContentOn: html [
	html div
		id: #setupAdminListConfiguredInstances; 
		with: [
			html div
				class: 'alert';
				with: 'Already configured instances:'.
			
			self renderConfiguredInstancesTableOn: html.

			self configuredInstancesKernelPathsPairs isEmpty ifTrue: [
				self renderOverlayWithMessage: 'No kernels found with admin instances' containerId: #setupAdminListConfiguredInstances on: html ] ]
]
