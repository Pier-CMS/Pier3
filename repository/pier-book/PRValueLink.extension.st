Extension { #name : #PRValueLink }

{ #category : #'*pier-book' }
PRValueLink >> bookContentsIn: aContext [
	<value: 'book.contents' comment: 'Display a table of contents.'>

	| result |
	^ self lookupStructure: aContext structure do: [ :root |
		result := OrderedCollection new.
		root enumerator everything do: [ :structure |
			(structure isPublication and: [ structure isBook not and: [ structure isParagraph not ] ]) ifTrue: [
				(result isEmpty or: [ structure isPart ])
					ifTrue: [ result add: PRDefinitionList new ].
				self 
					bookLabel: (structure number 
						ifNil: [ ' ' ])
					class: nil
					target: structure 
					to: result last ] ].
		result ]

]

{ #category : #'*pier-book' }
PRValueLink >> bookFiguresIn: aContext [
	<value: 'book.figures' comment: 'Display a table of figures.'>

	| result |
	^ self lookupStructure: aContext structure do: [ :root |
		result := OrderedCollection new.
		root enumerator everything do: [ :structure |
			(result isEmpty or: [ structure isPublication and: [ structure isPart ] ])
				ifTrue: [ result add: PRDefinitionList new ].
			(structure isFigure and: [ structure isNumberedTitle ]) ifTrue: [
				result last
					add: (PRTermItem with: (PRText content: structure number));
					add: (PRDataItem with: (PRInternalLink new
						add: (PRText content: structure title);
						anchor: (structure name 
							select: [ :each | each isAlphaNumeric ]);
						target: structure parent;
						yourself)) ] ].
		result ]
]

{ #category : #'*pier-book' }
PRValueLink >> bookIndexIn: aContext [
	<value: 'book.index' comment: 'Display an index of keywords.'>

	| structs |
	^ self lookupStructure: aContext structure do: [ :root |
		| index |
		index := BOIndexBuilder new start: root.
		(index keys asSortedCollection: [ :a :b | a asLowercase < b asLowercase ])
			inject: PRDefinitionList new
			into: [ :list :word |
				structs := Set new.
				list add: (PRTermItem with: (PRText content: word)).
				(index at: word) do: [ :struct |
					(structs includes: struct) ifFalse: [ 
						structs add: struct.
						list add: (PRDataItem with: (PRInternalLink new
							anchor: word;
							target: struct;
							yourself)) ] ].
				list ] ]
]

{ #category : #'*pier-book-private' }
PRValueLink >> bookLabel: aString class: aClassString target: aStructure to: aDefinitionList [
	| number |
	^ aDefinitionList
		add: (PRTermItem with: (PRRaw content: (aStructure isNil
			ifTrue: [ '&nbsp;' ]
			ifFalse: [ aString ])));
		add: (PRDataItem with: (aStructure isNil
			ifTrue: [ PRRaw content: '&nbsp;' ]
			ifFalse: [
				number := aStructure number.
				number isNil 
					ifTrue: [ number := String new ]
					ifFalse: [ number := number , ' ' ].
				PRInternalLink new 
					parameterAt: 'title' put: number , aStructure title;
					parameterAt: 'class' put: aClassString;
					target: aStructure;
					yourself ]));
		yourself
]

{ #category : #'*pier-book' }
PRValueLink >> bookNavigationIn: aContext [
	<value: 'book.navigation' comment: 'Display a navigation structure for books.'>

	^ self lookupStructure: aContext structure do: [ :structure |
		| root structures index result |
		root := structure
			findAncestor: [ :each | each isPublication and: [ each isBook ] ]
			ifAbsent: [ ^ nil ].
		structures := (aContext enumeratorFor: root) everything
			select: [ :each | each isPublication ].
		index := structures indexOf: (structure
			findAncestor: [ :each | each isPublication ])
			ifAbsent: [ ^ nil ].
		result := PRDefinitionList new.
		self
			bookLabel: '&rarr;' class: 'navigation-next' target: (structures at: index + 1 ifAbsent: [ nil ]) to: result;
			bookLabel: '&larr;' class: 'navigation-prev' target: (structures at: index - 1 ifAbsent: [ nil ]) to: result ]
]

{ #category : #'*pier-book' }
PRValueLink >> bookParentIn: aContext [
	<value: 'book.parent' comment: 'Display the parent structure for books.'>

	^ self lookupStructure: aContext structure do: [ :structure |
		self
			bookLabel: '&sect;'
			class: 'navigation-parent'
			target: (structure parent isNil 
				ifFalse: [ structure parent findAncestor: [ :each | each isPublication ] ]) 
			to: PRDefinitionList new ]
]
