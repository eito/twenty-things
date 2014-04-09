//
//  AppDelegate.h
//  twenty-things
//
//  Created by Eric Ito on 3/6/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end


/*
X - 1. Coordinate Conversion
 (DMS —> AGSPoint, AGSPoint —> DMS)
 
 ACTION:
 a. use default DMS show the pin map to that point,
 b. Change east to west, enter again see point move
 c. Click a point on the map, see text change and pin drop
 d. show code (AGSPoint  methods)
 
X - 2. Simulated Location (GPX)
 - mention you can set an array of AGSLocation objects (hold CLLocation), will calculate course for your and if there is any speed associated with the point it will use the course gps symbol
 - mention this is good for demo purposes or to test
 
 ACTION:
 a. run test and start simulation…note nav mode
 b. show code.. instantiate location display data source
 
 3.  Custom dynamic layer..pulling earthquakes for this month
 
 ACTION:
 a. click on a state in different spots and note point placed in middle
 b. show code for this
 
X - 4. Override GPS Symbol on AGSLocationDisplay
 - set symbols for GPS, course, heading, etc
 - show header for this
 
 ACTION:
 a. start app, click “start simulation”
 b. show code for creating data source
 
 
X - 5. Geodesic operations (flight path, tap A, tap B, GO!)
 - run once with boring symbol
X - 6. Create nice looking line symbols using composite symbols
 
 ACTION:
 a. start app tap point in US, point in Europe GO
 b. show code...
 c. mention symbol looks blah, uncomment code for composite symbol
 d. re-run pick point in south america then europe GO
 
X - 7. OAuth Login
 - connect to a portal, query org thumbnail
X - 8. Store credential in keychain with AGSKeychainItemWrapper
 
 ACTION:
 a. run app, see OAuth login with my app details, log in, connect to portal and query org thumbnail from portal info (show "Logged in as  <user> to <org name>")
 b. store credential in keychain and attempt to login if we already have one saved
 c. uncomment code for that, show it, re-run and see login happens automatically
 
 
X - 9. AGSCredentialCache (This one builds on the last one…may make it all one demo)
X - 10. Status enumerations to string methods
X - 11. Resume Download (bg fetch, bg download, progress, etc)
X - 12. Override min/max scale on map after loading TPK
 
 ACTION:
 a. show status block that converts job status to a readable string
 b. show part that displays progress when job is fetching the result
 c. kickoff a download of palm springs convention center area
 d. kill app (user-killed)
 e. show code for using resumeID
 f. go back in and note job resumes
 g. background app
 h. simulate background fetch (show UI updates in app switcher)
 i. show project file settings enabling background fetch
 j. show code in AppDelegate.m for handling bg fetch, bg downloads
 k. When TPK downloads, load TPK and note that minScale is capped, can’t zoom out… set minScale to 100k and relaunch, now can zoom out
 
X - 13. AGSGraphicsLayer rendering modes
 - generate 500 random points
 
 ACTION:
 a. run in static mode, note redraw
 b. show code, change to dynamic mode, note how symbols resize
 
X - 14. Custom background grid on map view
 - mention this is a way to affect perception when tiles haven’t been retrieved yet
 - set to something that matches primary color of base map
X - 15. Prefetch neighboring tiles (factor, 1-2)
 -warn uses more memory
 
 ACTION:
 a. show code for bg grid, run and pan to show the color, note we have lots of cases where tiles are not there yet
 b. change tile layer factor to 1.2 and re-run, note tiles are there already when panning
 
X - 16. Set max envelope on map to restrict area.
 - open portal item breweries in california
 
 ACTION:
 a. open portal item note you can pan/zoom anywhere
 b. show code to restrict to some extent
 c. re-run and note can’t zoom out or pan away from extent
 
X - 17. AGSRequestOperation
 - show block handlers for completion, progress
 - show output file
 - show UI with progress updating (bytesDownloaded/bytesExpected)
 
 ACTION:
 a. show code for setting output path, progress blocks
 b. download test file from ISP (10MB if we can)
 
X - 18. AGSGraphic/AGSGDBFeature KVC
X - 19. rotation renderer
X - 20. custom callout view with leader positions
 
 ACTION:
 a. show code for creating graphics and setting attributes with a[@“attr”] = b
 b. show code for rotation renderer
 c. run app and note symbols are rotated differently based on some field
 d. show code for custom callout
 e. run app and note callout displayed…
 f. show code for setting leader positions so map never pans
 g. re-run and click features
*/