Class {
	#name : #PRAdminSetupThumbnailChooser,
	#superclass : #MASingleSelectionComponent,
	#category : #'Pier-Admin-Setup-Core'
}

{ #category : #testing }
PRAdminSetupThumbnailChooser class >> isAbstract [
	^ false
]

{ #category : #rendering }
PRAdminSetupThumbnailChooser >> renderViewerOn: html [
	html hiddenInput
		id: self labelId;
		value: (self options indexOf: self value);
		callback: [ :val | self value: (self options at: val greaseInteger) ].

	html unorderedList
		class: 'thumbnails';
		id: #thumbnails;
		with: [ 
			self options doWithIndex: [ :each :index  |
				html listItem
					class: 'span3';
					with: [
						html anchor 
							class: 'thumbnail';
							class: 'selected' if: (each = self value);
							onClick: (((html jQuery: #thumbnails) find: 'a.thumbnail') removeClass: 'selected');
							onClick: (html jQuery this addClass: 'selected');
							onClick: ((html jQuery id: self labelId) value: index; trigger: 'change');
							with: [
								html image url: each thumbnail; width: 260; height: 180.
								html div class: 'caption'; with: [
									html heading level5; with: each label ] ] ] ] ]
]
