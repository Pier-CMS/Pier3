Extension { #name : #WASession }

{ #category : #'*pier-admin' }
WASession >> pierAdminAnnouncer [
	^ self properties at: #pierAdminAnnouncer ifAbsentPut: [ Announcer new ]
]
