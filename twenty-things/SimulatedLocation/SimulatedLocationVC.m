//
//  SimulatedLocationVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/6/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "SimulatedLocationVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"

@interface SimulatedLocationVC ()
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;

// called when user clicks the "Start/Stop" button
- (IBAction)startSimulation:(id)sender;
- (IBAction)stopSimulation:(id)sender;

@end

@implementation SimulatedLocationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mapView addMapLayer:[AGSTiledMapServiceLayer imageryLayer]];
    
}

- (IBAction)startSimulation:(id)sender {
    
    // get the path to our GPX file
    NSString *gpxPath = [[NSBundle mainBundle] pathForResource:@"toughmudder2012" ofType:@"gpx"];
    
    // create our data source
    AGSGPXLocationDisplayDataSource *gpxLDS = [[AGSGPXLocationDisplayDataSource alloc] initWithPath:gpxPath];
    
    // tell the AGSLocationDisplay to use our data source
    self.mapView.locationDisplay.dataSource = gpxLDS;
    
    // enter nav mode so we can play it back oriented in the same way we would be if it
    // were happening "live"
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeNavigation;
    
    // we have to start the datasource in order to play it back
    [self.mapView.locationDisplay startDataSource];
}

- (IBAction)stopSimulation:(id)sender {
    [self.mapView.locationDisplay stopDataSource];
}

@end
