//
//  GLRenderModesVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/11/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "GLRenderModesVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"
#import "TwentyThingsUtility.h"

@interface GLRenderModesVC ()<AGSMapViewLayerDelegate>
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;

@property (nonatomic, strong) AGSGraphicsLayer *gl;
@end

@implementation GLRenderModesVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mapView.layerDelegate = self;
    
    [self.mapView addMapLayer:[AGSTiledMapServiceLayer imageryLayer]];
    
    self.gl = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.gl];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Switch Mode"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(switchRenderMode:)];
}

// this method just recreates a graphics layer with the appropriate render mode
// switching from  static-->dynamic-->static, etc
- (void)switchRenderMode:(id)sender {
    [self.mapView removeMapLayer:self.gl];
    
    NSArray *graphics = self.gl.graphics;
    
    AGSGraphicsLayerRenderingMode renderMode = AGSGraphicsLayerRenderingModeStatic;
    
    if (self.gl.renderingMode == AGSGraphicsLayerRenderingModeStatic) {
        renderMode = AGSGraphicsLayerRenderingModeDynamic;
    }
    self.gl = [[AGSGraphicsLayer alloc] initWithFullEnvelope:self.mapView.maxEnvelope
                                               renderingMode:renderMode];
    
    [self.gl addGraphics:graphics];
    [self.mapView addMapLayer:self.gl];
}

#pragma mark AGSMapViewLayerDelegate

-(void)mapViewDidLoad:(AGSMapView *)mapView {
    // utility method to add a bunch of random points to our visible area and graphics layer
    [TwentyThingsUtility addRandomPoints:500 inEnvelope:mapView.visibleAreaEnvelope toGraphicsLayer:self.gl];
}

@end
