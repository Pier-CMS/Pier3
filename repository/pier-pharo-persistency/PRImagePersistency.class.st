"
I  allow storage of the wiki using the image file.  I keep maxImages backups based on namePrefix.  

    Instance Variables
	maxImages:		<Integer>
	namePrefix:		<String>

"
Class {
	#name : #PRImagePersistency,
	#superclass : #PRDelayedPersistency,
	#instVars : [
		'namePrefix',
		'maxImages'
	],
	#category : #'Pier-Pharo-Persistency'
}

{ #category : #private }
PRImagePersistency >> cleanupBackupImages [
	| images |
	maxImages isNil
		ifTrue: [ ^ self ].
	images := FileSystem disk workingDirectory fileNames
		select:
			[ :each | (each endsWith: Smalltalk imageSuffix) and: [ each beginsWith: namePrefix ] ].
	images size <= maxImages
		ifTrue: [ ^ self ].
	images := (images asSortedCollection allButLast: maxImages)
		collect: [ :each | each copyUpToLast: $. ].
	images
		do: [ :each | 
			FileSystem disk workingDirectory / (each , '.' , Smalltalk imageSuffix)
				deleteIfAbsent: [  ].
			FileSystem disk workingDirectory / (each , '.' , Smalltalk changesSuffix)
				deleteIfAbsent: [  ] ]
]

{ #category : #'accessing-descriptions' }
PRImagePersistency >> descriptionMaxImages [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The maximum number of backup copies to keep';
		accessor: #maxImages;
		label: 'Backup Images';
		priority: 110;
		beRequired;
		default: 3;
		beInteger;
		yourself
]

{ #category : #'accessing-descriptions' }
PRImagePersistency >> descriptionNamePrefix [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'Defines the prefix for image-names.';
		default: 'pier_backup_';
		accessor: #namePrefix;
		label: 'Backup Prefix';
		priority: 120;
		beRequired;
		yourself
]

{ #category : #accessing }
PRImagePersistency >> maxImages [
	^ maxImages
]

{ #category : #accessing }
PRImagePersistency >> maxImages: anInteger [
	"The maximum number of backup copies to keep."

	maxImages := anInteger 
]

{ #category : #accessing }
PRImagePersistency >> namePrefix [
	^ namePrefix
]

{ #category : #accessing }
PRImagePersistency >> namePrefix: aString [
	"Defines the prefix for backup copies."

	namePrefix := aString
]

{ #category : #private }
PRImagePersistency >> saveImageAndBackupAs: aString [
	| directory image imageName changeName |
	directory := FileSystem disk workingDirectory.
	image := SmalltalkImage current.
	image closeSourceFiles.
	[ imageName := aString , '.' , Smalltalk imageSuffix.
	changeName := aString , '.' , Smalltalk changesSuffix.
	((directory / imageName) exists not and: [ (directory / changeName) exists not ])
		ifTrue: [ directory / imageName deleteIfAbsent: [  ].
			directory / changeName deleteIfAbsent: [  ].
			image imageFile copyTo: directory / imageName.
			image changesFile copyTo: directory / changeName ] ]
		ensure: [ image
				openSourceFiles;
				snapshot: true andQuit: false ]
]

{ #category : #actions }
PRImagePersistency >> snapshot [
	| filename |
	filename := namePrefix , DateAndTime now asSortableString.
	[ self saveImageAndBackupAs: filename ] valueUnpreemptively.
	self message: 'Last snapshot ' , filename printString , ' at ' , DateAndTime now greaseString.
	self cleanupBackupImages
]
