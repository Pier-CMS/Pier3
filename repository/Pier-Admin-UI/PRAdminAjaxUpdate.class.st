"
I am an ==Announcement== and hold a script which components write to to update themselves.
"
Class {
	#name : #PRAdminAjaxUpdate,
	#superclass : #Announcement,
	#instVars : [
		'script'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #'instance creation' }
PRAdminAjaxUpdate class >> script: script [
	^ self new
		script: script;
		yourself
]

{ #category : #accessing }
PRAdminAjaxUpdate >> script [
	^ script
]

{ #category : #accessing }
PRAdminAjaxUpdate >> script: anObject [
	script := anObject
]
