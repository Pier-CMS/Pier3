Extension { #name : #PRCommand }

{ #category : #'*pier-seaside-converting' }
PRCommand >> asComponent [
	"Answer a compoent to configure the edit operation of the receiver. This does not require to be a Magritte component, but in most cases it is."

	^ super asComponent
		addValidatedForm: self buttonSpecification;
		yourself
]

{ #category : #'*pier-seaside-converting' }
PRCommand >> buttonSpecification [
	^ Array with: self saveButton with: self cancelButton
]

{ #category : #'*pier-seaside-converting' }
PRCommand >> cancelButton [
	^ #cancel -> 'Cancel'
]

{ #category : #'*pier-seaside-converting' }
PRCommand >> saveButton [
	^ #save -> 'Save'
]
