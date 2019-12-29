Class {
	#name : #PRPierConfiguration,
	#superclass : #WASystemConfiguration,
	#category : #'Pier-Seaside-Core'
}

{ #category : #description }
PRPierConfiguration >> describeOn: config [
	(config list: #kernel)
		group: #pier;
		options: [ PRKernel instances ].
	config 
		at: #rootClass put: PRPierFrame;
		at: #useCookies put: true
]

{ #category : #accessing }
PRPierConfiguration >> parents [
	^ Array with: WARenderLoopConfiguration instance
]
