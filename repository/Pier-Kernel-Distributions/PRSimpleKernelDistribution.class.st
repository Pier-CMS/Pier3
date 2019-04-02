Class {
	#name : #PRSimpleKernelDistribution,
	#superclass : #PRAbstractKernelDistribution,
	#category : #'Pier-Kernel-Distributions'
}

{ #category : #testing }
PRSimpleKernelDistribution class >> isAbstract [ 
	^ false
]

{ #category : #accessing }
PRSimpleKernelDistribution class >> label [
	^ 'Simple Template'
]

{ #category : #accessing }
PRSimpleKernelDistribution class >> thumbnail [
	^ PRKernelDistributionFileLibrary / #simpleKernelPng

]

{ #category : #creation }
PRSimpleKernelDistribution >> showCustomizeUIOn: calleeComponent thenAddRootToKernel:  theKernel [
	"no customization to be performed - simply add PRKernel's #defaultRoot"
	theKernel root: PRKernel defaultRoot.
	^ theKernel

	
]
