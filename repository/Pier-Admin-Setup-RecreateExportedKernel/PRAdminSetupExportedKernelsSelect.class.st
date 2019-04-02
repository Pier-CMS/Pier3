Class {
	#name : #PRAdminSetupExportedKernelsSelect,
	#superclass : #MASelectListComponent,
	#category : #'Pier-Admin-Setup-RecreateExportedKernel'
}

{ #category : #rendering }
PRAdminSetupExportedKernelsSelect >> renderEditorOn: html [
	| notificationId callbackExportedKernelClass |
	notificationId := html nextId.
	
	"valueholder for Gemstone 2.4.* compatibility see:
	- http://code.google.com/p/glassdb/issues/detail?id=221
	- http://forum.world.st/use-of-method-temporaries-in-callback-blocks-td2340788.html"
	callbackExportedKernelClass := WAValueHolder new. 

	html select
		onChange: (html jQuery ajax callback: [ :val | callbackExportedKernelClass contents: (self options at: (val greaseInteger)) ] value: (html jQuery this value); 
			script: [ :s | s << (s jQuery id: notificationId) html: [ :r | self renderExportedKernelClass: callbackExportedKernelClass contents on: r ] ]);
		list: self options;
		selected: self value;
		callback: [ :value | self value: value ];
		labels: [ :value | self labelForOption: value ].
		
	html div
		id: notificationId;
		with: [ 
			self renderExportedKernelClass: self value on: html ]
]

{ #category : #rendering }
PRAdminSetupExportedKernelsSelect >> renderExportedKernelClass: class on: html [
	| exportedKernelCreator |
	class isNil ifTrue: [ ^ self ].
	
	exportedKernelCreator := class new.

	html div: [
		html text: 'kernel name: ('; strong: exportedKernelCreator kernelName; text: ')' ].
	html div: [
		html text: 'path: ('; strong: '/'; strong: exportedKernelCreator dispatcherPathName; text: ')' ]

]
