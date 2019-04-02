Extension { #name : #PRWordDiffAlgorithm }

{ #category : #'*pier-seaside-rendering' }
PRWordDiffAlgorithm >> renderOn: html [
	self patchsetDo: [ :operation :object :index |
		operation = #-
			ifTrue: [ html deleted: [ self renderText: object spaces: (sourceSpaces at: index) on: html ] ]
			ifFalse: [ 
				operation = #+
					ifTrue: [ html inserted: [ self renderText: object spaces: (targetSpaces at: index) on: html ] ]
					ifFalse: [ self renderText: object spaces: (targetSpaces at: index) on: html ] ] ]
]

{ #category : #'*pier-seaside-rendering' }
PRWordDiffAlgorithm >> renderText: aString spaces: aSpacesString on: html [
	| stream char |
	html text: aString.
	stream := aSpacesString readStream.
	[ stream atEnd ] whileFalse: [ 
		char := stream next.
		char = Character cr
			ifTrue: [ html break ]
			ifFalse: [ html text: char ] ]
]
