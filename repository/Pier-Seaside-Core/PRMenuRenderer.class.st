Class {
	#name : #PRMenuRenderer,
	#superclass : #PRViewRenderer,
	#instVars : [
		'target'
	],
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #accessing }
PRMenuRenderer >> target: aStructure [
	withinContent := true.
	target := aStructure
]

{ #category : #'visiting-links' }
PRMenuRenderer >> visitInternalLink: aLink [
	| link |
	link := aLink copy.
	link target = target ifTrue: [
		link
			parameterAt: 'class'
			put: (aLink
				parameterAt: 'class'
				ifAbsent: [ String new ]) , ' active' ].
	super visitInternalLink: link
]
