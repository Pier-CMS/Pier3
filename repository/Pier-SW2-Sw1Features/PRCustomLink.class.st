"
A PRCustomLink is an external link which can be modified in code ad hoc.  It uses StringToUrlBlocks to hold a OrderedCollection of blocks that can either create a URL or return nil.
"
Class {
	#name : #PRCustomLink,
	#superclass : #PRExternalLink,
	#classVars : [
		'StringToUrlBlocks'
	],
	#category : #'Pier-SW2-Sw1Features'
}

{ #category : #accessing }
PRCustomLink class >> addConversion: aBlock [
	aBlock argumentCount = 1
		ifFalse: [ self error: 'This expects a one argument block' ].
	self stringToUrlBlocks add: aBlock
]

{ #category : #'private-testing' }
PRCustomLink class >> conversions: aCollection [
	aCollection isCollection
		ifFalse: [ self error: 'The argument must be a collection.' ].
	StringToUrlBlocks := aCollection
]

{ #category : #accessing }
PRCustomLink class >> example [
	| ccRunArray numberPart numbers |
	ccRunArray := RunArray
		new: 4999
		withAll: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=Comcast&Load_CC='.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=SITEWIDE&Load_CC='
		withOccurrences: 8000 - 5000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=Cricket&Load_CC='
		withOccurrences: 25000 - 8000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/CustCC/CCEntryForm.aspx?CompanyName=Clear&Load_CC='
		withOccurrences: 35000 - 24999.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/CustCC/CCEntryForm.aspx?CompanyName=Vonage&Load_CC='
		withOccurrences: 45000 - 35000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/CustCC/CCEntryForm.aspx?CompanyName=CenturyTel&Load_CC='
		withOccurrences: 50000 - 45000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/CustCC/CCEntryForm.aspx?CompanyName=metroPCS&Load_CC='
		withOccurrences: 75000 - 50000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/CustCC/CCEntryForm.aspx?CompanyName=Cablevision&Load_CC='
		withOccurrences: 85000 - 75000.
	ccRunArray add: 'http://cmidom1srv/cmi/formsarchive.nsf/ReqNumber/cc' withOccurrences: 94477 - 85000.
	ccRunArray add: 'http://cmidom1srv/cmi/forms.nsf/ReqNumber/cc' withOccurrences: 107968 - 94477.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=Sprint&Load_CC='
		withOccurrences: 280000 - 107968.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=TMobile2&Load_CC='
		withOccurrences: 400000 - 280000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=Comcast&Load_CC='
		withOccurrences: 650000 - 400000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=Cablevision&Load_CC='
		withOccurrences: 700000 - 650000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=mobilicity&Load_CC='
		withOccurrences: 850000 - 700000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=Defense&Load_CC='
		withOccurrences: 900000 - 850000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=USCC&Load_CC='
		withOccurrences: 980000 - 900000.
	ccRunArray
		add: 'https://cmicc.corp.amdocs.com/custcc/CCEntryForm.aspx?CompanyName=SITEWIDE&Load_CC='
		withOccurrences: 2000000 - 980000.
	self
		addConversion: [ :aString | 
			(('cc###*' match: aString) and: [ (numberPart := aString copyFrom: 3 to: aString size) isAllDigits ])
				ifTrue: [ (ccRunArray at: numberPart asInteger ifAbsent: [ ^ nil ]) , numberPart ] ].
	self
		addConversion: [ :aString | 
			(('cc######dr' match: aString) and: [ (aString copyFrom: 3 to: 8) isAllDigits ])
				ifTrue: [ 'http://cmidom1srv/cmi/forms.nsf/ReqNumber/' , aString asLowercase ] ].
	self
		addConversion: [ :aString | 
			(('xc######' match: aString) and: [ (aString copyFrom: 3 to: 8) isAllDigits ])
				ifTrue: [ 'http://cmidom1srv/cmi/cingular.nsf/ReqNumber/' , aString asLowercase ] ].
	self
		addConversion: [ :aString | 
			(('Case #*-#*' match: aString)
				and: [ 
					numbers := (aString copyFrom: 6 to: aString size) findTokens: '-'.
					numbers size = 2 and: [ (numbers contains: [ :aSubString | aSubString isAllDigits not ]) not ] ])
				ifTrue: [ 
					numbers last size > 5
						ifTrue: [ 'http://productsupport.corp.amdocs.com/pages/viewcase.aspx?caseid=' , (aString copyFrom: 6 to: aString size) ]
						ifFalse: [ 'http://cmiweb1/champs/Subcase_Details.asp?idn=' , (aString copyFrom: 6 to: aString size) ] ] ].
	self
		addConversion: [ :aString | 
			(('Case ######*' match: aString) and: [ (aString copyFrom: 6 to: aString size) isAllDigits ])
				ifTrue: [ 'http://cmiweb1/champs/Case_Details.asp?idn=' , (aString copyFrom: 6 to: aString size) ] ].
	self
		addConversion: [ :aString | 
			('\\cmifs01\*' match: aString)
				ifTrue: [ 
					'file:///'
						,
							(aString copy
								translateWith:
									((String withAll: Character allCharacters)
										at: $\ asciiValue + 1 put: $/;
										yourself)) ] ].
	self
		addConversion: [ :aString | 
			(('doc *' match: aString) and: [ (aString copyFrom: 5 to: aString size) isAllDigits ])
				ifTrue: [ 'http://Docloader/Docloader/docloader.aspx?action=view&docnum=' , (aString copyFrom: 5 to: aString size) ] ].
	self
		addConversion: [ :aString | 
			(('rca ai ##*' match: aString) and: [ (aString copyFrom: 8 to: aString size) isAllDigits ])
				ifTrue: [ 'http://cmiweb1/sitepmo/rootCauseAnalysis/rca-issueActionItemEdit.asp?aiid=' , (aString copyFrom: 8 to: aString size) ] ].
	self
		addConversion: [ :aString | 
			(('rca ##*' match: aString) and: [ (aString copyFrom: 5 to: aString size) isAllDigits ])
				ifTrue: [ 'http://cmiweb1/sitepmo/rootCauseAnalysis/rca-issueEdit.asp?rcid=' , (aString copyFrom: 5 to: aString size) ] ].
	self
		addConversion: [ :aString | 
			(('kaizen #*' match: aString) and: [ (aString copyFrom: 8 to: aString size) isAllDigits ])
				ifTrue: [ 
					'http://creativity/SpaceDirectory/Sites/LeanAhead/KaiZen/Lists/Kai%20Zen/DispIdea.aspx?ID='
						, (aString copyFrom: 8 to: aString size) ] ].
	self
		addConversion: [ :aString | 
			('//cmifs01/*' match: aString)
				ifTrue: [ 'file:///' , aString ] ].
	self
		addConversion: [ :aString | 
			('INC############' match: aString)
				ifTrue: [ 
					'https://gssuts/arsys/forms/arhprdsg/SHR%3ALandingConsole/Default+Administrator+View/?mode=search&F304255500=HPD%3AHelp+Desk&F1000000076=FormOpenNoAppList&F303647600=SearchTicketWithQual&F304255610=''1000000161''%3D%22'
						, aString , '%22' ] ].
	self
		addConversion: [ :aString | 
			('WO#############' match: aString)
				ifTrue: [ 
					'https://gssuts/arsys/forms/arhprdsg/SHR%3ALandingConsole/Default+Administrator+View/?mode=search&F304255500=WOI%3AWorkOrder&F1000000076=FormOpenNoAppList&F303647600=SearchTicketWithQual&F304255610=%271000000182%27%3D%22'
						, aString , '%22' ] ]
]

{ #category : #testing }
PRCustomLink class >> isValidReference: aString [
	^ self stringToUrlBlocks contains: [ :block | (block value: aString) notNil ]
]

{ #category : #accessing }
PRCustomLink class >> stringToUrlBlocks [
	StringToUrlBlocks isNil
		ifTrue: [ StringToUrlBlocks := OrderedCollection new ].
	^ StringToUrlBlocks
]

{ #category : #'accessing-dynamic' }
PRCustomLink >> url [
	^ (self class stringToUrlBlocks detect: [ :e | (e value: self reference) notNil ]) value: self reference
]
