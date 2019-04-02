Extension { #name : #Date }

{ #category : #'*pier-exporter-code' }
Date >> codeOn: aStream [
	aStream << '(' << self class greaseString << ' newDay: '; print: self dayOfYear; << ' year: '; print: self year; << ')'
]
