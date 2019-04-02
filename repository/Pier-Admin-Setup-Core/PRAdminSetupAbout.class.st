Class {
	#name : #PRAdminSetupAbout,
	#superclass : #WAComponent,
	#category : #'Pier-Admin-Setup-Core'
}

{ #category : #accessing }
PRAdminSetupAbout >> numColumns [
	^ 7
]

{ #category : #rendering }
PRAdminSetupAbout >> renderContentOn: html [
	self renderIntroductionOn: html.
	html horizontalRule.
	self renderHowToLoadOn: html.
	html horizontalRule.
	self renderLicenceOn: html
]

{ #category : #rendering }
PRAdminSetupAbout >> renderHowToLoadOn: html [
	html div: [
		html div: 'You can load Pier Admin with: '.
		html break.
		html div: [ 
			html preformatted: [ 
				html code: 'Gofer it
	squeaksource: ''MetacelloRepository'';
	package: ''ConfigurationOfPier3AddOns'';
    	load.

ConfigurationOfPier3AddOns load.' ] ] ].

]

{ #category : #rendering }
PRAdminSetupAbout >> renderIntroductionOn: html [
	html heading level3; with: 'Introduction'.
	html break.
	html text: 'Pier is a content management system that is light, flexible and free. It is light as in double click and go. It is flexible as in make it be what you want. It is free as in freedom.'.
]

{ #category : #rendering }
PRAdminSetupAbout >> renderLicenceOn: html [
	html heading level4; with: 'Pier Licence'.
	html break.
	html text: PRBasicObject pierLicense
]
