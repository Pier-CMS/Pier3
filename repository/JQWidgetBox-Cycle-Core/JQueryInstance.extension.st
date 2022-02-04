Extension { #name : #JQueryInstance }

{ #category : #'*jqwidgetbox-cycle-core' }
JQueryInstance >> cycle [
	"put the selected images under control of the cycle JQuery widget"
	
	^ self create: JQCycle
]
