//
// Created by Max on 10/20/13.
// Copyright (c) 2013 Max. All rights reserved.
//
//


#import <Foundation/Foundation.h>
#import <MapBox/MapBox.h>


@interface MapCacheManager : NSObject <RMTileCacheBackgroundDelegate>
@property (nonatomic, retain) RMTileCache *mapCache;

+ (MapCacheManager *)getInstance;

- (void)startMapCaching;
@end