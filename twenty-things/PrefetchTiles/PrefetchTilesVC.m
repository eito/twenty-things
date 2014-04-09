//
//  PrefetchTilesVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/11/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "PrefetchTilesVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"

@interface PrefetchTilesVC ()
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;

@end

@implementation PrefetchTilesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AGSTiledMapServiceLayer *tmsl = [AGSTiledMapServiceLayer worldTopoLayer];
    
    // set the buffer factor so we request tiles around us that
    // may soon be panned to
    // WARNING: This will use more memory so be careful!!!!!
    tmsl.bufferFactor = 1.2;
    
    [self.mapView addMapLayer:tmsl];
    
}


@end
