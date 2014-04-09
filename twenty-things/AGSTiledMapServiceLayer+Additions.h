//
//  AGSTiledMapServiceLayer+Additions.h
//  twenty-things
//
//  Created by Eric Ito on 3/6/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

// Simple category for creating instances of common AGSTiledMapServiceLayer objects
// using ArcGIS Online services
@interface AGSTiledMapServiceLayer (Additions)

+(instancetype)streetsLayer;
+(instancetype)imageryLayer;
+(instancetype)worldTopoLayer;
+(instancetype)USATopoLayer;
+(instancetype)oceansLayer;
+(instancetype)lightGrayLayer;
+(instancetype)natGeoLayer;

@end
