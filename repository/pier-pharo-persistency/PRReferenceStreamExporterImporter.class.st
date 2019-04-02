Class {
	#name : #PRReferenceStreamExporterImporter,
	#superclass : #PRExporterImporter,
	#category : #'Pier-Pharo-Persistency'
}

{ #category : #testing }
PRReferenceStreamExporterImporter class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRReferenceStreamExporterImporter class >> label [
	^ 'Reference Stream'
]

{ #category : #'accessing-configuration' }
PRReferenceStreamExporterImporter >> emptyWriteStream [
	^ ReferenceStream on: (RWBinaryOrTextStream on: ByteArray new)
]

{ #category : #accessing }
PRReferenceStreamExporterImporter >> extension [
	^ '.obj'
]

{ #category : #accessing }
PRReferenceStreamExporterImporter >> mimeType [
	^ 'application/binary' 
]

{ #category : #'accessing-configuration' }
PRReferenceStreamExporterImporter >> readStreamOn: aCollection [
	^ ReferenceStream on: (RWBinaryOrTextStream with: aCollection asByteArray) reset
]
