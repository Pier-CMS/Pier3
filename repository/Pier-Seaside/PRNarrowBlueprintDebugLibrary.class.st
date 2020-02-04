Class {
	#name : #PRNarrowBlueprintDebugLibrary,
	#superclass : #WAFileLibrary,
	#category : #'Pier-Seaside-Libraries'
}

{ #category : #uploaded }
PRNarrowBlueprintDebugLibrary >> gridCss [
	^ '.container { background: url(grid.png); }'
]

{ #category : #uploaded }
PRNarrowBlueprintDebugLibrary >> gridPng [
	^ #(137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 30 0 0 0 18 2 3 0 0 0 49 156 134 74 0 0 0 9 80 76 84 69 255 255 255 243 245 247 230 230 236 122 197 101 242 0 0 0 20 73 68 65 84 8 153 99 8 5 1 6 32 24 108 140 85 16 176 0 0 176 102 33 128 242 86 90 33 0 0 0 0 73 69 78 68 174 66 96 130) asByteArray
]

{ #category : #accessing }
PRNarrowBlueprintDebugLibrary >> selectorsToInclude [
	^ #(gridCss)
]
