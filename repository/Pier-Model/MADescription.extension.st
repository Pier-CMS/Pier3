Extension { #name : #MADescription }

{ #category : #'*pier-model' }
MADescription >> beEditable [
	self propertyAt: #editable put: true
]

{ #category : #'*pier-model' }
MADescription >> beSearchable [
	self propertyAt: #searchable put: true
]

{ #category : #'*pier-model' }
MADescription >> defaultStringAccessor [
	^self accessor
]

{ #category : #'*pier-model' }
MADescription >> isDocumentDescription [
	^ false
]

{ #category : #'*pier-model' }
MADescription >> isEditable [
	^ self propertyAt: #editable ifAbsent: [ false ]
]

{ #category : #'*pier-model' }
MADescription >> isSearchable [
	^ self propertyAt: #searchable ifAbsent: [ false ]
]

{ #category : #'*pier-model' }
MADescription >> parameterName [
	^ self propertyAt: #parameterName ifAbsent: [ nil ]
]

{ #category : #'*pier-model' }
MADescription >> parameterName: aString [
	self propertyAt: #parameterName put: aString
]

{ #category : #'*pier-model' }
MADescription >> stringAccessor [
	^self propertyAt: #stringAccessor ifAbsent: [ self defaultStringAccessor ]
]

{ #category : #'*pier-model' }
MADescription >> stringAccessor: anAccessor [
	^self propertyAt: #stringAccessor put: anAccessor asAccessor
]
