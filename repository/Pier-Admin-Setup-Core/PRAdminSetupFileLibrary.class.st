Class {
	#name : #PRAdminSetupFileLibrary,
	#superclass : #WAFileLibrary,
	#category : #'Pier-Admin-Setup-Core'
}

{ #category : #uploaded }
PRAdminSetupFileLibrary >> jqCloneJs [
   ^ '/**
 * Copyright (c) 2009  Gary Haran => gary@talkerapp.com
 * Released under MIT license [...]
 */
(function($){
  $.fn.clonePosition = function(element, options){
    var options = $.extend({
      cloneWidth: true,
      cloneHeight: true,
      offsetLeft: 0,
      offsetTop: 0
    }, (options || {}));
    
    var offsets = $(element).offset();
    
    $(this).css({
      position: ''absolute'',
      top:  (offsets.top  + options.offsetTop)  + ''px'',
      left: (offsets.left + options.offsetLeft) + ''px''
    });
    
    if (options.cloneWidth)  $(this).width($(element).width());
    if (options.cloneHeight) $(this).height($(element).height());
    
    return this;
  }
})(jQuery);'
]

{ #category : #uploaded }
PRAdminSetupFileLibrary >> piersetupCss [
	^ '
.setupAdminOverlayBase {
	z-index:8; 
	background:white; 
	opacity:0.9;
}

.setupAdminOverlayMessage {
	margin-top: 25px;
}

.setupAdminPierTitle img {
	position: relative;
	top: 8px;
}

#adminSetupContent select,  #adminSetupContent input[type="text"] {
	width: 360px;
}

a.thumbnail.selected {
  border-color: #CC3D00;
  -webkit-box-shadow: 0 1px 4px rgba(214, 54, 0, 0.25);
  -moz-box-shadow: 0 1px 4px rgba(214, 54, 0, 0.25);
  box-shadow: 0 1px 4px rgba(215, 54, 0, 0.25);
}

.thumbnailChooser {
	margin-top: 10px;
	display: block;
}
'
]

{ #category : #accessing }
PRAdminSetupFileLibrary >> selectorsToInclude [
	^ #( jqCloneJs piersetupCss )
]
