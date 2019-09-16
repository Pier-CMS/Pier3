Extension { #name : #PRViewRenderer }

{ #category : #'*pier-google-visiting' }
PRViewRenderer >> visitGoogleGadget: aStructure [
	html script url: aStructure gadgetUrl
]
