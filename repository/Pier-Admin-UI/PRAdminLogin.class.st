"
I am the root class of Pier Admin. I login the user, set that user into the kernel's context then #show: ==PRAdminUI== - the Pier administrative UI!

"
Class {
	#name : #PRAdminLogin,
	#superclass : #WAComponent,
	#instVars : [
		'pierComponent',
		'loginComponent'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #initialize }
PRAdminLogin class >> registerAt: dispatcherName administering: kernelPathPair [
	| pierAdminApplication |
	pierAdminApplication := (WAAdmin register: self asApplicationAt: dispatcherName)
		preferenceAt: #useCookies put: false;
		preferenceAt: #scriptGeneratorClass put: JQScriptGenerator;
		preferenceAt: #documentClass put: PRAdminHtmlDocumentStoredHeadElements;
		preferenceAt: #actionPhaseContinuationClass put: PRAdminActionPhaseContinuation;
		preferenceAt: #renderPhaseContinuationClass put: PRAdminRenderPhaseContinuation;
		preferenceAt: #rootDecorationClasses put: #();
		yourself.
	
	pierAdminApplication
		addLibrary: JQDeploymentLibrary;
		addLibrary: JQUiDeploymentLibrary;
		addLibrary: JQBaseTheme;
		addLibrary: SPHighlightedStyle.

	pierAdminApplication configuration addParent: NAFileUploadConfigurator instance.	
	pierAdminApplication configuration addParent: PRAdminConfigurator instance.
	pierAdminApplication pierAdminKernelPathPair: kernelPathPair
]

{ #category : #initialize }
PRAdminLogin class >> registerForAdministering: kernelPathPair [
	| adminInstancePath |
	
	adminInstancePath := kernelPathPair path, '-admin'.
	self registerAt: adminInstancePath administering: kernelPathPair.
	^ adminInstancePath
]

{ #category : #helpers }
PRAdminLogin class >> renderAssociatedPierInstanceLinkFor: kernel text: text on: html [
	| urlPath kernelApplicationPaths kernelPathPair |
	kernelApplicationPaths := PRAdminKernelPathPair kernelPathPairs.
	kernelPathPair := kernelApplicationPaths detect: [ :each | each kernel = kernel ] ifNone: [ nil ].

	kernelPathPair notNil ifTrue: [		
		html div
			id: #pierInstanceLink;
			with: [
				| url |
				url := WAUrl absolute: kernelPathPair path.
				html text: text.
				html anchor
					class: 'external';
					url: url;
					with: url greaseString ] ]
]

{ #category : #accessing }
PRAdminLogin >> children [
	^ Array with: self pierComponent with: self loginComponent
]

{ #category : #private }
PRAdminLogin >> handleLoginAnswer: loginCommand [
	loginCommand isNil
		ifTrue: [ ^ self ].
	loginCommand successAnswer: loginCommand.
	[ 
	loginCommand doValidate.
	loginCommand doAnswer ]
		on: MAError
		do: [ :error | self loginComponent errors add: error ].
	self loginComponent errors isEmpty
		ifFalse: [ ^ self ].
	self pierComponent setLoggedInUser: loginCommand user.
	self show: (PRAdminUI pierComponent: self pierComponent)
]

{ #category : #accessing }
PRAdminLogin >> kernelPathPair [
	^ self application pierAdminKernelPathPair
]

{ #category : #accessing }
PRAdminLogin >> loginComponent [
	^ loginComponent ifNil: [ 
		| loginCommand |
		loginCommand := PULogin new 
			setContext: (self pierComponent context);
			yourself.
			
		loginComponent := loginCommand asComponent
		 	onAnswer: [ :aLoginCommand | self handleLoginAnswer: aLoginCommand ];
			yourself ]
]

{ #category : #accessing }
PRAdminLogin >> pierComponent [
	^ pierComponent ifNil: [
		pierComponent := PRAdminPierComponent kernel: self kernelPathPair kernel ]
]

{ #category : #rendering }
PRAdminLogin >> renderAssociatedInstanceLinkOn: html [
	self class renderAssociatedPierInstanceLinkFor: self pierComponent kernel text: 'Login to: ' on: html.
	html break.
]

{ #category : #rendering }
PRAdminLogin >> renderContentOn: html [
	html div
		class: 'adminLogin';
		with: [
			self renderTitleOn: html.
			self renderAssociatedInstanceLinkOn: html.

			html render: self loginComponent ]
]

{ #category : #rendering }
PRAdminLogin >> renderTitleOn: html [
	html heading
		level1;
		class: 'adminLoginTitle';
		with: [
			html text: 'Welcome to '.
			html image url:  PRAdminFileLibrary / #pierlogo75x35Png.
			html text: ' admin' ]
]

{ #category : #hooks }
PRAdminLogin >> states [
	^ Array with: self 
]

{ #category : #updating }
PRAdminLogin >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	PRAdminFileLibrary default updateRoot: anHtmlRoot
]
