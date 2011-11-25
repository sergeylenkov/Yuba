//
//  AppDelegate.m
//  Map
//
//  Created by Sergey Lenkov on 25.11.11.
//  Copyright (c) 2011 Positive Team. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mapView;

- (void)dealloc {
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    values = [[NSMutableDictionary alloc] init];
     
    mapView.backgroundColor = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    mapView.maxColor = [NSColor colorWithDeviceRed:22.0/255.0 green:102.0/255.0 blue:150.0/255.0 alpha:1.0];
	mapView.zeroColor = [NSColor colorWithDeviceRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
	mapView.highlightColor = [NSColor colorWithDeviceRed:251.0/255.0 green:216.0/255.0 blue:67.0/255.0 alpha:1.0];
	mapView.showMarker = YES;
	mapView.showMarkerForZeroValue = YES;
    
    mapView.marker.backgroundColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8];
	mapView.marker.borderColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8];
	mapView.marker.textColor = [NSColor whiteColor];
	mapView.marker.type = YBMarkerTypeRectWithArrow;
	mapView.marker.shadow = YES;
    
    [mapView draw];
}

#pragma mark -
#pragma mark YBMapView Protocol
#pragma mark -

- (NSNumber *)mapView:(YBMapView *)map valueForCountry:(NSString *)code {
    NSNumber *value = [NSNumber numberWithLong:random() % 100];
    [values setObject:value forKey:code];
    
	return value;
}

- (NSString *)mapView:(YBMapView *)map markerTitleForCountry:(NSString *)code {
    return [NSString stringWithFormat:@"%@\n%d", code, [[values objectForKey:code] intValue]];
}

@end
