Extension { #name : #MASelectorAccessor }

{ #category : #'*pier-exporter-code' }
MASelectorAccessor >> asCodeFor: structure description: description value: value exporter: exporter on: stream [
	stream << '	structure ' << self writeSelector greaseString << ' ' << value << '.'
]
