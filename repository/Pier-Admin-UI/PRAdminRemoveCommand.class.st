"
I specialise ==PRRemoveCommand== to add a script to the ajax update which will remove the selected entry node from the navigator tree in the admin UI. 
"
Class {
	#name : #PRAdminRemoveCommand,
	#superclass : #PRRemoveCommand,
	#instVars : [
		'idOfTreeNodeToRemove',
		'pierAdminAnnouncer'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #'instance creation' }
PRAdminRemoveCommand class >> idOfTreeNodeToRemove: idOfTreeNodeToRemove pierAdminAnnouncer: pierAdminAnnouncer [
	^ self new
		idOfTreeNodeToRemove: idOfTreeNodeToRemove;
		pierAdminAnnouncer: pierAdminAnnouncer;
		yourself
]

{ #category : #events }
PRAdminRemoveCommand >> doValidate [
	super doValidate.
	
	"user has confirmed remove so add to ajax update a script to delete the removed node 
	within the client-side tree"
	self pierAdminAnnouncer on: PRAdminAjaxUpdate do: [ :ajaxUpdate |
		| s |
		s := ajaxUpdate script.
		s << (s jQuery: #navigator) tree remove: (s jQuery id: (self idOfTreeNodeToRemove)).
		self pierAdminAnnouncer unsubscribe: self ]
]

{ #category : #accessing }
PRAdminRemoveCommand >> idOfTreeNodeToRemove [
	^ idOfTreeNodeToRemove
]

{ #category : #accessing }
PRAdminRemoveCommand >> idOfTreeNodeToRemove: anObject [
	idOfTreeNodeToRemove := anObject
]

{ #category : #accessing }
PRAdminRemoveCommand >> pierAdminAnnouncer [
	^ pierAdminAnnouncer
]

{ #category : #accessing }
PRAdminRemoveCommand >> pierAdminAnnouncer: anObject [
	pierAdminAnnouncer := anObject
]
