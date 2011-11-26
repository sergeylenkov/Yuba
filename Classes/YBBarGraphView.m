//
//  YBBarGraphView.m
//  Yuba
//
//  Created by Sergey Lenkov on 13.05.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "YBBarGraphView.h"

#define OFFSET_X 60
#define OFFSET_Y 30
#define OFFSET_WITH_INFO_Y 60
#define OFFSET_LEGENT 160

@implementation YBBarGraphView

@synthesize formatter;
@synthesize drawAxesX;
@synthesize drawAxesY;
@synthesize drawGridX;
@synthesize drawGridY;
@synthesize drawInfo;
@synthesize info;
@synthesize drawLegend;
@synthesize showMarker;
@synthesize delegate;
@synthesize dataSource;
@synthesize marker;
@synthesize font;
@synthesize infoFont;
@synthesize legendFont;
@synthesize backgroundColor;
@synthesize textColor;
@synthesize borderColor;
@synthesize highlightColor;
@synthesize borderWidth;
@synthesize pickHeight;
@synthesize spaceBetweenBars;
@synthesize drawPeaksOnly;
@synthesize drawBarWithPeak;
@synthesize highlightBar;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		formatter = [[NSNumberFormatter alloc] init];
		
		[formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		
        drawAxesX = YES;
		drawAxesY = YES;
		drawGridX = YES;
		drawGridY = YES;
		
		series = [[NSMutableArray alloc] init];
		graphs = [[NSMutableArray alloc] init];
		legends = [[NSMutableArray alloc] init];
		points = [[NSMutableArray alloc] init];
		
		drawInfo = NO;
		info = @"";
		
		drawLegend = NO;
		drawPeaksOnly = NO;
        drawBarWithPeak = YES;
		highlightBar = YES;
		borderWidth = 0.0;
		pickHeight = 2.0;
        spaceBetweenBars = 1;
        
		self.backgroundColor = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
		self.textColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
		self.borderColor = [NSColor colorWithDeviceRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
		self.highlightColor = [NSColor colorWithDeviceRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
		
		self.font = [NSFont fontWithName:@"Helvetica Neue" size:11];
		self.infoFont = [NSFont fontWithName:@"Helvetica Neue" size:12];
		self.legendFont = [NSFont boldSystemFontOfSize:11];
		
		marker = [[YBMarker alloc] init];
		
		showMarker = NO;
		enableMarker = YES;
		
		NSTrackingAreaOptions trackingOptions =	NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
		
		trackingArea = [[[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingOptions owner:self userInfo:nil] autorelease];
		[self addTrackingArea:trackingArea];
    }
	
    return self;
}

- (void)dealloc {
	[series release];
	[graphs release];
	[legends release];
	[formatter release];
	[info release];
	[font release];
	[marker release];
	[backgroundColor release];
	[textColor release];
	[highlightColor release];
	[self removeTrackingArea:trackingArea];
	[super dealloc];
}

- (void)draw {
	[series removeAllObjects];
	[graphs removeAllObjects];
	[legends removeAllObjects];
	
	series = [[NSMutableArray arrayWithArray:[dataSource seriesForBarGraphView:self]] retain];
	NSInteger count = [dataSource numberOfGraphsInBarGraphView:self];
	
	for (int i = 0; i < count; i++) {
		[graphs addObject:[dataSource barGraphView:self valuesForGraph:i]];
		
		if ([dataSource respondsToSelector:@selector(barGraphView: legendTitleForGraph:)]) {
			[legends addObject:[dataSource barGraphView:self legendTitleForGraph:i]];
		} else {
			[legends addObject:@""];
		}
	}
	
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
	[points removeAllObjects];
	
    [backgroundColor set];
	NSRectFill(rect);
	
	if ([series count] == 0) {		
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[paragraphStyle setAlignment:NSCenterTextAlignment];
		
		NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, infoFont, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
		
		[@"No data" drawInRect:NSMakeRect(rect.size.width / 2 - 50, rect.size.height / 2 - 50, 100, 100) withAttributes:attsDict];
		
		[paragraphStyle release];
		
		return;
	}
	
	int offsetX = OFFSET_X;
	int offsetY = 0.0;
	
	if (drawInfo) {
		offsetY = OFFSET_WITH_INFO_Y;
	} else {
		offsetY = OFFSET_Y;
	}
	
	float minY = 0.0;
	float maxY = 0.0;
	
	for (int i = 0; i < [graphs count]; i++) {
		NSMutableArray *values = [graphs objectAtIndex:i];
		
		for (int j = 0; j < [values count]; j++) {
			if ([[values objectAtIndex:j] floatValue] > maxY) {
				maxY = [[values objectAtIndex:j] floatValue];
			}
		}
	}
	
	if (maxY < 100) {
		maxY = ceil(maxY / 10) * 10;
	} 
	
	if (maxY > 100 && maxY < 1000) {
		maxY = ceil(maxY / 100) * 100;
	} 
	
	if (maxY > 1000 && maxY < 10000) {
		maxY = ceil(maxY / 1000) * 1000;
	}
	
	if (maxY > 10000 && maxY < 100000) {
		maxY = ceil(maxY / 10000) * 10000;
	}
	
	float step = (maxY - minY) / 5;
	float stepY = (rect.size.height - (offsetY * 2)) / maxY;
	
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSRightTextAlignment];
	
	NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, font, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
	
	for (int i = 0; i < 6; i++) {
		NSInteger y = (i * step) * stepY;
		int value = i * step;
		
		if (drawGridY) {
			NSBezierPath *path = [NSBezierPath bezierPath];
			
			CGFloat dash[] = {6.0, 6.0};
			
			[path setLineDash:dash count:2 phase:0.0];
			[path setLineWidth:0.1];
			
			NSPoint startPoint = {offsetX, y + offsetY};
			NSPoint endPoint = {rect.size.width - offsetX, y + offsetY};
			
			[path moveToPoint:startPoint];
			[path lineToPoint:endPoint];
			
			[path closePath];
			
			[[NSColor colorWithDeviceRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] set];
			[path stroke];
		}
		
		if (i > 0 && drawAxesY) {
			NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
			[numberString drawInRect:NSMakeRect(0, y + 20, 50, 20) withAttributes:attsDict];
		}
	}
	
	[paragraphStyle release];
	
	NSInteger maxStep;
	
	if ([series count] > 5) {
		NSInteger stepCount = 5;
		NSInteger count = [series count] - 1;
		
		for (int i = 4; i < 8; i++) {
			if (count % i == 0) {
				stepCount = i;
			}
		}
		
		step = [series count] / stepCount;
		maxStep = stepCount + 1;
	} else {
		step = 1;
		maxStep = [series count];
	}
	
	NSInteger stepX = ceil((self.frame.size.width - (offsetX * 2)) / ([series count] - 1));
	
	paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSCenterTextAlignment];
	
	attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, font, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
	
	YBPointInfo *pointInfo = nil;
	
	for (int i = 0; i < maxStep; i++) {
		NSInteger x = (i * step) * stepX;
		
		if (x > self.frame.size.width - (offsetX * 2)) {
			x = self.frame.size.width - (offsetX * 2);
		}
		
		NSInteger index = i * step;
		
		if (index >= [series count]) {
			index = [series count] - 1;
		}
		
		if (drawGridX) {
			NSBezierPath *path = [NSBezierPath bezierPath];
			
			CGFloat dash[] = {6.0, 6.0};
			
			[path setLineDash:dash count:2 phase:0.0];
			[path setLineWidth:0.1];
			
			NSPoint startPoint = {x + offsetX, offsetY};
			NSPoint endPoint = {x + offsetX, rect.size.height - offsetY};
			
			[path moveToPoint:startPoint];		
			[path lineToPoint:endPoint];
			
			[path closePath];
			
			[[NSColor colorWithDeviceRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] set];
			[path stroke];
		}
		
		if (drawAxesX) {
			NSString *dateString = [series objectAtIndex:index];
			[dateString drawInRect:NSMakeRect(x, 0, 120, 20) withAttributes:attsDict];
		}
	}
	
	[paragraphStyle release];
	
	stepX = (self.frame.size.width - 120) / ([series count] - 1);
	
	for (int i = 0; i < [graphs count]; i++) {
		NSMutableArray *values = [graphs objectAtIndex:i];
		
		for (int j = 0; j < [values count] - 1; j++) {
			NSInteger x = j * stepX;
			NSInteger y = [[values objectAtIndex:j] intValue] * stepY;
			
			if (drawPeaksOnly || drawBarWithPeak) {
				NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSMakeRect(x + offsetX, y + offsetY - pickHeight, round(stepX) - spaceBetweenBars, pickHeight)];			

				if ([dataSource respondsToSelector:@selector(barGraphView: colorForPeak:)]) {
					[[dataSource barGraphView:self colorForPeak:i] set];
				} else {
					[[self colorByIndex:i] set];
				}
				
				[path fill];
			} 
            
            if (!drawPeaksOnly) {
				NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSMakeRect(x + offsetX, offsetY, stepX - spaceBetweenBars, y)];
                
                if (borderWidth > 0.0) {
                    [path setLineWidth:borderWidth];
                    
                    [borderColor set];
                    [path stroke];
                }
				
				BOOL highlight = NO;
				
				if ([path containsPoint:mousePoint]) {
					pointInfo = [[[YBPointInfo alloc] init] autorelease];
					pointInfo.x = x + offsetX + (stepX / 2);
					pointInfo.y = y + offsetY + 4;
					
					if ([dataSource respondsToSelector:@selector(barGraphView: markerTitleForGraph: forElement:)]) {
						pointInfo.title = [dataSource barGraphView:self markerTitleForGraph:i forElement:j];
					} else {
						pointInfo.title = [formatter stringFromNumber:[[graphs objectAtIndex:i] objectAtIndex:j]];
					}
					
					highlight = YES;
				}
				
				if (highlight && highlightBar) {
					[highlightColor set];					
				} else {
                    if ([dataSource respondsToSelector:@selector(barGraphView: colorForGraph:)]) {
                        [[dataSource barGraphView:self colorForGraph:i] set];
                    } else {
                        if (drawBarWithPeak) {
                            NSColor *indexColor = [self colorByIndex:i];
                            NSColor *color = [NSColor colorWithDeviceHue:indexColor.hueComponent saturation:indexColor.saturationComponent brightness:indexColor.brightnessComponent alpha:0.1];
                            
                            [color set];
                        } else {
                            [[self colorByIndex:i] set];
                        }
                    }
				}
				
				[path fill];
			}
		}
	}
	
	if (drawLegend) {
		[self drawLegendInRect:rect];
	}
	
	// draw info
	
	if (drawInfo) {
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[paragraphStyle setAlignment:NSCenterTextAlignment];
		
		NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, infoFont, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
		
		[info drawInRect:NSMakeRect(0, 10, rect.size.width, 20) withAttributes:attsDict];
		
		[paragraphStyle release];
	}
	
	// draw marker
	
	if (showMarker && !hideMarker && enableMarker && pointInfo != nil) {
		if (showMarker && pointInfo != nil) {			
			NSPoint point;
			point.x = pointInfo.x;
			point.y = pointInfo.y;
			
			[marker drawAtPoint:point inRect:rect withTitle:pointInfo.title];
		}
	}
}

