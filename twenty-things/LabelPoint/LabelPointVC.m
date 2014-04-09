//
//  LabelPointVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/6/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "LabelPointVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"

@interface LabelPointVC ()<AGSMapViewTouchDelegate>
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;

@property (nonatomic, strong) AGSGraphicsLayer *gl;
@property (nonatomic, strong) AGSFeatureLayer *statesFL;
@end

@implementation LabelPointVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Label Point";
    
    self.mapView.touchDelegate = self;
    [self.mapView addMapLayer:[AGSTiledMapServiceLayer imageryLayer]];
    
    // states layer
    NSURL *flURL = [NSURL URLWithString:@"http://sampleserver6.arcgisonline.com/arcgis/rest/services/USA/MapServer/2"];
    
    // create a feature layer
    self.statesFL = [AGSFeatureLayer featureServiceLayerWithURL:flURL
                                                           mode:AGSFeatureLayerModeOnDemand];
    self.statesFL.outFields = @[@"*"];
    
    // create a renderer for our states layer
    UIColor *innerColor = [[UIColor orangeColor] colorWithAlphaComponent:0.6];
    UIColor *outerColor = [UIColor orangeColor];
    AGSSimpleFillSymbol *sfs = [AGSSimpleFillSymbol simpleFillSymbolWithColor:innerColor
                                                                 outlineColor:outerColor];
    AGSSimpleRenderer *sr = [AGSSimpleRenderer simpleRendererWithSymbol:sfs];
    self.statesFL.renderer = sr;
    
    AGSSimpleFillSymbol *sfs1 = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[[UIColor greenColor] colorWithAlphaComponent:0.70] outlineColor:[UIColor greenColor]];
    AGSClassBreak *cb1 = [[AGSClassBreak alloc] initWithLabel:@"" description:@"" maxValue:2500000 symbol:sfs1];

    AGSSimpleFillSymbol *sfs2 = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[[UIColor yellowColor] colorWithAlphaComponent:0.70] outlineColor:[UIColor yellowColor]];
    AGSClassBreak *cb2 = [[AGSClassBreak alloc] initWithLabel:@"" description:@"" maxValue:5000000 symbol:sfs2];

    AGSSimpleFillSymbol *sfs3 = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[[UIColor orangeColor] colorWithAlphaComponent:0.70] outlineColor:[UIColor orangeColor]];
    AGSClassBreak *cb3 = [[AGSClassBreak alloc] initWithLabel:@"" description:@"" maxValue:10000000 symbol:sfs3];

    AGSSimpleFillSymbol *sfs4 = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[[UIColor blueColor] colorWithAlphaComponent:0.70] outlineColor:[UIColor blueColor]];
    AGSClassBreak *cb4 = [[AGSClassBreak alloc] initWithLabel:@"" description:@"" maxValue:20000000 symbol:sfs4];
    
    AGSSimpleFillSymbol *sfs5 = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[[UIColor redColor] colorWithAlphaComponent:0.70] outlineColor:[UIColor redColor]];
    AGSClassBreak *cb5 = [[AGSClassBreak alloc] initWithLabel:@"" description:@"" maxValue:30000000 symbol:sfs5];

    AGSSimpleFillSymbol *sfs6 = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.70] outlineColor:[UIColor whiteColor]];
    AGSClassBreak *cb6 = [[AGSClassBreak alloc] initWithLabel:@"" description:@"" maxValue:40000000 symbol:sfs6];

    AGSClassBreaksRenderer *cbr = [[AGSClassBreaksRenderer alloc] init];
    [cbr setClassBreaks:@[cb1, cb2, cb3, cb4, cb5, cb6]];
    cbr.defaultSymbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[[UIColor greenColor] colorWithAlphaComponent:0.70] outlineColor:[UIColor greenColor]];
    cbr.field = @"pop2000";
    self.statesFL.renderer = cbr;
    
    [self.mapView addMapLayer:self.statesFL];
    
    self.gl = [AGSGraphicsLayer graphicsLayer];
    self.gl.name = @"graphics";
    [self.mapView addMapLayer:self.gl];
    
    // zoom into the US
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-14405800.682625
                                                ymin:-1221611.989964
                                                xmax:-7030030.629509
                                                ymax:11870379.854318
                                    spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    [self.mapView zoomToEnvelope:env animated:YES];
}

-(void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features {

    // grab the first feature we see in the "States" layer at this point
    NSArray *stateFeatures = [features valueForKey:self.statesFL.name];
    id<AGSFeature> feature = [stateFeatures firstObject];
    
    // determine the best point for this polygon
    AGSPoint *labelPoint = (AGSPoint*)[[AGSGeometryEngine defaultGeometryEngine] labelPointForPolygon:(AGSPolygon*)feature.geometry];
    
    // show a pin at this label point
    AGSPictureMarkerSymbol *pms = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"red_pin"];
    pms.offset = CGPointMake(-1, 18);
    AGSGraphic *g = [AGSGraphic graphicWithGeometry:labelPoint
                                             symbol:pms
                                         attributes:nil];
    [self.gl removeAllGraphics];
    [self.gl addGraphic:g];
}
@end
