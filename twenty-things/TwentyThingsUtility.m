//
//  TwentyThingsUtility.m
//  twenty-things
//
//  Created by Eric Ito on 3/11/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "TwentyThingsUtility.h"
#import <ArcGIS/ArcGIS.h>

@implementation TwentyThingsUtility

+(void)addRandomPoints:(NSInteger)numPoints inEnvelope:(AGSEnvelope*)env toGraphicsLayer:(AGSGraphicsLayer *)gl {
    NSMutableArray *graphics = [NSMutableArray array];
    for (int i = 0; i < numPoints; i++) {
        AGSPoint *pt = [self randomPointInEnvelope:env];
        AGSPictureMarkerSymbol *pms = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"red_pin"];
        AGSGraphic *g = [AGSGraphic graphicWithGeometry:pt
                                                 symbol:pms
                                             attributes:nil];
        [graphics addObject:g];
    }
    [gl addGraphics:graphics];
}

+(AGSPoint*)randomPointInEnvelope:(AGSEnvelope *)envelope {
    uint32_t xDomain = (uint32_t)(envelope.xmax - envelope.xmin);
    double dx = 0;
    if (xDomain != 0){
        uint32_t x = arc4random() % xDomain;
        dx = envelope.xmin + x;
    }
    
    uint32_t yDomain = (uint32_t)(envelope.ymax - envelope.ymin);
    double dy = 0;
    if (yDomain != 0){
        uint32_t y = arc4random() % yDomain;
        dy = envelope.ymin + y;
    }
    
    return [AGSPoint pointWithX:dx y:dy spatialReference:envelope.spatialReference];
}


@end
