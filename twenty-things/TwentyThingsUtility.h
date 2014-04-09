//
//  TwentyThingsUtility.h
//  twenty-things
//
//  Created by Eric Ito on 3/11/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGSGraphicsLayer;
@class AGSPoint;
@class AGSEnvelope;

/*
 Utility class to generate random points or add them to a graphics layer
 */
@interface TwentyThingsUtility : NSObject

+(void)addRandomPoints:(NSInteger)numPoints inEnvelope:(AGSEnvelope*)env toGraphicsLayer:(AGSGraphicsLayer *)gl;

+(AGSPoint*)randomPointInEnvelope:(AGSEnvelope*)env;

@end
