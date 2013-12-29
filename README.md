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

Instructions
============
* Click the + button to add several records to the screen.
* Click on one of the records to initiate the custom transition animation.
** The screen will split in the middle and both “shutters” will move offscreen in the opposite direction.
** The detail view will scale and fade into place.
* Press the back button or pinch and close to navigate back to the main screen. 
** A pinch and close will institute a custom closing animation.
** The detail screen will begin to scale and fade out as the two “shutters” from earlier are moved back on to the screen.