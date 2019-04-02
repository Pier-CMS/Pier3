"
I am a ""dummy"" command. However if the user has permission to execute me on a structure I will enable the wiki editor. I am only asked to be excuted on structures PRCase derived structures.
"
Class {
	#name : #PRWikiTextEditingCommand,
	#superclass : #PRCommand,
	#category : #'Pier-Wysiwyg'
}

{ #category : #testing }
PRWikiTextEditingCommand class >> isAbstract [
	^ false
]
