Extension { #name : #PRValueLink }

{ #category : #'*pier-jquery' }
PRValueLink >> jqAccordionIn: aContext [
	<value: 'jq-accordion' comment: 'Display children of the current structure as an accordion.'>
	
	^ self lookupStructure: aContext structure do: [ :structure | [ :html |
		html div
			script: (html jQuery new accordion);
			with: [
				(aContext enumeratorFor: structure) do: [ :child |
					html div: child menu.
					html div: [
						html rendererInstance 
							visit: child ] ] ] ] ]
]

{ #category : #'*pier-jquery' }
PRValueLink >> jqDialogIn: aContext [
	<value: 'jq-dialog' comment: 'Display the structure within a modal dialog.'>
	
	^ self lookupStructure: aContext structure do: [ :structure | [ :html |
		| id |
		html span
			id: (id := html nextId);
			script: (html jQuery new dialog
				html: [ :renderer | 
					html rendererInstance 
						renderer: renderer;
						visit: structure ];
				title: structure title;
				modal: true).
		html anchor
			goto: (aContext structure: structure);
			onClick: ((html jQuery id: id) dialog open return: false);
			with: (self formatDescribed: structure default: #title) ] ]
]

{ #category : #'*pier-jquery' }
PRValueLink >> jqTabsIn: aContext [
	<value: 'jq-tabs' comment: 'Display children of the current structure as a tabbed widget.'>
	
	^ self lookupStructure: aContext structure do: [ :structure | [ :html |
		html div
			script: (html jQuery new tabs
				selected: (self propertyAt: 'selected' ifAbsent: [ 0 ]);
				yourself);
			with: [
				html unorderedList: [
					(aContext enumeratorFor: structure) do: [ :child |
						html listItem: [
							html anchor
								url: (html jQuery ajax
									html: [ :renderer | 
										html rendererInstance 
											renderer: renderer;
											visit: child ];
									fullUrl);
								with: child menu ] ] ] ] ] ]
]
