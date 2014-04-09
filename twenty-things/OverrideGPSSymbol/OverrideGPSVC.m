//
//  OverrideGPSVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/7/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "OverrideGPSVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"

@interface OverrideGPSVC ()
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
- (IBAction)startStopAction:(UIBarButtonItem*)sender;

@end

@implementation OverrideGPSVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Override GPS";
    
    [self.mapView addMapLayer:[AGSTiledMapServiceLayer lightGrayLayer]];

    // set the location display properties so we can override symbols
    self.mapView.locationDisplay.defaultSymbol = [self defaultSymbolOverride];
    self.mapView.locationDisplay.accuracySymbol = [self accuracySymbolOverride];
    self.mapView.locationDisplay.pingSymbol = [self pingSymbolOverride];
    self.mapView.locationDisplay.headingSymbol = [self headingSymbolOverride];
    self.mapView.locationDisplay.courseSymbol = [self courseSymbolOverride];
}

- (IBAction)startStopAction:(UIBarButtonItem*)sender {
    if (self.mapView.locationDisplay.isDataSourceStarted) {
        sender.title = @"Start GPS";
        [self.mapView.locationDisplay stopDataSource];
    }
    else {
        sender.title = @"Stop GPS";
        [self.mapView.locationDisplay startDataSource];
        self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
    }
}

- (AGSMarkerSymbol*)defaultSymbolOverride {
    AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor orangeColor]];
    sms.outline = nil;
    return sms;
}

- (AGSSimpleFillSymbol*)accuracySymbolOverride {
    UIColor *innerColor = [[UIColor greenColor] colorWithAlphaComponent:0.35];
    UIColor *outerColor = [UIColor greenColor];
    AGSSimpleFillSymbol *sfs = [AGSSimpleFillSymbol simpleFillSymbolWithColor:innerColor
                                                                 outlineColor:outerColor];
    return sfs;
}

- (AGSMarkerSymbol*)pingSymbolOverride {
    AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor yellowColor]];
    return sms;
}

- (AGSMarkerSymbol*)headingSymbolOverride {
    return [self defaultSymbolOverride];
}

- (AGSMarkerSymbol*)courseSymbolOverride {
    return [self defaultSymbolOverride];
}
@end
