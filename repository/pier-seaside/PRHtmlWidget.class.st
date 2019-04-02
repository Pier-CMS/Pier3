Class {
	#name : #PRHtmlWidget,
	#superclass : #PRWidget,
	#instVars : [
		'text'
	],
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-defaults' }
PRHtmlWidget class >> defaultText [
	^ '<h1>%k</h1><h2>%c</h2>'
]

{ #category : #testing }
PRHtmlWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRHtmlWidget class >> label [
	^ 'HTML'
]

{ #category : #'accessing-descriptions' }
PRHtmlWidget >> descriptionText [
	<magritteDescription>
	^ MAMemoDescription new
		default: self class defaultText;
		parameterName: 'text';
		accessor: #text;
		priority: 100;
		label: 'Text';
		yourself
]

{ #category : #rendering }
PRHtmlWidget >> renderContentOn: html [
	html html: self text
]

{ #category : #accessing }
PRHtmlWidget >> text [
	^ self expand: text
]

{ #category : #accessing }
PRHtmlWidget >> text: aText [
	text := aText
]
