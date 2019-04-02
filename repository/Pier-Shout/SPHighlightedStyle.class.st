Class {
	#name : #SPHighlightedStyle,
	#superclass : #WAFileLibrary,
	#category : #'Pier-Shout'
}

{ #category : #'style-sheets' }
SPHighlightedStyle >> codeCss [
	^ '.shout span.default {
	color: black;
}
.shout span.invalid {
	color: red;
}
.shout span.excessCode {
	color: red;
}
.shout span.comment {
	color: #007F00;
	font-style: italic;
}
.shout span.unfinishedComment {
	color: #7F0000;
	font-style: italic;
}
.shout span.character {
	color: #7F0000;
}
.shout span.integer {
	color: #7F0000;
}
.shout span.number {
	color: #7F0000;
}
.shout span.symbol {
	color: #00007F;
	font-weight: bold;
}
.shout span.stringSymbol {
	color: #00007F;
	font-weight: bold;
}
.shout span.literalArray {
	color: #00007F;
	font-weight: bold;
}
.shout span.string {
	color: #7F007F;
}
.shout span.unfinishedString {
	color: red;
}
.shout span.assignment {
	font-weight: bold;
}
.shout span.ansiAssignment {
	font-weight: bold;
}
.shout span.literal {
	font-weight: bold;
}
.shout span.keyword {
	color: #00007F;
}
.shout span.binary {
	color: #00007F;
}
.shout span.unary {
	color: #00007F;
}
.shout span.incompleteKeyword {
	color: #3F3F3F;
	text-decoration: underline;
}
.shout span.incompleteBinary {
	color: #3F3F3F;
	text-decoration: underline;
}
.shout span.incompleteUnary {
	color: #3F3F3F;
	text-decoration: underline;
}
.shout span.undefinedKeyword {
	color: red;
}
.shout span.undefinedBinary {
	color: red;
}
.shout span.undefinedUnary {
	color: red;
}
.shout span.patternKeyword {
	font-weight: bold;
}
.shout span.patternBinary {
	font-weight: bold;
}
.shout span.patternUnary {
	font-weight: bold;
}
.shout span.self {
	color: #7F0000;
	font-weight: bold;
}
.shout span.super {
	color: #7F0000;
	font-weight: bold;
}
.shout span.true {
	color: #7F0000;
	font-weight: bold;
}
.shout span.false {
	color: #7F0000;
	font-weight: bold;
}
.shout span.nil {
	color: #7F0000;
	font-weight: bold;
}
.shout span.thisContext {
	color: #7F0000;
	font-weight: bold;
}
.shout span.return {
	color: #7F0000;
	font-weight: bold;
}
.shout span.patternArg {
	color: #00007F;
	font-style: italic;
}
.shout span.methodArg {
	color: #00007F;
	font-style: italic;
}
.shout span.blockPatternArg {
	color: #00007F;
	font-style: italic;
}
.shout span.blockArg {
	color: #00007F;
	font-style: italic;
}
.shout span.argument {
	color: #00007F;
	font-style: italic;
}
.shout span.blockArgColon {
	color: black;
}
.shout span.leftParenthesis {
	color: black;
}
.shout span.rightParenthesis {
	color: black;
}
.shout span.leftParenthesis1 {
	color: #007F00;
}
.shout span.rightParenthesis1 {
	color: #007F00;
}
.shout span.leftParenthesis2 {
	color: #7F007F;
}
.shout span.rightParenthesis2 {
	color: #7F007F;
}
.shout span.leftParenthesis3 {
	color: #7F0000;
}
.shout span.rightParenthesis3 {
	color: #7F0000;
}
.shout span.leftParenthesis4 {
	color: #00EA00;
}
.shout span.rightParenthesis4 {
	color: #00EA00;
}
.shout span.leftParenthesis5 {
	color: #EA8C00;
}
.shout span.rightParenthesis5 {
	color: #EA8C00;
}
.shout span.leftParenthesis6 {
	color: #EA00EA;
}
.shout span.rightParenthesis6 {
	color: #EA00EA;
}
.shout span.leftParenthesis7 {
	color: blue;
}
.shout span.rightParenthesis7 {
	color: blue;
}
.shout span.blockStart {
	color: black;
}
.shout span.blockEnd {
	color: black;
}
.shout span.blockStart1 {
	color: #007F00;
}
.shout span.blockEnd1 {
	color: #007F00;
}
.shout span.blockStart2 {
	color: #7F007F;
}
.shout span.blockEnd2 {
	color: #7F007F;
}
.shout span.blockStart3 {
	color: #7F0000;
}
.shout span.blockEnd3 {
	color: #7F0000;
}
.shout span.blockStart4 {
	color: #00EA00;
}
.shout span.blockEnd4 {
	color: #00EA00;
}
.shout span.blockStart5 {
	color: #EA8C00;
}
.shout span.blockEnd5 {
	color: #EA8C00;
}
.shout span.blockStart6 {
	color: #EA00EA;
}
.shout span.blockEnd6 {
	color: #EA00EA;
}
.shout span.blockStart7 {
	color: blue;
}
.shout span.blockEnd7 {
	color: blue;
}
.shout span.arrayStart {
	color: black;
}
.shout span.arrayEnd {
	color: black;
}
.shout span.arrayStart1 {
	color: black;
}
.shout span.arrayEnd1 {
	color: black;
}
.shout span.leftBrace {
	color: black;
}
.shout span.rightBrace {
	color: black;
}
.shout span.cascadeSeparator {
	color: black;
}
.shout span.statementSeparator {
	color: black;
}
.shout span.externalCallType {
	color: black;
}
.shout span.externalCallTypePointerIndicator {
	color: black;
}
.shout span.primitiveOrExternalCallStart {
	color: black;
	font-weight: bold;
}
.shout span.primitiveOrExternalCallEnd {
	color: black;
	font-weight: bold;
}
.shout span.methodTempBar {
	color: #7F7F7F;
}
.shout span.blockTempBar {
	color: #7F7F7F;
}
.shout span.blockArgsBar {
	color: #7F7F7F;
}
.shout span.primitive {
	color: #007F00;
	font-weight: bold;
}
.shout span.pragmaKeyword {
	color: #007F00;
	font-weight: bold;
}
.shout span.pragmaUnary {
	color: #007F00;
	font-weight: bold;
}
.shout span.pragmaBinary {
	color: #007F00;
	font-weight: bold;
}
.shout span.externalFunctionCallingConvention {
	color: #007F00;
	font-weight: bold;
}
.shout span.module {
	color: #007F00;
	font-weight: bold;
}
.shout span.blockTempVar {
	color: #7F7F7F;
	font-style: italic;
}
.shout span.blockPatternTempVar {
	color: #7F7F7F;
	font-style: italic;
}
.shout span.instVar {
	color: black;
	font-weight: bold;
}
.shout span.workspaceVar {
	color: black;
	font-weight: bold;
}
.shout span.undefinedIdentifier {
	color: red;
	font-weight: bold;
}
.shout span.incompleteIdentifier {
	color: #6B6B6B;
	font-style: italic;
	text-decoration: underline;
}
.shout span.tempVar {
	color: #6B6B6B;
	font-style: italic;
}
.shout span.patternTempVar {
	color: #6B6B6B;
	font-style: italic;
}
.shout span.poolConstant {
	color: #6B6B6B;
	font-style: italic;
}
.shout span.classVar {
	color: #6B6B6B;
	font-weight: bold
}
.shout span.globalVar {
	color: black;
	font-weight: bold
}'
]

{ #category : #accessing }
SPHighlightedStyle >> selectorsToInclude [
	^#(codeCss)
]
