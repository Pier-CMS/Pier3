Class {
	#name : #PRSixxExporterImporter,
	#superclass : #PRExporterImporter,
	#category : #'Pier-Pharo-Persistency'
}

{ #category : #testing }
PRSixxExporterImporter class >> isAbstract [
	^ self sixxReadStreamClass isNil or: [ self sixxWriteStreamClass isNil ] 
]

{ #category : #accessing }
PRSixxExporterImporter class >> label [
	^ 'SIXX Serializer' 
]

{ #category : #private }
PRSixxExporterImporter class >> sixxReadStreamClass [
	^ Smalltalk classNamed: #SixxReadStream
]

{ #category : #private }
PRSixxExporterImporter class >> sixxWriteStreamClass [
	^ Smalltalk classNamed: #SixxWriteStream
]

{ #category : #'accessing-configuration' }
PRSixxExporterImporter >> emptyWriteStream [
	^ self class sixxWriteStreamClass on: (RWBinaryOrTextStream on: ByteString new)
]

{ #category : #accessing }
PRSixxExporterImporter >> extension [
	^ '.sxx'
]

{ #category : #accessing }
PRSixxExporterImporter >> mimeType [
	^ 'text/xml'
]

{ #category : #'accessing-configuration' }
PRSixxExporterImporter >> readStreamOn: aCollection [
	^ self class sixxReadStreamClass on: aCollection greaseString 
]
