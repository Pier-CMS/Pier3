Extension { #name : #PRViewCommand }

{ #category : #'*pier-seaside-accessing' }
PRViewCommand >> defaultViewComponentClass [
	^ self context structure viewComponentClass
]

{ #category : #'*pier-seaside-accessing' }
PRViewCommand >> label [
	^ self viewComponent label
]

{ #category : #'*pier-seaside-accessing' }
PRViewCommand >> rendererInstance [
	^ self viewComponent rendererInstance
]

{ #category : #'*pier-seaside-accessing' }
PRViewCommand >> robots [
	^ self viewComponent robots
]

{ #category : #'*pier-seaside-accessing' }
PRViewCommand >> viewComponent [
	^ self propertyAt: #viewComponent ifAbsentPut: [ self viewComponentClass on: self context ]
]

{ #category : #'*pier-seaside-accessing' }
PRViewCommand >> viewComponent: aViewComponent [
	self propertyAt: #viewComponent put: aViewComponent
]

{ #category : #'*pier-seaside-accessing' }
PRViewCommand >> viewComponentClass [
	^ self propertyAt: #viewComponentClass ifAbsentPut: [ self defaultViewComponentClass ]
]

{ #category : #'*pier-seaside-accessing' }
PRViewCommand >> viewComponentClass: aClass [
	self propertyAt: #viewComponentClass put: aClass
]
