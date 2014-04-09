//
//  GraphicKVCVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/11/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "GraphicKVCVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"
#import "TwentyThingsUtility.h"
#import "CustomCalloutView.h"

@interface GraphicKVCVC ()<AGSMapViewLayerDelegate, AGSLayerCalloutDelegate>

@property (weak, nonatomic) IBOutlet AGSMapView *mapView;

@property (nonatomic, strong) AGSGraphicsLayer *gl;

@end

@implementation GraphicKVCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mapView addMapLayer:[AGSTiledMapServiceLayer lightGrayLayer]];
    self.mapView.layerDelegate = self;

    self.gl = [AGSGraphicsLayer graphicsLayer];
    self.gl.calloutDelegate = self;
    [self.mapView addMapLayer:self.gl];
}

// add lots of graphics with some attributes
- (void)addLotsOfGraphics {
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-14405800.682625
                                                ymin:-1221611.989964
                                                xmax:-7030030.629509
                                                ymax:11870379.854318
                                    spatialReference:[AGSSpatialReference webMercatorSpatialReference]];

    for (int i = 0; i<100; i++) {
        // generates a random point in the given envelope
        AGSPoint *pt = [TwentyThingsUtility randomPointInEnvelope:env];
        
        // create a graphic to display on the map
        AGSGraphic *g = [AGSGraphic graphicWithGeometry:pt symbol:nil attributes:nil];

        // this works too, but more typing, so we use KVC instead
        //[g setAttributeWithInt:i forKey:@"angle"];
        
        [g setValue:@(i) forKey:@"angle"];
        [g setValue:@"Test Name" forKey:@"name"];
        [g setValue:@"Test Title" forKey:@"title"];
        [g setValue:@"Test Value" forKey:@"value"];
        [self.gl addGraphic:g];
    }
    
    // create a simple renderer with an image
    AGSSimpleRenderer *r = [[AGSSimpleRenderer alloc] initWithSymbol:[AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"arrow"]];
    
    // set rotation type so 0 is due east
    r.rotationType = AGSRotationTypeArithmetic;
    
    // specify which attribute to use for the rotation angle
    r.rotationExpression = @"[angle]";
    
    self.gl.renderer = r;
}


-(void)mapViewDidLoad:(AGSMapView *)mapView {
    
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-14405800.682625
                                                ymin:-1221611.989964
                                                xmax:-7030030.629509
                                                ymax:11870379.854318
                                    spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    [self.mapView zoomToEnvelope:env animated:NO];
    
    [self addLotsOfGraphics];
}

-(BOOL)callout:(AGSCallout *)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable> *)layer mapPoint:(AGSPoint *)mapPoint {
    
    // create a custom view for our callout
    callout.customView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 160, 160) attributes:[feature allAttributes]];
    
    //
    // we can specify what position we want our callout leader flag to be set at
    // by default it will be on the bottom but you can use bitwise operators to specify combinations
    
//    callout.leaderPositionFlags = AGSCalloutLeaderPositionAny;
//    callout.leaderPositionFlags = AGSCalloutLeaderPositionLeft | AGSCalloutLeaderPositionRight;
    
    // return YES so the callout is displayed (NO if you dont want it for this particular feature)
    return YES;
}
@end
