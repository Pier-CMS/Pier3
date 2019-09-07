"
Google Gadgets are simple HTML and JavaScript applications that can be embedded in webpages and other apps. Choose from thousands of Google Gadgets for your Pier installation from the Google Gadget Directory at http://www.google.com/ig/directory?synd=open.
"
Class {
	#name : #PRGoogleGadget,
	#superclass : #PRStructure,
	#instVars : [
		'url',
		'xml',
		'translations',
		'settings',
		'description'
	],
	#category : #'Pier-Google'
}

{ #category : #testing }
PRGoogleGadget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRGoogleGadget class >> label [
	^ 'Gadget'
]

{ #category : #visiting }
PRGoogleGadget >> accept: aVisitor [
	aVisitor visitGoogleGadget: self
]

{ #category : #private }
PRGoogleGadget >> buildTranslation [
	| result response elements |
	result := Dictionary new.
	xml tagsNamed: #'Locale' childrenDoAndRecurse: [ :locale |
		response := [ HTTPSocket httpGet: (locale attributeAt: 'messages' ifAbsent: [ nil ]) ]
			ifError: [ :err | nil ].
		(response isNil or: [ response isString ]) ifFalse: [
			elements := [ XMLDOMParser parseDocumentFrom: response ]
				ifError: [ :err | nil ].
			elements isNil ifFalse: [
				elements tagsNamed: #'msg' childrenDoAndRecurse: [ :msg |
					result
						at: (msg attributeAt: 'name' ifAbsent: [ '' ])
						put: (msg contentString) ].
				^ result ] ] ].
	^ result
]

{ #category : #preferences }
PRGoogleGadget >> convertBoolPreference: anXmlElement [
	^ MABooleanDescription new
]

{ #category : #preferences }
PRGoogleGadget >> convertDefaultPreference: anXmlElement [
	^ self convertStringPreference: anXmlElement
]

{ #category : #preferences }
PRGoogleGadget >> convertEnumPreference: anXmlElement [
	| options |
	options := OrderedCollection new.
	anXmlElement tagsNamed: #'EnumValue' 	childrenDoAndRecurse: [ :each |
		each attributes at: 'value' ifPresent: [ :value |
			options addLast: value -> (self translate: (each attributes
				at: 'display_value' ifAbsent: [ value ])) ] ].
	^ MASingleOptionDescription new
		optionsAndLabels: options;
		yourself
]

{ #category : #preferences }
PRGoogleGadget >> convertGenericPreference: anXmlElement [
	| preference datatype |
	preference := nil.
	datatype := anXmlElement attributes at: 'datatype' ifAbsent: [ 'string' ].
	#( 'string' convertStringPreference: 'bool' convertBoolPreference: 'enum' convertEnumPreference: 'list' convertListPreference: 'hidden' convertHiddenPreference: ) pairsDo: [ :type :selector |
		(preference isNil and: [ datatype = type ])
			ifTrue: [ preference := self perform: selector with: anXmlElement ] ].
	preference isNil
		ifTrue: [ preference := self convertDefaultPreference: anXmlElement ].
	preference beSetting.
	preference group: 'User Preferences'.
	preference propertyAt: #xml put: anXmlElement.
	preference propertyAt: #urlparam put: (anXmlElement attributes 
		at: 'urlparam' ifAbsent: [ 'up_' , (anXmlElement attributes
		at: 'name' ifAbsent: [ ^ nil ]) ]).
	preference accessor: (anXmlElement attributes 
		at: 'name' ifAbsent: [ ^ nil ]) asSymbol.
	preference label: (self translate: (anXmlElement attributes 
		at: 'display_name' ifAbsent: [ anXmlElement attributes 
		at: 'name' ifAbsent: [ nil ] ])).
	anXmlElement attributes at: 'required' ifPresent: [ :value |
		value asLowercase = 'true'
			ifTrue: [ preference beRequired ] ].
	anXmlElement attributes at: 'default_value' ifPresent: [ :value |
		preference default: (preference fromString: value) ].
	^ self magritteDescription add: preference
]

{ #category : #preferences }
PRGoogleGadget >> convertHiddenPreference: anXmlElement [
	^ MAStringDescription new
		beHidden;
		yourself
]

{ #category : #preferences }
PRGoogleGadget >> convertListPreference: anXmlElement [
	^ nil
]

{ #category : #preferences }
PRGoogleGadget >> convertStringPreference: anXmlElement [
	^ MAStringDescription new
]

{ #category : #'accessing-settings' }
PRGoogleGadget >> descriptionBorder [
	<magritteDescription>
	^ MAStringDescription new
		default: '#ffffff|3px,1px solid #999999';
		propertyAt: #urlparam put: 'border';
		group: 'Widget Preferences';
		accessor: #border;
		label: 'Border';
		priority: 2020;
		beSetting;
		yourself
]

{ #category : #'accessing-settings' }
PRGoogleGadget >> descriptionHeight [
	<magritteDescription>
	^ MANumberDescription new
		propertyAt: #urlparam put: 'h';
		group: 'Widget Preferences';
		accessor: #height;
		label: 'Height';
		priority: 2010;
		default: 75;
		beSetting;
		yourself
]

{ #category : #'accessing-editing' }
PRGoogleGadget >> descriptionUrl [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Source URL';
		accessor: #url;
		priority: 200;
		beRequired;
		beEditable;
		yourself
]

{ #category : #'accessing-editing' }
PRGoogleGadget >> descriptionUrlComment [
	<magritteDescription>
	^ MAMemoDescription new
		accessor: #urlComment;
		priority: 210;
		beReadonly;
		beEditable;
		label: '';
		yourself
]

{ #category : #'accessing-settings' }
PRGoogleGadget >> descriptionWidth [
	<magritteDescription>
	^ MANumberDescription new
		propertyAt: #urlparam put: 'w';
		group: 'Widget Preferences';
		accessor: #width;
		priority: 2000;
		label: 'Width';
		default: 320;
		beSetting;
		yourself
]

{ #category : #'accessing-dynamic' }
PRGoogleGadget >> gadgetUrl [
	| gadgetUrl |
	gadgetUrl := WAUrl new.
	gadgetUrl hostname: 'www.gmodules.com'; path: #('ig' 'ifr').
	self magritteDescription do: [ :desc |
		desc propertyAt: 'urlparam' ifPresent: [ :param |
			gadgetUrl addField: param value: (desc toString: (self readUsing: desc)) ] ].
	gadgetUrl addField: 'url' value: self url; addField: 'title' value: self title.
	gadgetUrl addField: 'synd' value: 'open'; addField: 'output' value: 'js'.
	^ gadgetUrl
]

{ #category : #'acessing-magritte' }
PRGoogleGadget >> magritteDescription [
	^ description ifNil: [ description := super magritteDescription ]
]

{ #category : #private }
PRGoogleGadget >> readUsing: aDescription [
	^ self settings
		at: (aDescription
			propertyAt: #urlparam
			ifAbsent: [ ^ super readUsing: aDescription ])
		ifAbsent: [ aDescription default ]
]

{ #category : #actions }
PRGoogleGadget >> refresh [
	| response |
	xml := translations := description := nil.
	description := MAContainer withAll: self magritteDescription.
	response := [ HTTPSocket httpGet: self url ]
		ifError: [ :err | ^ self ].
	response isString 
		ifTrue: [ ^ self ].
	xml := [ XMLDOMParser parseDocumentFrom: response ]
		ifError: [ :err | ^ self ].
	xml 
		tagsNamed: #'UserPref'
		childrenDoAndRecurse: [ :each | self convertGenericPreference: each ]
]

{ #category : #'accessing-dynamic' }
PRGoogleGadget >> settings [
	^ settings ifNil: [ settings := Dictionary new ]
]

{ #category : #translation }
PRGoogleGadget >> translate: aString [
	"For now just translate by cropping the variable prefix, later on do the real thing: http://code.google.com/apis/gadgets/docs/i18n.html."

	| input output token |
	input := aString readStream.
	output := WriteStream on: String new.
	[ input atEnd ] whileFalse: [
		output nextPutAll: (input upToAll: '__MSG_').
		input atEnd ifFalse: [
			token := input upToAll: '__'.
			output nextPutAll: (self translations
				at: token
				ifAbsent: [ token copyReplaceAll: '_' with: ' ' ]) ] ].
	^ output contents
]

{ #category : #'accessing-dynamic' }
PRGoogleGadget >> translations [
	^ translations ifNil: [ translations := self buildTranslation ]
]

{ #category : #accessing }
PRGoogleGadget >> url [
	^ url
]

{ #category : #accessing }
PRGoogleGadget >> url: aString [
	url := aString.
	self refresh
	



]

{ #category : #'accessing-dynamic' }
PRGoogleGadget >> urlComment [
	^ 'Choose from thousands of Google Gadgets for your Pier installation from the Google Gadget Directory at "http://www.google.com/ig/directory?synd=open". Select the Gadget you like and copy and paste the URL of the link "View Source" into the above input field.'
]

{ #category : #private }
PRGoogleGadget >> write: anObject using: aDescription [
	^ self settings
		at: (aDescription
			propertyAt: #urlparam
			ifAbsent: [ ^ super write: anObject using: aDescription ])
		put: anObject
]
