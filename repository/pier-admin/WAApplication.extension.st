Extension { #name : #WAApplication }

{ #category : #'*pier-admin' }
WAApplication >> pierAdminCommands [
	^ (self preferenceAt: #pierAdminCommands) collect: [ :each | 
		each isSymbol 
			ifTrue: [ self class environment at: each ] 
			ifFalse: [ each ] ]

]

{ #category : #'*pier-admin' }
WAApplication >> pierAdminKernelPathPair [
	^ self preferenceAt: #pierAdminKernelPathPair
]

{ #category : #'*pier-admin' }
WAApplication >> pierAdminKernelPathPair: kernelPathPair [
	^ self preferenceAt: #pierAdminKernelPathPair put: kernelPathPair
]

{ #category : #'*pier-admin' }
WAApplication >> pierAdminViews [
	| adminViews |
	adminViews := OrderedCollection withAll: (self preferenceAt: #pierAdminViews).
	adminViews addFirst: #PRDefaultView.
	
	^ adminViews collect: [ :each | 
		each isSymbol 
			ifTrue: [ self class environment at: each ] 
			ifFalse: [ each ] ]

]
