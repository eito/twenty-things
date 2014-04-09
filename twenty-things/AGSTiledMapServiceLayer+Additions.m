//
//  AGSTiledMapServiceLayer+Additions.m
//  twenty-things
//
//  Created by Eric Ito on 3/6/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "AGSTiledMapServiceLayer+Additions.h"

@implementation AGSTiledMapServiceLayer (Additions)

+(instancetype)streetsLayer {
    NSURL *url = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer"];
    return [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
}

+(instancetype)imageryLayer {
    NSURL *url = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer"];
    return [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
}

+(instancetype)worldTopoLayer {
    NSURL *url = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/World_Topo_Map/MapServer"];
    return [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
}

+(instancetype)USATopoLayer {
    NSURL *url = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/USA_Topo_Maps/MapServer"];
    return [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
}

+(instancetype)oceansLayer {
    NSURL *url = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/Ocean_Basemap/MapServer"];
    return [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
}

+(instancetype)lightGrayLayer {
    NSURL *url = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer"];
    return [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
}

+(instancetype)natGeoLayer {
    NSURL *url = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/NatGeo_World_Map/MapServer"];
    return [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
}
@end
