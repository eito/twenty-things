//
//  USGSQuakeHeatMapLayer.h
//  QuakeHeatMapper
//
//  Created by Eric Ito on 12/22/13.
//  Copyright (c) 2013 Eric Ito. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

@interface USGSQuakeHeatMapLayer : AGSDynamicLayer

// this load just goes and grabs the data needed to draw this layer
-(void)loadWithCompletion:(void(^)())completion;

@end
