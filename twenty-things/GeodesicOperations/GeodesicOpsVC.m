//
//  GeodesicOpsVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/7/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "GeodesicOpsVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"

@interface GeodesicOpsVC ()<AGSMapViewTouchDelegate>
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
- (IBAction)goBtnClicked:(id)sender;


@property (nonatomic, strong) AGSGraphic *startGraphic;
@property (nonatomic, strong) AGSGraphic *endGraphic;

@property (nonatomic, strong) AGSGraphicsLayer *pointsLayer;
@property (nonatomic, strong) AGSGraphicsLayer *flightPathLayer;
@end

@implementation GeodesicOpsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mapView.touchDelegate = self;
    [self.mapView addMapLayer:[AGSTiledMapServiceLayer imageryLayer]];
    
    self.flightPathLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.flightPathLayer];
    
    self.pointsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.pointsLayer];
    
    self.title = @"Geodesic Operations";
}


- (IBAction)goBtnClicked:(id)sender {
    // remove existing graphics
    [self.flightPathLayer removeAllGraphics];
    
    // create a new line to represent our point A and B
    AGSMutablePolyline *poly = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
    [poly addPathToPolyline];
    [poly addPointToPath:(AGSPoint*)self.startGraphic.geometry];
    [poly addPointToPath:(AGSPoint*)self.endGraphic.geometry];
    
    // densify the line so we can follow curvature of the earth
    AGSPolyline *denseLine = (AGSPolyline*)[[AGSGeometryEngine defaultGeometryEngine] geodesicDensifyGeometry:poly
                                                                                         withMaxSegmentLength:100
                                                                                                       inUnit:AGSSRUnitSurveyMile];
    
    // show how to get geodesic distance as well...we just log it here...
    AGSGeodesicDistanceResult *distanceResult = [[AGSGeometryEngine defaultGeometryEngine] geodesicDistanceBetweenPoint1:(AGSPoint*)self.startGraphic.geometry
                                                                                                                  point2:(AGSPoint*)self.endGraphic.geometry
                                                                                                                  inUnit:AGSSRUnitSurveyMile];
    NSLog(@"distance: %f", distanceResult.distance);
    
    
    // basic graphic with thin red line
    AGSGraphic *flightGraphic = [AGSGraphic graphicWithGeometry:denseLine symbol:[AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor]] attributes:nil];
    
    // nice looking composite symbol, uncomment to use
//    AGSGraphic *flightGraphic = [AGSGraphic graphicWithGeometry:denseLine symbol:[self flightPathSymbol] attributes:nil];
    
    [self.flightPathLayer addGraphic:flightGraphic];
}

- (IBAction)resetBtnClicked:(id)sender {
    [self.pointsLayer removeAllGraphics];
    [self.flightPathLayer removeAllGraphics];
}

-(void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features {
    
    if (self.pointsLayer.graphicsCount == 0) {
        self.startGraphic = [self startGraphicWithPoint:mappoint];
        [self.pointsLayer addGraphic:[self startGraphicWithPoint:mappoint]];
    }
    else if (!self.flightPathLayer.graphicsCount) {
        [self.pointsLayer removeGraphic:self.endGraphic];
        self.endGraphic = [self endGraphicWithPoint:mappoint];
        [self.pointsLayer addGraphic:self.endGraphic];
    }
}

- (AGSGraphic*)startGraphicWithPoint:(AGSPoint*)point {
    return [AGSGraphic graphicWithGeometry:point symbol:[self startSymbol] attributes:nil];
}

- (AGSGraphic*)endGraphicWithPoint:(AGSPoint*)point {
    return [AGSGraphic graphicWithGeometry:point symbol:[self endSymbol] attributes:nil];
}

- (AGSPictureMarkerSymbol*)startSymbol {
    AGSPictureMarkerSymbol *pms = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"green_pin"];
    pms.offset = CGPointMake(-1, 18);
    return pms;
}

- (AGSPictureMarkerSymbol*)endSymbol {
    AGSPictureMarkerSymbol *pms = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"red_pin"];
    pms.offset = CGPointMake(-1, 18);
    return pms;
}

- (AGSCompositeSymbol*)flightPathSymbol {
    
    // create a nice gradient line symbol using layered Simple Line Symbols
    
    UIColor *color1 = [UIColor colorWithRed:0.223529 green:0.47451 blue:0.843137 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.301961 green:0.545098 blue:0.858824 alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:0.458824 green:0.678431 blue:0.890196 alpha:1.0];
    UIColor *color4 = [UIColor colorWithRed:0.603922 green:0.803922 blue:0.921569 alpha:1.0];
    UIColor *color5 = [UIColor colorWithRed:0.690196 green:0.866667 blue:0.937255 alpha:1.0];
    
    AGSSimpleLineSymbol *sls1 = [AGSSimpleLineSymbol simpleLineSymbolWithColor:color1 width:10];
    AGSSimpleLineSymbol *sls2 = [AGSSimpleLineSymbol simpleLineSymbolWithColor:color2 width:8];
    AGSSimpleLineSymbol *sls3 = [AGSSimpleLineSymbol simpleLineSymbolWithColor:color3 width:6];
    AGSSimpleLineSymbol *sls4 = [AGSSimpleLineSymbol simpleLineSymbolWithColor:color4 width:4];
    AGSSimpleLineSymbol *sls5 = [AGSSimpleLineSymbol simpleLineSymbolWithColor:color5 width:2];
    AGSCompositeSymbol *cs = [AGSCompositeSymbol compositeSymbol];
    [cs addSymbols:@[sls1, sls2, sls3, sls4, sls5]];
    return cs;
}
@end
