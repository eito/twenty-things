//
//  SetMaxEnvVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/12/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "SetMaxEnvVC.h"
#import <ArcGIS/ArcGIS.h>

#error Insert your web map item id here
#define WEBMAP_ID @""

@interface SetMaxEnvVC ()<AGSWebMapDelegate>
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;
@property (nonatomic, strong) AGSWebMap *webMap;

@end

@implementation SetMaxEnvVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.webMap = [[AGSWebMap alloc] initWithItemId:WEBMAP_ID credential:nil];
    self.webMap.delegate = self;
    [self.webMap openIntoMapView:self.mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark AGSWebMap

-(void)webMapDidLoad:(AGSWebMap *)webMap  {
    NSLog(@"loaded webmap");
    
    // restrict map to reasonable envelope 
    self.mapView.maxEnvelope = [AGSEnvelope envelopeWithXmin:-13686875.381621
                                                        ymin:5638185.573642
                                                        xmax:-13619412.082830
                                                        ymax:5757932.928995
                                            spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
}

-(void)webMap:(AGSWebMap *)webMap didFailToLoadWithError:(NSError *)error {
    NSLog(@"failed to load web map: %@", error);
}

@end
