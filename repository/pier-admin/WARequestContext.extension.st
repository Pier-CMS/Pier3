Extension { #name : #WARequestContext }

{ #category : #'*pier-admin' }
WARequestContext >> headScripts [
	^ self properties at: #headScripts ifAbsent: [ #() ]
]

{ #category : #'*pier-admin' }
WARequestContext >> headScripts: headScripts [
	self properties at: #headScripts put: headScripts
]

{ #category : #'*pier-admin' }
WARequestContext >> headStyles [
	^ self properties at: #headStyles ifAbsent: [ #() ]
]

{ #category : #'*pier-admin' }
WARequestContext >> headStyles: headStyles [
	self properties at: #headStyles put: headStyles
]
