Extension { #name : #MAExternalFileModel }

{ #category : #'*Pier-Exporter-Pharo' }
MAExternalFileModel >> location [
	^self database asLocation: self directory
]
