"
I provide a ==/config== configurator UI for Pier Admin. 
"
Class {
	#name : #PRAdminConfigurator,
	#superclass : #WASystemConfiguration,
	#category : #'Pier-Admin-Setup-Core'
}

{ #category : #private }
PRAdminConfigurator >> commandClasses [
	^ PRCommand withAllConcreteClasses collect: [ :each | each name ]
]

{ #category : #defaults }
PRAdminConfigurator >> defaultViews [
	^ #(PRChangesView PRDiffView PUBrowseComponent PRHaloView PRSearchView)
]

{ #category : #description }
PRAdminConfigurator >> describeAdminKernelPathPairOn: configuration [
	(configuration list: #pierAdminKernelPathPair)
		comment: 'Which kernel to administer';
		options: [ PRAdminKernelPathPair kernelPathPairs ];
		default: nil
]

{ #category : #description }
PRAdminConfigurator >> describeGlobalCommandsOn: configuration [
	(configuration collection: #pierAdminCommands)
		group: #pierAdmin;
		label: 'Global commands';
		comment: 'Pier commands to display in the administration interface';
		options: [ self commandClasses ];
		default: self filteredCommandClasses.
]

{ #category : #description }
PRAdminConfigurator >> describeOn: configuration [
	self describeViewsOn: configuration.
	self describeGlobalCommandsOn: configuration.
	self describeAdminKernelPathPairOn: configuration

]

{ #category : #description }
PRAdminConfigurator >> describeViewsOn: configuration [
	(configuration collection: #pierAdminViews)
		group: #pierAdmin;
		label: 'Tabbed Views';
		comment: 'Pier views to display in the administration interface - preview is always available';
		options: [ PRViewComponent withAllConcreteClasses ];
		default: self defaultViews.

]

{ #category : #private }
PRAdminConfigurator >> excludedCommandClasses [
	^ #(PRWikiTextEditingCommand PRAddCommand PREditCommand PRCopyCommand PROrderCommand PRRemoveCommand PRAdminRemoveCommand PRMoveCommand PRViewCommand PULogin PULogout PRSettingsCommand PUChangeOwner PUChangeGroup PUChangeOther)
]

{ #category : #private }
PRAdminConfigurator >> filteredCommandClasses [
	^ (self commandClasses) copyWithoutAll: (self excludedCommandClasses)
]
