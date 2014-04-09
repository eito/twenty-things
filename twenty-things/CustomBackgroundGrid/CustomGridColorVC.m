//
//  CustomGridColorVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/11/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "CustomGridColorVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"


@interface CustomGridColorVC ()
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;

@end

@implementation CustomGridColorVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mapView addMapLayer:[AGSTiledMapServiceLayer streetsLayer]];
    
    // simple way to set the background grid for the map
    self.mapView.gridLineColor = [UIColor colorWithRed:204/255.0 green:189/255.0 blue:167/255.0 alpha:1.0];
    self.mapView.backgroundColor = [UIColor colorWithRed:228/255.0 green:220/255.0 blue:199/255.0 alpha:1.0];
 
   
    
    // zoom into the US
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-14405800.682625
                                                ymin:-1221611.989964
                                                xmax:-7030030.629509
                                                ymax:11870379.854318
                                    spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    [self.mapView zoomToEnvelope:env animated:YES];

}

@end
