Class {
	#name : #BOZipView,
	#superclass : #BOBookView,
	#category : #'Pier-Book-Latex'
}

{ #category : #accessing }
BOZipView class >> label [
	^ 'Book ZIP'
]

{ #category : #adding }
BOZipView >> addFilesTo: anArchive [
	self book enumerator with all do: [ :structure |
		structure outgoingReferences do: [ :link |
			(link isInternal and: [ link isBroken not and: [ link isEmbedded and: [ link target isFigure ] ] ]) ifTrue: [
				anArchive
					addFile: (link target file directory fullNameFor: link target file filename)
					as: (link target file location reduce: [ :a :b | a , '/' , b ]) , '/' , link target file filename ] ] ]
]

{ #category : #adding }
BOZipView >> addLatexTo: anArchive [
	| contents |
	contents := (self writer write: self book)
		copyReplaceAll: MAExternalFileModel baseDirectory fullName , GRPlatform current pathSeparator
		with: String new.
	anArchive
		addString: (self requestContext codec encode: contents)
			asByteArray
		as: self book name , '.tex'
]

{ #category : #responding }
BOZipView >> respondUsing: aResponse [
	| archive |
	super respondUsing: aResponse.
	aResponse
		binary;
		contentType: 'application/zip';
		attachmentWithFileName: self book name , '.zip'.
	archive := ZipArchive new.
	self addLatexTo: archive; addFilesTo: archive.
	archive writeTo: aResponse stream.
	archive close
]
