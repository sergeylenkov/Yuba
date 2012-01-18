//
//  AppDelegate.m
//  Graph
//
//  Created by Sergey Lenkov on 25.11.11.
//  Copyright (c) 2011 Positive Team. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize graphView;

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
    
	graphView.showMarker = YES;
	graphView.lineWidth = 1.4;
	graphView.drawBullet = YES;
    graphView.drawBottomMarker = NO;
    graphView.useMinValue = YES;
    graphView.minValue = 0.0;
    
    graphView.marker.backgroundColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8];
	graphView.marker.borderColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8];
	graphView.marker.textColor = [NSColor whiteColor];
	graphView.marker.type = YBMarkerTypeRectWithArrow;
	graphView.marker.shadow = YES;
    
    //markerView = [[MarkerView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];

    [graphView draw];
}

#pragma mark -
#pragma mark YBGraphView Protocol
#pragma mark -

- (NSInteger)numberOfGraphsInGraphView:(YBGraphView *)graph {
	return 1;
}

- (NSArray *)seriesForGraphView:(YBGraphView *)graph {
	return series;
}

- (NSArray *)graphView:(YBGraphView *)graph valuesForGraph:(NSInteger)index {
	return values;
}

- (NSString *)graphView:(YBGraphView *)graph markerTitleForGraph:(NSInteger)graphIndex forElement:(NSInteger)elementIndex {
	return [NSString stringWithFormat:@"%@\n%d", [series objectAtIndex:elementIndex], [[values objectAtIndex:elementIndex] intValue]];
}

- (NSView *)graphView:(YBGraphView *)graph markerViewForGraph:(NSInteger)graphIndex forElement:(NSInteger)elementIndex {
    //MarkerView *_markerView = [[MarkerView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    //_markerView.text = [NSString stringWithFormat:@"%d", [[values objectAtIndex:elementIndex] intValue]];
    markerView.text = [NSString stringWithFormat:@"%d", [[values objectAtIndex:elementIndex] intValue]];
    return markerView;
}

@end
