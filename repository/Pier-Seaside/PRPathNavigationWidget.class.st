"
PRPathNavigationWidget is a widget that displays the link path to the current structure, as links (like / parent / child / thisPage).

"
Class {
	#name : #PRPathNavigationWidget,
	#superclass : #PRNavigationWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #accessing }
PRPathNavigationWidget class >> label [
	^ 'Link Path'
]

{ #category : #rendering }
PRPathNavigationWidget >> renderParents: aCollection on: html [
	| active path |
	active := self isActive: aCollection first.
	path := active and: [ self selected parents includes: aCollection first ].
	(html anchor)
		class: 'path' if: path;
		class: 'active' if: active;
		goto: (self context structure: aCollection first);
		with: '/'.
	aCollection allButFirst do: [ :e | self renderItem: e on: html ] separatedBy: [ html text: '/' ]
]

{ #category : #accessing }
PRPathNavigationWidget >> unfilteredItems [
	self shouldNotImplement
]
