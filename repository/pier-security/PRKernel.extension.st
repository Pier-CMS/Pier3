Extension { #name : #PRKernel }

{ #category : #'*pier-security-defaults' }
PRKernel >> adminGroup [
	^ self propertyAt: #adminGroup ifAbsentPut: [ PUGroup named: 'admin' ]
]

{ #category : #'*pier-security-defaults' }
PRKernel >> adminUser [
	^ self propertyAt: #adminUser ifAbsentPut: [
		(PUUser named: 'admin')
			addGroup: self adminGroup;
			password: 'pier';
			superuser: true;
			yourself ]
]

{ #category : #'*pier-security-accessing' }
PRKernel >> groupNamed: aString ifNone: aBlock [
	^ self groups 
		detect: [ :each | each name = aString ]
		ifNone: aBlock
]

{ #category : #'*pier-security-accessing' }
PRKernel >> groups [
	^ self propertyAt: #groups ifAbsentPut: [ Set with: self adminGroup ]
]

{ #category : #'*pier-security-accessing' }
PRKernel >> userNamed: aString ifNone: aBlock [
	^ self users
		detect: [ :each | each name = aString ]
		ifNone: aBlock
]

{ #category : #'*pier-security-accessing' }
PRKernel >> users [
	^ self propertyAt: #users ifAbsentPut: [ Set with: self adminUser ]
]
