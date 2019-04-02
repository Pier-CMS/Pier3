Extension { #name : #PRValueLink }

{ #category : #'*pier-security' }
PRValueLink >> groupIn: aContext [
	<value: 'group' comment: 'Display the group of the current structure.'>
	
	^ self lookupStructure: aContext structure do: [ :structure |
		self formatDescribed: structure group default: #name ]
]

{ #category : #'*pier-security' }
PRValueLink >> ownerIn: aContext [
	<value: 'owner' comment: 'Display the owner of the current structure.'>

	^ self lookupStructure: aContext structure do: [ :structure |
		self formatDescribed: structure owner default: #name ]
]

{ #category : #'*pier-security' }
PRValueLink >> userIn: aContext [
	<value: 'user' comment: 'Display the currently authenticated structure.'>

	^ self formatDescribed: aContext user default: #name
]
