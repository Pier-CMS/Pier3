"
I render the view tabs along the top of the Admin UI. The views I display are defined in the ==/config/pieradmin==, in the """"Tabbed Views"""" entry under the """"Pier Admin"""" section. By default the following views are defined:
+value:source|class=PRAdminConfigurator|selector=defaultViews+
"
Class {
	#name : #PRAdminTabs,
	#superclass : #PRAdminUIChild,
	#instVars : [
		'lastViewClass'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #announcing }
PRAdminTabs >> announcementRegister [
	self session pierAdminAnnouncer on: PRAdminAjaxUpdate do: [ :ajaxUpdate |
		self selectedContextViewClass ~= lastViewClass ifTrue: [
			| s |
			lastViewClass := self selectedContextViewClass.
			s := ajaxUpdate script.
			s << (s jQuery: #tabs) replaceWith: [ :r | r render: self ] ] ]
]

{ #category : #rendering }
PRAdminTabs >> renderContentOn: html [
	html div
		id: #tabs;
		with: [
			html unorderedList
				class: 'tabs';
				with: [
					self application pierAdminViews do: [ :eachView |
						self renderTabForView: eachView on: html ] ] ]
]

{ #category : #rendering }
PRAdminTabs >> renderTabForView: aViewClass on: html [
	html listItem
		class: 'tab';
		class: 'active' if: self selectedContextViewClass = aViewClass;
		with: [
			html anchor
				onClick: (html jQuery ajax script: [ :s | 
					self context: (self context view: aViewClass).
					self announceAjaxUpdate: s ]);
				with: [
					html span
						class: 'left';
						with: aViewClass label.
					html span class: 'right' ] ]
]

{ #category : #accessing }
PRAdminTabs >> selectedContextViewClass [
	^ self context command isView
		ifTrue: [ self context command viewComponent class ]
]
