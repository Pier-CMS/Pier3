Extension { #name : #PRKernel }

{ #category : #'*pier-exporter-code' }
PRKernel >> groups: aGroupSet andUsers: aUserSet [
	self propertyAt: #groups put: aGroupSet.
	self propertyAt: #users put: aUserSet
]
