Extension { #name : #JQueryInstance }

{ #category : #'*jqwidgetbox-formexample-core' }
JQueryInstance >> example: aStringOrFunction [
	"Populate form input fields with example text that disappears on focus."
	
	self 
		call: 'example'
		with: aStringOrFunction

]

{ #category : #'*jqwidgetbox-formexample-core' }
JQueryInstance >> example: aStringOrFunction class: aCssClass [
	"Populate form input fields with example text that disappears on focus."
	
	self 
		call: 'example'
		with: aStringOrFunction
		with: (GRSmallDictionary new 
			at: 'className' put: aCssClass;
			yourself)


]
