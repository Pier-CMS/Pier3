Extension { #name : #MAAccessor }

{ #category : #'*pier-exporter-code' }
MAAccessor >> asCodeFor: structure description: description value: value exporter: exporter on: stream [
	exporter exportHelper asCodeFor: structure description: description value: value on: stream
]
