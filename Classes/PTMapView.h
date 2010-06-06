//
//  PTMapView.h
//  Yuba
//
//  Created by Sergey Lenkov on 27.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPointInfo.h"
#import "PTMarker.h"

@interface PTMapView : NSView {
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
	PTMarker *marker;
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
@property (nonatomic, retain) PTMarker *marker;
@property (nonatomic, assign) BOOL showMarker;
@property (nonatomic, assign) BOOL showMarkerForZeroValue;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) id dataSource;

- (void)draw;
- (void)drawHighlightInRect:(NSRect)rect forCountry:(NSString *)code;
- (NSColor *)colorForValue:(float)value;

@end

@protocol PTMapViewDataSource

@optional

- (NSString *)mapView:(PTMapView *)map markerTitleForCountry:(NSString *)code;

@required

- (NSNumber *)mapView:(PTMapView *)map valueForCountry:(NSString *)code;

@end

@protocol PTMapViewDelegate

@optional

- (void)mapView:(PTMapView *)map mouseMovedAboveCountry:(NSString *)code;

@end