//
// Created by Max on 10/18/13.
// Copyright (c) 2013 Max. All rights reserved.
//
//


#import <Foundation/Foundation.h>
#import <MapBox/MapBox.h>


@interface MapViewController : UIViewController <RMMapViewDelegate, RMTileCacheBackgroundDelegate>
@property (nonatomic, retain) RMMapView *mapView;
@end