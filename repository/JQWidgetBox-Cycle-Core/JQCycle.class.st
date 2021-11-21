Class {
	#name : #JQCycle,
	#superclass : #JQWidget,
	#category : #'JQWidgetBox-Cycle-Core'
}

{ #category : #options }
JQCycle >> activePagerClass: aString [
	"default: 'activeSlide'
	 class name used for the active pager link " 

	self optionAt: 'activePagerClass' put: aString
]

{ #category : #options }
JQCycle >> after: aCallback [
	"default: null
	 transition callback (scope set to element to be shown):
	     function(currSlideElement, nextSlideElement, options, forwardFlag) "

	self optionAt: 'after' put: (aCallback asFunction: #('currSlideElement' 'nextSlideElement' 'options' 'forwardFlag'))
]

{ #category : #options }
JQCycle >> animIn: aString [
	"default: null
	 properties that define how the slide animates in" 

	self optionAt: 'animIn' put: aString
]

{ #category : #options }
JQCycle >> animOut: aString [
	"default: null
	 properties that define how the slide animates out" 

	self optionAt: 'animOut' put: aString
]

{ #category : #options }
JQCycle >> autostop: aBoolean [
	"default: 0
	  true to end slideshow after X transitions (where X == slide count)  " 

	self optionAt: 'autostop' put: aBoolean
]

{ #category : #options }
JQCycle >> autostopCount: anInteger [
	"default: 0
	 number of transitions (optionally used with autostop to define X) " 

	self optionAt: 'autostopCount' put: anInteger
]

{ #category : #options }
JQCycle >> before: aCallback [
	"default: null
	 transition callback (scope set to element to be shown):
	     function(currSlideElement, nextSlideElement, options, forwardFlag) "

	self optionAt: 'before' put: (aCallback asFunction: #('currSlideElement' 'nextSlideElement' 'options' 'forwardFlag'))
]

{ #category : #options }
JQCycle >> cleartype: aBoolean [
	"default: !$.support.opacity
	true if clearType corrections should be applied (for IE)" 

	self optionAt: 'cleartype' put: aBoolean
]

{ #category : #options }
JQCycle >> cleartypeNoBg: aBoolean [
	"default: false
	set to true to disable extra cleartype fixing (leave false to force background color setting on slides) " 

	self optionAt: 'cleartypeNoBg' put: aBoolean
]

{ #category : #options }
JQCycle >> containerResize: aBoolean [
	"default: 1
	 resize container to fit largest slide " 

	self optionAt: 'containerResize' put: aBoolean
]

{ #category : #options }
JQCycle >> continuous: aBoolean [
	"default: 0
	 true to start next transition immediately after current one completes"

	self optionAt: 'continuous' put: aBoolean
]

{ #category : #options }
JQCycle >> cssAfter: aString [
	"default: null
	properties that define the initial state of the slide after transitioning out" 

	self optionAt: 'cssAfter' put: aString
]

{ #category : #options }
JQCycle >> cssBefore: aString [
	"default: null
	properties that define the initial state of the slide before transitioning in" 

	self optionAt: 'cssBefore' put: aString
]

{ #category : #options }
JQCycle >> delay: anInteger [
	"default: 0
	additional delay (in ms) for first transition (hint: can be negative)" 

	self optionAt: 'delay' put: anInteger
]

{ #category : #options }
JQCycle >> easeIn: aString [
	"default: null
	 easing method for 'in' transitions" 

	self optionAt: 'easeIn' put: aString
]

{ #category : #options }
JQCycle >> easeOut: aString [
	"default: null
	 easing method for 'out' transitions" 

	self optionAt: 'easeOut' put: aString
]

{ #category : #options }
JQCycle >> easing: aString [
	"default: null
	 easing method for both in and out transitions" 

	self optionAt: 'easing' put: aString
]

{ #category : #options }
JQCycle >> end: aCallback [
	"default: null
	 callback invoked when the slideshow terminates (use with autostop or nowrap options): 
		function(options)" 

	self optionAt: 'end' put: aCallback.(aCallback asFunction: #('options'))
]

{ #category : #options }
JQCycle >> fastOnEvent: anInteger [
	"default: 0
	force fast transitions when triggered manually (via pager or prev/next); value == time in ms " 

	self optionAt: 'fastOnEvent' put: anInteger
]

{ #category : #options }
JQCycle >> fit: aBoolean [
	"default: 0
	 force slides to fit container " 

	self optionAt: 'fit' put: aBoolean
]

{ #category : #options }
JQCycle >> fx: aString [
	"default: 'fade'
	name of transition effort (or comma separated names, ex: fade,scrollUp,shuffle) 
	options available (see: http://malsup.com/jquery/cycle/browser.html)
		blindX
		blindY
		blindZ
		cover
		curtainX
		curtainY
		fade
		fadeZoom
		growX
		growY
		none
		scrollUp
		scrollDown
		scrollLeft
		scrollRight
		scrollHorz
		scrollVert
		shuffle
		slideX
		slideY
		toss
		turnUp
		turnDown
		turnLeft
		turnRight
		uncover
		wipe
		zoom
		"
	self optionAt: 'fx' put: aString
]

{ #category : #options }
JQCycle >> fxFn: aCallback [
	"default: null
	function used to control the transition: 
		function(currSlideElement, nextSlideElement, options, afterCalback, forwardFlag) " 

	self optionAt: 'fxFn' put: (aCallback asFunction: #('currSlideElement' 'nextSlideElement' 'options' 'afterCallback' 'forwardFlag'))
]

{ #category : #options }
JQCycle >> height: aString [
	"default: 'auto'
	container height" 

	self optionAt: 'height' put: aString
]

{ #category : #options }
JQCycle >> manualTrump: aBoolean [
	"default: true
	 causes manual transition to stop an active transition instead of being ignored" 

	self optionAt: 'manualTrump' put: aBoolean
]

{ #category : #accessing }
JQCycle >> method [
	^'cycle'
]

{ #category : #options }
JQCycle >> next: aJQuery [
	"default: null
	 selector for element to use as click trigger for next slide"

	self optionAt: 'next' put: aJQuery
]

{ #category : #options }
JQCycle >> nowrap: aBoolean [
	"default: 0
	true to prevent slideshow from wrapping  " 

	self optionAt: 'nowrap' put: aBoolean
]

{ #category : #options }
JQCycle >> pager: aJQuery [
	"default: null
	 selector for element to use as pager container"

	self optionAt: 'pager' put: aJQuery
]

{ #category : #options }
JQCycle >> pagerAnchorBuilder: aCallback [
	"default: null
	callback fn for building anchor links:  
		function(index, slide)"

	self optionAt: 'pagerAnchorBuilder' put: (aCallback asFunction: #('index' 'slide'))
]

{ #category : #options }
JQCycle >> pagerClick: aCallback [
	"default: null
	callback fn for pager clicks: 
	 	function(zeroBasedSlideIndex, slideElement)"

	self optionAt: 'pagerClick' put: (aCallback asFunction: #('zeroBasedSlideIndex' 'slideElement'))
]

{ #category : #options }
JQCycle >> pagerEvent: aString [
	"default: 'click'
	name of event which drives the pager navigation"

	self optionAt: 'pagerEvent' put: aString
]

{ #category : #options }
JQCycle >> pause: aBoolean [
	"default: 0
	  true to enable pause on hover " 

	self optionAt: 'pause' put: aBoolean
]

{ #category : #options }
JQCycle >> pauseOnPagerHover: aBoolean [
	"default: 0
	  true to pause when hovering over pager link " 

	self optionAt: 'pauseOnPagerHover' put: aBoolean
]

{ #category : #options }
JQCycle >> prev: aJQuery [
	"default: null
	 selector for element to use as click trigger for previous slide"

	self optionAt: 'prev' put: aJQuery
]

{ #category : #options }
JQCycle >> prevNextClick: aCallback [
	"default: null
	 callback fn for prev/next clicks:  function(isNext, zeroBasedSlideIndex, slideElement) "

	self optionAt: 'prevNextClick' put: (aCallback asFunction: #('isNext' 'zeroBasedSlideIndex' 'slideElement'))
]

{ #category : #options }
JQCycle >> random: aBoolean [
	"default: 0
	 true for random, false for sequence (not applicable to shuffle fx)" 

	self optionAt: 'random' put: aBoolean
]

{ #category : #options }
JQCycle >> randomizeEffects: aBoolean [
	"default: 1
	 valid when multiple effects are used; true to make the effect sequence random" 

	self optionAt: 'randomizeEffects' put: aBoolean
]

{ #category : #options }
JQCycle >> requeueOnImageNotLoaded: aBoolean [
	"default: true
	 requeue the slideshow if any image slides are not yet loaded " 

	self optionAt: 'requeueOnImageNotLoaded' put: aBoolean
]

{ #category : #options }
JQCycle >> requeueTimeout: anInteger [
	"default: 250 (ms)
	 requeue the slideshow if any image slides are not yet loaded " 

	self optionAt: 'requeueTimeout' put: anInteger
]

{ #category : #options }
JQCycle >> rev: aBoolean [
	"default: 0
	 causes animations to transition in reverse" 

	self optionAt: 'rev' put: aBoolean
]

{ #category : #options }
JQCycle >> setSlide: slideIndex [
	self action: nil arguments: (Array with: slideIndex)
]

{ #category : #options }
JQCycle >> shuffle: aJSObject [
	"default: null
	 coords for shuffle animation, ex: { top:15, left: 200 }" 

	self optionAt: 'shuffle' put: aJSObject
]

{ #category : #options }
JQCycle >> slideExpr: aJQuery [
	"default: null
	expression for selecting slides (if something other than all children is required) " 

	self optionAt: 'slideExpr' put: aJQuery
]

{ #category : #options }
JQCycle >> speed: aString [
	"default: 1000
	 speed of the transition (any valid fx speed value eg 'fast')"

	self optionAt: 'speed' put: aString
]

{ #category : #options }
JQCycle >> speedIn: anInteger [
	"default: null
	 speed of the 'in' transition"

	self optionAt: 'speedIn' put: anInteger
]

{ #category : #options }
JQCycle >> speedOut: anInteger [
	"default: null
	 speed of the 'out' transition"

	self optionAt: 'speedOut' put: anInteger
]

{ #category : #options }
JQCycle >> startingSlide: anInteger [
	"default: 0
	zero-based index of the first slide to be displayed" 

	self optionAt: 'startingSlide' put: anInteger
]

{ #category : #options }
JQCycle >> sync: aBoolean [
	"default: 1
	 true if in/out transitions should occur simultaneously" 

	self optionAt: 'sync' put: aBoolean
]

{ #category : #options }
JQCycle >> timeout: aNumber [
	"default: 4000
		milliseconds between slide transitions (0 to disable auto advance)"

	self optionAt: 'timeout' put: aNumber
]

{ #category : #options }
JQCycle >> timeoutFn: aCallback [
	"default: null
	 callback for determining per-slide timeout value:  
		function(currSlideElement, nextSlideElement, options, forwardFlag)"

	self optionAt: 'timeoutFn' put: (aCallback asFunction: #('currSlideElement' 'nextSlideElement' 'options' 'forwardFlag'))
]

{ #category : #options }
JQCycle >> updateActivePagerLink: aCallback [
	"default: null
	 callback fn invoked to update the active pager link (adds/removes activePagerClass style) 
		function(pager, currSlide, clsName)" 

	self optionAt: 'updateActivePagerLink' put:  (aCallback asFunction: #('pager' 'currSlide' 'clsName'))
]
