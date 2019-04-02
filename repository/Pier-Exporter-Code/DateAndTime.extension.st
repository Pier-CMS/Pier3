Extension { #name : #DateAndTime }

{ #category : #'*pier-exporter-code' }
DateAndTime >> codeOn: aStream [
	aStream << '(' << self class greaseString << ' year: '; print: self year; << ' month: '; print: self monthIndex; << ' day: '; print: self dayOfMonth; << ' hour: '; print: self hour; << ' minute: '; print: self minute; << ' second: '; print: self second; << ')' 
]
