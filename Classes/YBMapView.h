//
//  YBMapView.h
//  Yuba
//
//  Created by Sergey Lenkov on 27.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBPointInfo.h"
#import "YBMarker.h"

@class YBMapView;

@protocol YBMapViewDataSource

@optional

- (NSString *)mapView:(YBMapView *)map markerTitleForCountry:(NSString *)code;

@required

- (NSNumber *)mapView:(YBMapView *)map valueForCountry:(NSString *)code;

@end

@protocol YBMapViewDelegate

@optional

- (void)mapView:(YBMapView *)map mouseMovedAboveCountry:(NSString *)code;

@end

@interface YBMapView : NSView {
	NSMutableDictionary *worldMap;
	NSMutableDictionary *values;
	NSMutableDictionary *titles;
	BOOL hideMarker;
	BOOL enableMarker;
	NSTrackingArea *trackingArea;
	NSPoint mousePoint;
	
	NSColor *backgroundColor;
	NSColor *textColor;
	NSColor *maxColor;	
	NSColor *zeroColor;
	NSColor *highlightColor;
	NSFont *font;
	NSNumberFormatter *formatter;
	YBMarker *marker;
	BOOL showMarker;
	BOOL showMarkerForZeroValue;
    id delegate;
	id dataSource;
}


@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) NSColor *textColor;
@property (nonatomic, retain) NSColor *maxColor;
@property (nonatomic, retain) NSColor *zeroColor;
@property (nonatomic, retain) NSColor *highlightColor;
@property (nonatomic, retain) NSFont *font;
@property (nonatomic, retain) NSNumberFormatter *formatter;
@property (nonatomic, retain) YBMarker *marker;
@property (nonatomic, assign) BOOL showMarker;
@property (nonatomic, assign) BOOL showMarkerForZeroValue;
@property (nonatomic, retain) IBOutlet id <YBMapViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet id <YBMapViewDataSource> dataSource;

- (void)draw;
- (void)drawHighlightInRect:(NSRect)rect forCountry:(NSString *)code;
- (NSColor *)colorForValue:(float)value;

@end

