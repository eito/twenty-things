//
//  CoordinateConversionVC.m
//  twenty-things
//
//  Created by Eric Ito on 3/6/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "CoordinateConversionVC.h"
#import <ArcGIS/ArcGIS.h>
#import "AGSTiledMapServiceLayer+Additions.h"

@interface CoordinateConversionVC ()<UITextFieldDelegate, AGSMapViewTouchDelegate>
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;

// this is where you can enter a DMS string value
@property (weak, nonatomic) IBOutlet UITextField *textField;

// store tap point 1 and 2 in graphics on the graphics layer
@property (nonatomic, strong) AGSPictureMarkerSymbol *symbol;
@property (nonatomic, strong) AGSGraphicsLayer *graphicsLayer;

@end

@implementation CoordinateConversionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // we want to know when the user hits 'return'
    self.textField.delegate = self;
    
    // set up a starting value
    self.textField.text = @"34 2 2.8 N, 117 53 24.66 E";
    
    // respond to touch events
    self.mapView.touchDelegate = self;
    
    // add a base layer/graphics layer
    [self.mapView addMapLayer:[AGSTiledMapServiceLayer imageryLayer]];
    self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.graphicsLayer];
    
    // prevent content from going under the Navigation Bar
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // hides keyboard
    [textField resignFirstResponder];
    
    // resets state of graphics layer so we only see current point
    [self.graphicsLayer removeAllGraphics];
    
    // easy way to check for a valid non-zero length string
    if (textField.text.length) {
        
        // convert DMS string to AGSPoint in our map view's spatial reference
        AGSPoint *convertedPoint = [AGSPoint pointFromDegreesMinutesSecondsString:textField.text
                                                             withSpatialReference:self.mapView.spatialReference];
        
        // create a graphic
        AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:convertedPoint
                                                       symbol:self.symbol
                                                   attributes:nil];
        
        // display on the map
        [self.graphicsLayer addGraphic:graphic];
    }
    
    return NO;
}

#pragma mark AGSMapViewTouchDelegate

-(void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features {
    
    [self.graphicsLayer removeAllGraphics];
    
    // convert from map point to DMS string
    NSString *dmsString = [mappoint degreesDecimalMinutesStringWithNumDigits:3];
    
    // update our search text field
    self.textField.text = dmsString;
    
    // create a graphic
    AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:mappoint
                                                   symbol:self.symbol
                                               attributes:nil];
    
    // display on the map
    [self.graphicsLayer addGraphic:graphic];
}

#pragma mark Lazy Loads

// grab an image from our asset catalog
-(AGSPictureMarkerSymbol *)symbol {
    if (!_symbol) {
        _symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"red_pin"];
        
        // this offset allows the bottom point of the symbol to be pointing to
        // the map point associated with the AGSGraphic
        _symbol.offset = CGPointMake(-1, 18);
    }
    return _symbol;
}

@end
