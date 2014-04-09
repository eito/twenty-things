//
//  CustomDynamicLayerVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/12/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "CustomDynamicLayerVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"
#import "USGSQuakeHeatMapLayer.h"

@interface CustomDynamicLayerVC ()
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;
@property (nonatomic, strong) USGSQuakeHeatMapLayer *heatMapLayer;

@end

@implementation CustomDynamicLayerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mapView addMapLayer:[AGSTiledMapServiceLayer lightGrayLayer]];
    
    // create and add our heat map layer
    [self addHeatMapLayer];
}

-(void)addHeatMapLayer {
    self.heatMapLayer = [[USGSQuakeHeatMapLayer alloc] init];
    
    // setting render native resolution so the image callbacks honor screen scale
    // when requesting images... ie iphone 4 retina should be 640x960 not 320x480 (or equivalent)
    self.heatMapLayer.renderNativeResolution = YES;
    
    // add layer to our map
    [self.mapView addMapLayer:self.heatMapLayer];
    
    // call load to go out and fetch the JSON data
    [self.heatMapLayer loadWithCompletion:^{
        NSLog(@"done adding heat map layer");
    }];
}

@end
