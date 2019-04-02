"
I provide access to global commands which are not accessible via right-click on the navigator. The commands available can be edited in ==/config/pieradmin==, by default the global commands are defined by:
+value:source|class=PRAdminConfigurator|selector=filteredCommandClasses+


"
Class {
	#name : #PRAdminCommands,
	#superclass : #PRAdminUIChild,
	#category : #'Pier-Admin-UI'
}

{ #category : #announcing }
PRAdminCommands >> announcementRegister [
	"empty as I dont dynamically update myself"
]

{ #category : #rendering }
PRAdminCommands >> renderContentOn: html [
	html div
		id: #commands;
		with: [ 
			html form: [
				| selectId |
				html label
         				for: (selectId := html nextId);
         				with: [
						html div: 'Global commands: ' ].
			
				html select
					id: selectId;
					list: self application pierAdminCommands;
					labels: [ :class | class label ];
					selected: PRSettingsCommand;
					callback: [ :class | 
						self context: (self context command: class new) ].
					
				html button
					bePush
					onClick: (html jQuery ajax serialize: (html jQuery id: selectId); script: [ :s | self announceAjaxUpdate: s ]);
					with: 'Do' ] ] 
]
