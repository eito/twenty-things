//
//  USGSQuakeHeatMapDrawingOperation.m
//  QuakeHeatMapper
//
//  Created by Eric Ito on 12/23/13.
//  Copyright (c) 2013 Eric Ito. All rights reserved.
//

#import "USGSQuakeHeatMapDrawingOperation.h"
#import "SHGeoUtils.h"

// method to convert an AGSPoint in map coordinates to a screen point
CGPoint AGSMapPointToScreenPoint2(AGSPoint *mapPoint, AGSEnvelope *env, CGSize screenSize) {
    double xPct = (mapPoint.x - env.xmin) / env.width;
    double yPct = (env.ymax - mapPoint.y) / env.height;
    return CGPointMake(screenSize.width * xPct, screenSize.height * yPct);
};


@interface USGSQuakeHeatMapDrawingOperation ()
@end

@implementation USGSQuakeHeatMapDrawingOperation

// we override main to do our drawing, checking for cancelled
// so we don't waste resources
-(void)main {
    
    // if cancelled, bail right away
    if ([self isCancelled]) {
        return;
    }
    
    // loop through the points and filter out points inside our
    // envelope that was passed in
    NSMutableArray *pts = [NSMutableArray array];
    for (AGSPoint *pt in self.points) {
        
        // again check for cancelled because we could be processing thousands of
        // points and can be cancelled at any time
        if ([self isCancelled]) {
            return;
        }
        if ([self.envelope containsPoint:pt]) {
            CGPoint p = AGSMapPointToScreenPoint2(pt, self.envelope, CGSizeMake(CGRectGetWidth(self.rect), CGRectGetHeight(self.rect)));
            [pts addObject:[NSValue valueWithCGPoint:p]];
        }
    }
    
    // use the SHGeoUtils methods from Skyhook to create a basic image for the heat map
    UIImage *heatMapImg = [SHGeoUtils heatMapWithRect:self.rect boost:0.75 points:pts weights:nil];
    
    // again check if we are cancelled so we don't process unnecessary image bytes
    if ([self isCancelled]) {
        return;
    }
    
    // set the image data on the layer so the map can draw the image
    [self.layer setImageData:UIImagePNGRepresentation(heatMapImg) forEnvelope:self.envelope];
}
@end
