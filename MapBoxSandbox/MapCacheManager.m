//
// Created by Max on 10/20/13.
// Copyright (c) 2013 Max. All rights reserved.
//
//


#import "MapCacheManager.h"
#import "Reachability.h"

static MapCacheManager *map_cacher_instance = nil;

@implementation MapCacheManager {
@private
    RMMapBoxSource *onlineSource;
    Reachability *hostReach;
}
@synthesize mapCache;

- (id)init {
    self = [super init];
    if (self) {
        NSString *strFileURL = [[NSBundle mainBundle] pathForResource:@"map_cache" ofType:@"json"];
        NSError *error;
        NSString *jSONTileStr = [NSString stringWithContentsOfFile:strFileURL encoding:NSUTF8StringEncoding error:&error];
        onlineSource = [[RMMapBoxSource alloc] initWithTileJSON:jSONTileStr];
        mapCache = [[RMTileCache alloc] initWithExpiryPeriod:31000000];
        [mapCache setBackgroundCacheDelegate:self];
    }

    return self;
}

+(MapCacheManager *)getInstance {
    @synchronized(self) {
        if (map_cacher_instance == nil)
            map_cacher_instance = [[self alloc] init]; // assignment not done here
    }
    return map_cacher_instance;
}

-(void)startMapCaching {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    hostReach = [Reachability reachabilityWithHostName: @"www.apple.com"];;
    [hostReach startNotifier];
    [self updateWithReachability:hostReach];
}

- (void)updateWithReachability:(Reachability *)reachability {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus){
        case NotReachable:
            [mapCache cancelBackgroundCache];
            break;
//        case ReachableViaWiFi:break;
//        case ReachableViaWWAN:break;
        default:{
            CLLocationCoordinate2D theSouthWest, theNorthEast;

            theSouthWest.latitude = 38.67532527108585;
            theSouthWest.longitude = -77.09312438964844;
            theNorthEast.latitude = 39.07730899446638;
            theNorthEast.longitude = -76.47651672363281;
            [mapCache beginBackgroundCacheForTileSource:onlineSource southWest:theSouthWest northEast:theNorthEast minZoom:12 maxZoom:16];
            NSLog(@"caching = %d", mapCache.isBackgroundCaching);
            break;
        }
    }
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateWithReachability: curReach];
}

- (void)tileCache:(RMTileCache *)tileCache didBeginBackgroundCacheWithCount:(int)tileCount forTileSource:(id <RMTileSource>)tileSource {
    NSLog(@"caching started for source = %@ with conut = %i", tileSource, tileCount);
}

- (void)tileCacheDidCancelBackgroundCache:(RMTileCache *)tileCache {
    NSLog(@"caching canceled");
}

- (void)tileCacheDidFinishBackgroundCache:(RMTileCache *)tileCache {
    NSLog(@"caching finished");
}

- (void)tileCache:(RMTileCache *)tileCache didBackgroundCacheTile:(RMTile)tile withIndex:(int)tileIndex ofTotalTileCount:(int)totalTileCount {
    NSLog(@"tile recieved with index= %i for conut = %i", tileIndex, totalTileCount);
}

- (void)dealloc {
    hostReach = nil;
    mapCache = nil;
    onlineSource = nil;
}

@end