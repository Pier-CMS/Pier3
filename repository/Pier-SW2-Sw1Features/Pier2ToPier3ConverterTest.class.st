Class {
	#name : #Pier2ToPier3ConverterTest,
	#superclass : #Pier1ToPier2ConverterTest,
	#category : #'Pier-SW2-Sw1Features'
}

{ #category : #tests }
Pier2ToPier3ConverterTest >> testConvertPageName [
	| converter |
	self kernel root
		name: 'Bad Name';
		contents: 'This page has a bad name'.
	converter := Pier2ToPier3Converter new kernel: self kernel.
	converter convertPage: self kernel root.
	self
		assert: self kernel root title = 'Bad Name';
		assert: self kernel root name = 'bad-name'
]
