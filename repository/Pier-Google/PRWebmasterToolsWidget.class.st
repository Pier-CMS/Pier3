"
A PRWebmasterToolsWidget is a widget that helps you to activate your site at Google Webmaster Tools.

https://www.google.com/webmasters/tools/docs/en/about.html

For maximum effect use it together with the Sitemap plugin.

"
Class {
	#name : #PRWebmasterToolsWidget,
	#superclass : #PRWidget,
	#instVars : [
		'verificationKey'
	],
	#category : #'Pier-Google'
}

{ #category : #testing }
PRWebmasterToolsWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRWebmasterToolsWidget class >> label [
	^ 'Google Webmaster Tools'
]

{ #category : #'accessing-description' }
PRWebmasterToolsWidget >> descriptionVerificationKey [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'The Google Webmaster Tools Verification Key';
		selectorAccessor: #verificationKey;
		label: 'Verification Key';
		priority: 300;
		beSetting;
		yourself
]

{ #category : #rendering }
PRWebmasterToolsWidget >> renderContentOn: html [
	"This widget does not create any output in the HTML body."
]

{ #category : #updating }
PRWebmasterToolsWidget >> updateRoot: html [
	super updateRoot: html.
	self verificationKey isEmptyOrNil
		ifTrue: [ ^ self ].
	html meta
		name: 'verify-v1';
		content: self verificationKey
]

{ #category : #accessing }
PRWebmasterToolsWidget >> verificationKey [
	^ verificationKey
]

{ #category : #accessing }
PRWebmasterToolsWidget >> verificationKey: anObject [
	verificationKey := anObject
]