- (void)drawLegendInRect:(NSRect)rect {
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSLeftTextAlignment];
	
	for (int i = 0; i < [legends count]; i++) {
		int top = rect.size.height - OFFSET_X;
		
		NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, legendFont, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName,  paragraphStyle, NSParagraphStyleAttributeName, nil];
		
		[[self colorByIndex:i] set];
		NSRectFill(NSMakeRect(rect.size.width - (OFFSET_LEGENT + 20), top - i * 30, 10, 10));
		
		[[legends objectAtIndex:i] drawInRect:NSMakeRect(rect.size.width - OFFSET_LEGENT, (top - i * 30) - 4, OFFSET_LEGENT - 10, 16) withAttributes:attsDict];
	}
	
	[paragraphStyle release];
}

- (NSColor *)colorByIndex:(NSInteger)index {
	NSColor *color;
	
	switch (index) {
		case 0:
			color = [NSColor colorWithDeviceRed:5/255.0 green:141/255.0 blue:199/255.0 alpha:1.0];
			break;
		case 1:
			color = [NSColor colorWithDeviceRed:80/255.0 green:180/255.0 blue:50/255.0 alpha:1.0];
			break;		
		case 2:
			color = [NSColor colorWithDeviceRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1.0];
			break;
		case 3:
			color = [NSColor colorWithDeviceRed:255/255.0 green:158/255.0 blue:1/255.0 alpha:1.0];
			break;
		case 4:
			color = [NSColor colorWithDeviceRed:252/255.0 green:210/255.0 blue:2/255.0 alpha:1.0];
			break;
		case 5:
			color = [NSColor colorWithDeviceRed:248/255.0 green:255/255.0 blue:1/255.0 alpha:1.0];
			break;
		case 6:
			color = [NSColor colorWithDeviceRed:176/255.0 green:222/255.0 blue:9/255.0 alpha:1.0];
			break;
		case 7:
			color = [NSColor colorWithDeviceRed:106/255.0 green:249/255.0 blue:196/255.0 alpha:1.0];
			break;
		case 8:
			color = [NSColor colorWithDeviceRed:178/255.0 green:222/255.0 blue:255/255.0 alpha:1.0];
			break;
		case 9:
			color = [NSColor colorWithDeviceRed:4/255.0 green:210/255.0 blue:21/255.0 alpha:1.0];
			break;
		default:
			color = [NSColor colorWithDeviceRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
			break;
	}
	
	return color;
}

- (void)mouseDown:(NSEvent *)event {
	enableMarker = !enableMarker;
	[self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)event {
	hideMarker = NO;	
	[self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)event {
	hideMarker = YES;	
	[self setNeedsDisplay:YES];
}

- (void)mouseMoved:(NSEvent *)event {
	NSPoint location = [event locationInWindow];
	mousePoint = [self convertPoint:location fromView:nil];
	
	[self setNeedsDisplay:YES];
}

- (void)updateTrackingAreas {
	[self removeTrackingArea:trackingArea];
	
	NSTrackingAreaOptions trackingOptions =	NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
	
	trackingArea = [[[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingOptions owner:self userInfo:nil] autorelease];
	[self addTrackingArea:trackingArea];
}

@end