Class {
	#name : #PRAdminSetupOverlaySupportBase,
	#superclass : #WAComponent,
	#category : #'Pier-Admin-Setup-Core'
}

{ #category : #rendering }
PRAdminSetupOverlaySupportBase >> renderOverlayWithMessage: message containerId: containerId on: html [
	| overlayId |
	overlayId := containerId, '-overlay'.
	
	"display and create the overlay if the container is visible and hasn't already been created"
	html document addLoadScript: 
		((((html jQuery: containerId) is: ':visible') & (((html jQuery id: overlayId) size) not) then: 
			(((html jQuery: containerId) append: [ :r |
				r div
					id: overlayId;
					class: 'setupAdminOverlayBase';
					script: (r jQuery this clonePosition: (r jQuery id: containerId));
					with: [
						r div
							class: 'alert';
							class: 'alert-error';
							class: 'setupAdminOverlayMessage';
							with: message ] ]))) asFunction assignLocalTo: containerId).
			
	html document addLoadScript: ((html jQuery: 'a[data-toggle="tab"]') on: 'shown' do: (JSStream on: containerId, '()')).
	html document addLoadScript: (JSStream on: containerId, '()')
]
