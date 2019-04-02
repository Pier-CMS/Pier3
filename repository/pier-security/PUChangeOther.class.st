Class {
	#name : #PUChangeOther,
	#superclass : #PUChangeSecurity,
	#category : #'Pier-Security-Command'
}

{ #category : #accessing }
PUChangeOther class >> accessKey [
	^ $o
]

{ #category : #testing }
PUChangeOther class >> isAbstract [
	^ false
]

{ #category : #accessing }
PUChangeOther class >> label [
	^ 'Change Other'
]

{ #category : #configuration }
PUChangeOther >> accessor [
	^ #(securityDecoration otherPermissions) asAccessor
]
