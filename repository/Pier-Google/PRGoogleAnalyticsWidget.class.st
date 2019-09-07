"
I am a widget that one can put in the footer of the templates so all pages will be tracked by google (for pageviews that are not logged in - based on onlyViews).

My uacct is the account number provided by google.

    Instance Variables
	onlyAnonymous:		<Object>
	onlyViews:		<Object>
	uacct:		<Object>


    Implementation Points - 2019 changes based off of https://developers.google.com/analytics/devguides/collection/analyticsjs/
"
Class {
	#name : #PRGoogleAnalyticsWidget,
	#superclass : #PRWidget,
	#instVars : [
		'uacct',
		'onlyAnonymous',
		'onlyViews'
	],
	#category : #'Pier-Google'
}

{ #category : #testing }
PRGoogleAnalyticsWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRGoogleAnalyticsWidget class >> label [
	^ 'Google Analytics'
]

{ #category : #'accessing-description' }
PRGoogleAnalyticsWidget >> descriptionGoogleUACCT [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'The string Google Analytics provided you with (e.g. UA-XXXXXXX-Y)';
		parameterName: 'uacct';
		accessor: #uacct;
		label: 'uacct';
		priority: 200;
		beSetting;
		yourself
]

{ #category : #'accessing-description' }
PRGoogleAnalyticsWidget >> descriptionOnlyAnonymous [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Only include the widget if the user is anonymous';
		parameterName: 'only-anonymous';
		checkboxLabel: 'Anonymous User';
		accessor: #onlyAnonymous;
		default: false;
		priority: 220;
		beSetting;
		label: '';
		yourself
]

{ #category : #'accessing-description' }
PRGoogleAnalyticsWidget >> descriptionOnlyViews [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Only include the widget in views';
		parameterName: 'only-views';
		checkboxLabel: 'Views';
		accessor: #onlyViews;
		label: 'Display';
		default: true;
		priority: 210;
		beSetting;
		yourself
]

{ #category : #testing }
PRGoogleAnalyticsWidget >> hasNoId [
	^ self uacct isNil or: [ self uacct isEmpty ]
]

{ #category : #testing }
PRGoogleAnalyticsWidget >> isNotView [
	^ self onlyViews and: [ self context command isView not ]
]

{ #category : #testing }
PRGoogleAnalyticsWidget >> isUserLoggedIn [
	^ self onlyAnonymous
		and: [ (self context respondsTo: #isLoggedIn) and: [ self context isLoggedIn ] ]
]

{ #category : #testing }
PRGoogleAnalyticsWidget >> isVisible [
	self hasNoId
		ifTrue: [ ^ false ].
	self isNotView
		ifTrue: [ ^ false ].
	self isUserLoggedIn
		ifTrue: [ ^ false ].
	^ true
]

{ #category : #accessing }
PRGoogleAnalyticsWidget >> onlyAnonymous [
	^ onlyAnonymous
]

{ #category : #accessing }
PRGoogleAnalyticsWidget >> onlyAnonymous: anObject [
	onlyAnonymous := anObject
]

{ #category : #accessing }
PRGoogleAnalyticsWidget >> onlyViews [
	^ onlyViews
]

{ #category : #accessing }
PRGoogleAnalyticsWidget >> onlyViews: anObject [
	onlyViews := anObject
]

{ #category : #rendering }
PRGoogleAnalyticsWidget >> renderContentOn: html [
	"This widget does not create any output in the HTML body."
]

{ #category : #accessing }
PRGoogleAnalyticsWidget >> uacct [
	^ uacct
]

{ #category : #accessing }
PRGoogleAnalyticsWidget >> uacct: aString [
	uacct := aString
]

{ #category : #rendering }
PRGoogleAnalyticsWidget >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	self isVisible
		ifFalse: [ ^ self ].
	anHtmlRoot javascript
		with:
			'(function(i,s,o,g,r,a,m){i[''GoogleAnalyticsObject'']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,''script'',''https://www.google-analytics.com/analytics.js'',''ga'');
ga(''create'', ' , self uacct printString , ',''auto'');
ga(''send'', ''pageview'');'
]
