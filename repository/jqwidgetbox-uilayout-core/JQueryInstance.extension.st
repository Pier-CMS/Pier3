Extension { #name : #JQueryInstance }

{ #category : #'*jqwidgetbox-uilayout-core' }
JQueryInstance >> layout [
	"Layout the selected element"
	
	^self create: JQUILayout
]
