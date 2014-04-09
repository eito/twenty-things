//
//  USGSQuakeHeatMapLayer.m
//  QuakeHeatMapper
//
//  Created by Eric Ito on 12/22/13.
//  Copyright (c) 2013 Eric Ito. All rights reserved.
//

#import "USGSQuakeHeatMapLayer.h"
#import "SHGeoUtils.h"
#import "USGSQuakeHeatMapDrawingOperation.h"

@interface USGSQuakeHeatMapLayer () {
    NSOperationQueue *_bgQueue;
}
@property (nonatomic, strong) NSMutableArray *points;
@end

@implementation USGSQuakeHeatMapLayer

-(void)loadWithCompletion:(void(^)())completion {
    
    // go grab JSON from usgs.gov
    NSURL *url = [NSURL URLWithString:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"];
    
    // create our JSON request operation
    AGSJSONRequestOperation *jrop = [[AGSJSONRequestOperation alloc] initWithURL:url];
    
    // this will be called when the JSON has been downloaded and parsed
    jrop.completionHandler = ^(NSDictionary *json){
        
        // simple json parsing to create an array of AGSPoints
        
        NSArray *features = json[@"features"];
        
        for (NSDictionary *featureJSON in features) {
            double latitude = [featureJSON[@"geometry"][@"coordinates"][1] doubleValue];
            double longitude = [featureJSON[@"geometry"][@"coordinates"][0] doubleValue];
            
            // note use of AGSSpatialReference class methods... these are shared instances so we don't created potentially several hundred (or thousand)
            // instances when we have loops like this
            AGSPoint *wgs84Pt = [AGSPoint pointWithX:longitude
                                                   y:latitude
                                    spatialReference:[AGSSpatialReference wgs84SpatialReference]];
            
            // project to mercator since we know we will be using a mercator map in this sample
            AGSPoint *mercPt = (AGSPoint*)[[AGSGeometryEngine defaultGeometryEngine] projectGeometry:wgs84Pt
                                                                                  toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
            [self.points addObject:mercPt];
        }
        
        // once we have all the data that our layer needs to load... we need to call layerDidLoad
        [self layerDidLoad];
        
        // make sure we call the completion block
        completion();
    };
    
    // handle errors, call layerDidFailToLoad if needed
    jrop.errorHandler = ^(NSError *error){
        [self layerDidFailToLoad:error];
        completion();
    };
    
    // put our operation inside a queue to it gets started
    [_bgQueue addOperation:jrop];
}

- (id)init {
    self = [super init];
    if (self) {
        
        // queue to process our operation
        _bgQueue = [NSOperationQueue new];
        
        // holds on to our earthquake data
        self.points = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark overrides for custom dynamic layer

-(AGSEnvelope *)fullEnvelope {
    return self.mapView.maxEnvelope;
}

-(AGSEnvelope *)initialEnvelope {
    return self.mapView.maxEnvelope;
}

-(AGSSpatialReference *)spatialReference {
    return self.mapView.spatialReference;
}

-(void)requestImageWithWidth:(NSInteger)width height:(NSInteger)height envelope:(AGSEnvelope *)env timeExtent:(AGSTimeExtent *) timeExtent {
    
    // if we are currently processing a current draw request we want to make sure we cancel it
    // because the user may have move away from that extent...
    [_bgQueue cancelAllOperations];

    // kickoff an operation to draw our layer so we don't block the main thread.
    // This operation is responsible for creating a UIImage for the given envelope
    // and setting it on the layer
    USGSQuakeHeatMapDrawingOperation *drawOp = [USGSQuakeHeatMapDrawingOperation new];
    drawOp.envelope = env;
    drawOp.rect = CGRectMake(0, 0, width, height);
    drawOp.layer = self;
    drawOp.points = self.points;
    
    // add our drawing operation to the queue
    [_bgQueue addOperation:drawOp];
}

@end
