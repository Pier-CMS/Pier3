Extension { #name : #JQueryInstance }

{ #category : #'*jqwidgetbox-jstree-core' }
JQueryInstance >> tree [
	"Make the selected elements Accordion widgets."
	
	^ self create: JSTree 
]
