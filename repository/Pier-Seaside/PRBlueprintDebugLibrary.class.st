Class {
	#name : #PRBlueprintDebugLibrary,
	#superclass : #WAFileLibrary,
	#category : #'Pier-Seaside-Libraries'
}

{ #category : #uploaded }
PRBlueprintDebugLibrary >> gridCss [
	^ '.container { background: url(grid.png); }'
]

{ #category : #uploaded }
PRBlueprintDebugLibrary >> gridPng [
	^ #(137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 40 0 0 0 18 8 6 0 0 0 41 31 156 166 0 0 0 4 115 66 73 84 8 8 8 8 124 8 100 136 0 0 0 9 112 72 89 115 0 0 10 240 0 0 10 240 1 66 172 52 152 0 0 0 28 116 69 88 116 83 111 102 116 119 97 114 101 0 65 100 111 98 101 32 70 105 114 101 119 111 114 107 115 32 67 83 51 152 214 70 3 0 0 0 72 73 68 65 84 72 137 99 124 241 254 247 127 134 1 0 226 2 44 68 169 99 162 177 59 40 6 163 14 164 20 140 58 144 82 48 234 64 74 193 168 3 41 5 163 14 164 20 140 58 144 82 48 234 64 74 193 160 119 32 11 227 175 119 3 98 241 171 87 196 169 3 0 78 179 7 223 243 172 62 238 0 0 0 0 73 69 78 68 174 66 96 130) asByteArray
]

{ #category : #accessing }
PRBlueprintDebugLibrary >> selectorsToInclude [
	^ #(gridCss)
]
