Extension { #name : #Duration }

{ #category : #'*pier-exporter-code' }
Duration >> codeOn: aStream [
	aStream << '(' << self class greaseString <<  ' days: '; print: self days; << ' hours: '; print: self hours; << ' minutes: '; print: self minutes; << ' seconds: '; print: self seconds; << ')' 
]
