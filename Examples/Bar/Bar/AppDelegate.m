//
//  AppDelegate.m
//  Bar
//
//  Created by Sergey Lenkov on 26.11.11.
//  Copyright (c) 2011 Positive Team. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize barView;

- (void)dealloc {
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    series = [[NSMutableArray alloc] init];
    values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 20; i++) {
        [series addObject:[NSString stringWithFormat:@"%d", 1990 + i]];
        [values addObject:[NSNumber numberWithLong:random() % 100]];
    }
    
	barView.showMarker = YES;
    barView.pickHeight = 3.0;
    
    barView.marker.backgroundColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8];
	barView.marker.borderColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8];
	barView.marker.textColor = [NSColor whiteColor];
	barView.marker.type = YBMarkerTypeRectWithArrow;
	barView.marker.shadow = YES;
    
    [barView draw];
}

#pragma mark -
#pragma mark YBBarGraphView Protocol
#pragma mark -

- (NSInteger)numberOfGraphsInBarGraphView:(YBBarGraphView *)graph {
	return 1;
}

- (NSArray *)seriesForBarGraphView:(YBBarGraphView *)graph {
	return series;
}

- (NSArray *)barGraphView:(YBBarGraphView *)graph valuesForGraph:(NSInteger)index {
    return values;
}

- (NSString *)barGraphView:(YBBarGraphView *)graph markerTitleForGraph:(NSInteger)graphIndex forElement:(NSInteger)elementIndex {
	return [NSString stringWithFormat:@"%@\n%d", [series objectAtIndex:elementIndex], [[values objectAtIndex:elementIndex] intValue]];
}

@end
