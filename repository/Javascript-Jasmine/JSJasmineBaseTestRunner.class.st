Class {
	#name : #JSJasmineBaseTestRunner,
	#superclass : #WAComponent,
	#category : #'Javascript-Jasmine'
}

{ #category : #tests }
JSJasmineBaseTestRunner >> testsToRun [
	self subclassResponsibility 
	
	

]

{ #category : #updating }
JSJasmineBaseTestRunner >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	anHtmlRoot title: 'Jasmine Spec Runner'.
	anHtmlRoot link beShortcutIcon; url: JSJasmineLibrary / #jasminefaviconPng.
	JSJasmineLibrary default updateRoot: anHtmlRoot.
	
	anHtmlRoot javascript add: self testsToRun.
	
	anHtmlRoot javascript url: JSJasmineLibrary / #standardRunnerJs
	
	

]
