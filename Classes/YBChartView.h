#import <Cocoa/Cocoa.h>
#import "YBMarker.h"
#import "YBPointInfo.h"

@interface YBChartView : NSView {
	NSMutableArray *series;
	NSMutableArray *values;
	NSMutableArray *legends;
	NSNumberFormatter *formatter;
	BOOL drawInfo;
	NSString *info;
	BOOL drawLegend;
	id delegate;
	id dataSource;
	NSInteger maxChartsCount;
	BOOL showMarker;
	BOOL hideMarker;
	BOOL enableMarker;
	NSTrackingArea *trackingArea;
	NSPoint mousePoint;
	YBMarker *marker;
	NSFont *font;
	NSFont *infoFont;
	NSFont *legendFont;
	NSColor *backgroundColor;
	NSColor *textColor;	
}

@property (nonatomic, retain) NSMutableArray *series;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSNumberFormatter *formatter;
@property (nonatomic, assign) BOOL drawInfo;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) BOOL drawLegend;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) id dataSource;
@property (nonatomic, assign) NSInteger maxChartsCount;
@property (nonatomic, retain) YBMarker *marker;
@property (nonatomic, assign) BOOL showMarker;
@property (nonatomic, retain) NSFont *font;
@property (nonatomic, retain) NSFont *infoFont;
@property (nonatomic, retain) NSFont *legendFont;
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) NSColor *textColor;

- (void)draw;

+ (NSColor *)colorByIndex:(NSInteger)index;
+ (NSColor *)markerColorByIndex:(NSInteger)index;

@end

@protocol YBChartViewDataSource

@optional

- (NSColor *)colorForChart:(NSInteger)index;
- (NSString *)chartView:(YBChartView *)chart legendTitleForChart:(NSString *)title withValue:(NSNumber *)value andPercent:(NSNumber *)percent;
- (NSString *)chartView:(YBChartView *)chart markerTitleForChart:(NSString *)title withValue:(NSNumber *)value andPercent:(NSNumber *)percent;

@required

- (NSInteger)numberOfCharts;
- (NSNumber *)chartView:(YBChartView *)chart valueForChart:(NSInteger)index;
- (NSString *)chartView:(YBChartView *)chart titleForChart:(NSInteger)index;

@end

@protocol YBChartViewDelegate

@optional

- (void)mouseMovedAboveChartIndex:(NSInteger)index;

@end