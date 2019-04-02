"
Pier1ToPier2ConverterTest is modeled after PRKernelTest

Instance Variables:
	kernel	PRKernel
"
Class {
	#name : #Pier1ToPier2ConverterTest,
	#superclass : #PRObjectTest,
	#instVars : [
		'kernel'
	],
	#category : #'Pier-SW2-Sw1Features'
}

{ #category : #accessing }
Pier1ToPier2ConverterTest >> actualClass [
	^ PRKernel
]

{ #category : #accessing }
Pier1ToPier2ConverterTest >> instance [
	^ self kernel
]

{ #category : #accessing }
Pier1ToPier2ConverterTest >> kernel [
	^ kernel ifNil: [ kernel := self kernelInstance ]
]

{ #category : #tests }
Pier1ToPier2ConverterTest >> testConvertAmpersandString [
	self
		assert:
			(Pier1ToPier2Converter new convertString: 'This contains & as well as &#42; in it.')
				= 'This contains & as well as {{{&#42;}}} in it.'.
	self
		assert:
			(Pier1ToPier2Converter new convertString: 'This contains &LT; as well as &gT; in it.')
				= 'This contains {{{&LT;}}} as well as {{{&gT;}}} in it.'
]

{ #category : #tests }
Pier1ToPier2ConverterTest >> testConvertPage [
	| converter |
	self kernel root contents: 'This is a *link to this page>./*'.
	converter := Pier1ToPier2Converter new kernel: self kernel.
	converter convertPage: self kernel root.
	self assert: self kernel root contents = 'This is a *link to this page>./*'
]

{ #category : #tests }
Pier1ToPier2ConverterTest >> testConvertPageWithTable [
	| converter |
	self kernel root
		contents:
			'This is a page that contains tables and HTML.
|<span>This is HTML</span>|This is not
'.
	converter := Pier1ToPier2Converter new kernel: self kernel.
	converter convertPage: self kernel root.
	self
		assert:
			self kernel root contents
				=
					'This is a page that contains tables and HTML.
| {{{<span>}}}This is HTML{{{</span>}}}|This is not'
]

{ #category : #tests }
Pier1ToPier2ConverterTest >> testConvertString [
	self assert: (Pier1ToPier2Converter new convertString: '<br />') = '{{{<br />}}}'.
	self
		assert:
			(Pier1ToPier2Converter new
				convertString:
					'Change this <br /> string
= This should not change <br /> because preformatted
another string')
				=
					'Change this {{{<br />}}} string
= This should not change <br /> because preformatted
another string'.
	self
		assert:
			(Pier1ToPier2Converter new convertString: '<div class="First">text</div> and <div class="Second">text</div>')
				= '{{{<div class="First">}}}text{{{</div>}}} and {{{<div class="Second">}}}text{{{</div>}}}'
]
