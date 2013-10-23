//
// Created by Max on 10/18/13.
// Copyright (c) 2013 Max. All rights reserved.
//
//


#import "MapViewController.h"
#import "MapCacheManager.h"

@implementation MapViewController {
@private
    RMMapBoxSource *onlineSource;
}
@synthesize mapView;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    mapView = [[RMMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    [self.view addSubview:self.mapView];

    [[MapCacheManager getInstance].mapCache cancelBackgroundCache];

    NSString *strFileURL = [[NSBundle mainBundle] pathForResource:@"map_cache" ofType:@"json"];
    NSError *error;
    NSString *jSONTileStr = [NSString stringWithContentsOfFile:strFileURL encoding:NSUTF8StringEncoding error:&error];
    onlineSource = [[RMMapBoxSource alloc] initWithTileJSON:jSONTileStr];
    mapView.tileSource = onlineSource;
    mapView.zoom = 11;
}

- (void)dealloc {
    mapView = nil;
}

@end