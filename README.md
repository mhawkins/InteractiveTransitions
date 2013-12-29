InteractiveTransitions
======================

An exploration of custom, interactive transitions.

Synopsis
========
This project contains two classes that allow for interactive, custom UINavigationController transitions.

Files
=====

* GCNavigationControllerDelegate - this delegate tells the nav controller which animations to use and if a custom transition is available
* GCControllerAnimatedTransitioningObject - handles caching the views on screen to disk, creating two shutter views, and then animating them opening or closing based upon direction of navigation.
* GCPinchInteractiveTransitionObject - handles the pinch to close feature
