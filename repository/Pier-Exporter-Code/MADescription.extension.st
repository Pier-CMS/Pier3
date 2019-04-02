Extension { #name : #MADescription }

{ #category : #'*pier-exporter-code' }
MADescription >> asCodeFor: aStructure value: aValue exporter: anExporter on: aStream [
	self stringAccessor asCodeFor: aStructure description: self value: aValue exporter: anExporter on: aStream
]
