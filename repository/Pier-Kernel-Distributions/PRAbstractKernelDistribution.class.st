Class {
	#name : #PRAbstractKernelDistribution,
	#superclass : #PRObject,
	#category : #'Pier-Kernel-Distributions'
}

{ #category : #testing }
PRAbstractKernelDistribution class >> isAbstract [
	^ true
]

{ #category : #accessing }
PRAbstractKernelDistribution class >> thumbnail [
	"thumbnails should be 260x180"
	"see http://twitter.github.com/bootstrap/components.html#thumbnails"
	^ PRKernelDistributionFileLibrary / #undefinedPng
]

{ #category : #creation }
PRAbstractKernelDistribution >> showCustomizeUIOn: calleeComponent thenAddRootToKernel:  theKernel [
	self subclassResponsibility
]
