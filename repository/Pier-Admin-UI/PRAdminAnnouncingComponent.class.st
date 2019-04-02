"
I am the base for all admin ui components and provide common announcement support.
"
Class {
	#name : #PRAdminAnnouncingComponent,
	#superclass : #WAComponent,
	#category : #'Pier-Admin-UI'
}

{ #category : #announcing }
PRAdminAnnouncingComponent >> announceAjaxUpdate: script [
	self session pierAdminAnnouncer announce: (PRAdminAjaxUpdate script: script)

]

{ #category : #announcing }
PRAdminAnnouncingComponent >> announceAjaxUpdateWithoutSelfOn: script [
	self announcementUnregister.
	self announceAjaxUpdate: script.
	self announcementRegister
]

{ #category : #announcing }
PRAdminAnnouncingComponent >> announcementRegister [
	self subclassResponsibility
]

{ #category : #announcing }
PRAdminAnnouncingComponent >> announcementUnregister [
	self session pierAdminAnnouncer unsubscribe: self
]

{ #category : #initialization }
PRAdminAnnouncingComponent >> initialize [
	super initialize.
	self announcementRegister
]
