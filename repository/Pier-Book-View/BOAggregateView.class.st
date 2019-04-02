"
I display my own structure and all my child structures if I answer true to #isPublication. I format publication numbers as the default book template. I provide an edit link for each child structure.

TODO: Ideally PRInternalLinks within a BOAggregateView to other content in the view would use named anchor links, rather than href links which take you outside the BOAggregateView.
"
Class {
	#name : #BOAggregateView,
	#superclass : #PRDefaultView,
	#category : #'Pier-Book-View'
}

{ #category : #testing }
BOAggregateView class >> isAbstract [ 
	^ false
]

{ #category : #testing }
BOAggregateView class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isPublication ]
]

{ #category : #accessing }
BOAggregateView class >> label [
	^ 'Aggregate View'
]

{ #category : #rendering }
BOAggregateView >> render: structure withTitleOn: html includeEditCommand: includeEditCommand [
	html heading
		level1;
		class: 'capt';
		with: [
			html span: [
				html anchor
					goto: (self context structure: structure);
					with: structure number ].
			
			html anchor
				goto: (self context structure: structure);
				with: structure title.
			
			includeEditCommand ifTrue: [	
				html span
					class: 'aggregatedEdit';
					with: [
						html anchor
							goto: (self context structure: structure command: PREditCommand new);
							with: '[ edit ]' ] ] ].
				
	self render: structure on: html

]

{ #category : #rendering }
BOAggregateView >> renderContentOn: html [
	| isEditCommandAllowed |
	isEditCommandAllowed := self context isValidCommand: PREditCommand.

	super renderContentOn: html.

	self context structure isPublication ifTrue: [
		| allChildBookPortions |
		allChildBookPortions := self context enumerator all select: [ :each | each isPublication ].
		
		allChildBookPortions do: [ :structure |
			self render: structure withTitleOn: html includeEditCommand: isEditCommandAllowed ] ]

]
