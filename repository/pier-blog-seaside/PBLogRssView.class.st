Class {
	#name : 'PBLogRssView',
	#superclass : 'PBHistoryRssView',
	#category : 'pier-blog-seaside',
	#package : 'pier-blog-seaside'
}

{ #category : 'testing' }
PBLogRssView class >> isAbstract [
	^ false
]

{ #category : 'accessing' }
PBLogRssView class >> label [
	^ 'Log (RSS)'
]
