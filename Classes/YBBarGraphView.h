//
//  YBBarGraphView.h
//  Yuba
//
//  Created by Sergey Lenkov on 13.05.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YBMarker.h"
#import "YBBullet.h"
#import "YBPointInfo.h"

@interface YBBarGraphView : NSView {
	NSMutableArray *series;
	NSMutableArray *graphs;
	NSMutableArray *legends;
	NSNumberFormatter *formatter;
	BOOL drawAxesX;
	BOOL drawAxesY;
	BOOL drawGridX;
	BOOL drawGridY;
	BOOL drawInfo;
	NSString *info;
	BOOL drawLegend;
	NSTrackingArea *trackingArea; 
	NSPoint mousePoint;
	NSMutableArray *points;
	BOOL showMarker;
	BOOL hideMarker;
	BOOL enableMarker;
	YBMarker *marker;
	NSFont *font;
	NSFont *infoFont;
	NSFont *legendFont;
	NSColor *backgroundColor;
	NSColor *textColor;
	NSColor *borderColor;
	NSColor *highlightColor;
	id delegate;
	id dataSource;
	CGFloat lineWidth;
	CGFloat borderWidth;
	BOOL onlyTopLine;
	BOOL highlightBar;
}

@property (nonatomic, retain) NSNumberFormatter *formatter;
@property (nonatomic, assign) BOOL drawAxesX;
@property (nonatomic, assign) BOOL drawAxesY;
@property (nonatomic, assign) BOOL drawGridX;
@property (nonatomic, assign) BOOL drawGridY;
@property (nonatomic, assign) BOOL drawInfo;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) BOOL drawLegend;
@property (nonatomic, assign) BOOL showMarker;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) id dataSource;
@property (nonatomic, retain) YBMarker *marker;
@property (nonatomic, retain) NSFont *font;
@property (nonatomic, retain) NSFont *infoFont;
@property (nonatomic, retain) NSFont *legendFont;
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) NSColor *textColor;
@property (nonatomic, retain) NSColor *borderColor;
@property (nonatomic, retain) NSColor *highlightColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) BOOL onlyTopLine;
@property (nonatomic, assign) BOOL highlightBar;

- (void)draw;
- (void)drawLegendInRect:(NSRect)rect;

- (NSColor *)colorByIndex:(NSInteger)index;

@end

@protocol YBBarGraphViewDataSource

@optional

- (NSColor *)barGraphView:(YBBarGraphView *)graph colorForGraph:(NSInteger)index;
- (NSString *)barGraphView:(YBBarGraphView *)graph legendTitleForGraph:(NSInteger)index;
- (NSString *)barGraphView:(YBBarGraphView *)graph markerTitleForGraph:(NSInteger)graphIndex forElement:(NSInteger)elementIndex;

@required

- (NSInteger)numberOfGraphsInBarGraphView:(YBBarGraphView *)graph;
- (NSArray *)barGraphView:(YBBarGraphView *)graph valuesForGraph:(NSInteger)index;
- (NSArray *)seriesForBarGraphView:(YBBarGraphView *)graph;

@end

@protocol YBBarGraphViewDelegate

@optional

- (void)barGraphView:(YBBarGraphView *)graph mouseMovedAboveElement:(NSInteger)index;

@end
