Class {
	#name : #PRAdminSetupDefineAdminUser,
	#superclass : #GRObject,
	#instVars : [
		'password',
		'name'
	],
	#category : #'Pier-Admin-Setup-NewKernelFromDistribution'
}

{ #category : #'magritte descriptions' }
PRAdminSetupDefineAdminUser >> descriptionContainer [
	<magritteContainer>
	^ super descriptionContainer
		componentRenderer: TWBSMagritteFormRenderer;
		yourself
]

{ #category : #accessing }
PRAdminSetupDefineAdminUser >> getName [
	"not named #name to avoid overriding Object>>#name"
	^ name
]

{ #category : #accessing }
PRAdminSetupDefineAdminUser >> name: anObject [
	name := anObject
]

{ #category : #'magritte descriptions' }
PRAdminSetupDefineAdminUser >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: (MASelectorAccessor read: #getName write: #name:);
		label: 'Name';
		priority: 100;
		componentClass: TWBSMagritteTextInputComponent; "is required for placeholder text below"
		placeholder: 'admin user name';
		beRequired;
		yourself
]

{ #category : #accessing }
PRAdminSetupDefineAdminUser >> password [
	^ password
]

{ #category : #accessing }
PRAdminSetupDefineAdminUser >> password: anObject [
	password := anObject
]

{ #category : #'magritte descriptions' }
PRAdminSetupDefineAdminUser >> passwordDescription [
	<magritteDescription>
	^ MAPasswordDescription new
		parameterName: 'password';
		accessor: #password;
		componentClass: TWBSVerifiedPasswordComponent;
		label: 'Password';
		priority: 200;
		placeholder: 'admin user password';
		beRequired;
		yourself
]
