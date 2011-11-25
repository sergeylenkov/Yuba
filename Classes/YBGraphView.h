//
//  YBGraphView.h
//  Yuba
//
//  Created by Sergey Lenkov on 27.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YBMarker.h"
#import "YBBullet.h"
#import "YBPointInfo.h"

@class YBGraphView;

@protocol YBGraphViewDataSource

@optional

- (NSColor *)graphView:(YBGraphView *)graph colorForGraph:(NSInteger)index;
- (NSString *)graphView:(YBGraphView *)graph legendTitleForGraph:(NSInteger)index;
- (NSString *)graphView:(YBGraphView *)graph markerTitleForGraph:(NSInteger)graphIndex forElement:(NSInteger)elementIndex;

@required

- (NSInteger)numberOfGraphsInGraphView:(YBGraphView *)graph;
- (NSArray *)graphView:(YBGraphView *)graph valuesForGraph:(NSInteger)index;
- (NSArray *)seriesForGraphView:(YBGraphView *)graph;

@end

@protocol YBGraphViewDelegate

@optional

- (void)graphView:(YBGraphView *)graph mouseMovedAboveElement:(NSInteger)index;

@end

@interface YBGraphView : NSView {
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
	BOOL useMinValue;
    float minValue;
	BOOL isRevert;
    
	NSTrackingArea *trackingArea; 
	NSPoint mousePoint;
	
	BOOL showMarker;
	BOOL hideMarker;
	BOOL enableMarker;
	BOOL showMarkerNearPoint;
	YBMarker *marker;
	NSFont *font;
	NSFont *infoFont;
	NSFont *legendFont;
	NSColor *backgroundColor;
	NSColor *textColor;	
	CGFloat lineWidth;
	BOOL drawBullet;
	YBBullet *bullet;	
	BOOL fillGraph;
	BOOL drawBottomMarker;
    NSInteger gridYCount;
    NSInteger roundGridYTo;
    BOOL isRoundGridY;
	id delegate;
	id dataSource;
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
@property (nonatomic, retain) YBMarker *marker;
@property (nonatomic, retain) YBBullet *bullet;
@property (nonatomic, retain) NSFont *font;
@property (nonatomic, retain) NSFont *infoFont;
@property (nonatomic, retain) NSFont *legendFont;
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) NSColor *textColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) BOOL drawBullet;
@property (nonatomic, assign) BOOL useMinValue;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) BOOL isRevert;
@property (nonatomic, assign) BOOL fillGraph;
@property (nonatomic, assign) BOOL drawBottomMarker;
@property (nonatomic, assign) NSInteger gridYCount;
@property (nonatomic, assign) NSInteger roundGridYTo;
@property (nonatomic, assign) BOOL isRoundGridY;
@property (nonatomic, assign) BOOL showMarkerNearPoint;
@property (nonatomic, assign) IBOutlet id <YBGraphViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id <YBGraphViewDataSource> dataSource;

- (void)draw;
- (void)drawLegendInRect:(NSRect)rect;

+ (NSColor *)colorByIndex:(NSInteger)index;

@end

