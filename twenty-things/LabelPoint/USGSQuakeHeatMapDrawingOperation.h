//
//  USGSQuakeHeatMapDrawingOperation.h
//  QuakeHeatMapper
//
//  Created by Eric Ito on 12/23/13.
//  Copyright (c) 2013 Eric Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

// operation to draw our heat map layer
@interface USGSQuakeHeatMapDrawingOperation : NSOperation

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, strong) AGSEnvelope *envelope;
@property (nonatomic, strong) AGSDynamicLayer *layer;
@property (nonatomic, copy) NSArray *points;

@end
