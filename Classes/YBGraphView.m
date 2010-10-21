//
//  YBGraphView.h
//  Yuba
//
//  Created by Sergey Lenkov on 27.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "YBGraphView.h"

#define OFFSET_X 60
#define OFFSET_Y 30
#define OFFSET_WITH_INFO_Y 60
#define OFFSET_LEGENT 160

@implementation YBGraphView

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
@synthesize bullet;
@synthesize font;
@synthesize infoFont;
@synthesize legendFont;
@synthesize backgroundColor;
@synthesize textColor;
@synthesize lineWidth;
@synthesize drawBullet;
@synthesize zeroAsMinValue;
@synthesize fillGraph;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		self.formatter = [[NSNumberFormatter alloc] init];
		
		[formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		
        drawAxesX = YES;
		drawAxesY = YES;
		drawGridX = YES;
		drawGridY = YES;
		
		series = [[NSMutableArray alloc] init];
		graphs = [[NSMutableArray alloc] init];
		legends = [[NSMutableArray alloc] init];
		
		drawInfo = NO;
		info = @"";
		
		drawLegend = NO;
		drawBullet = NO;
		lineWidth = 1.2;
		
		self.backgroundColor = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
		self.textColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
		
		self.font = [NSFont fontWithName:@"Helvetica Neue" size:11];
		self.infoFont = [NSFont fontWithName:@"Helvetica Neue" size:12];
		self.legendFont = [NSFont boldSystemFontOfSize:11];
		
		self.marker = [[YBMarker alloc] init];
		self.bullet = [[YBBullet alloc] init];
		
		self.showMarker = NO;
		self.zeroAsMinValue = YES;
		
		self.fillGraph = NO;
		
		enableMarker = YES;
		
		NSTrackingAreaOptions trackingOptions =	NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
		
		trackingArea = [[[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingOptions owner:self userInfo:nil] autorelease];
		[self addTrackingArea:trackingArea];
    }
	
    return self;
}

- (void)draw {
	[series removeAllObjects];
	[graphs removeAllObjects];
	[legends removeAllObjects];
	
	series = [[NSMutableArray arrayWithArray:[dataSource seriesForGraphView:self]] retain];
	int count = [dataSource numberOfGraphsInGraphView:self];
	
	for (int i = 0; i < count; i++) {
		[graphs addObject:[dataSource graphView:self valuesForGraph:i]];
		
		if ([dataSource respondsToSelector:@selector(graphView: legendTitleForGraph:)]) {
			[legends addObject:[dataSource graphView:self legendTitleForGraph:i]];
		} else {
			[legends addObject:@""];
		}
	}
	
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {	
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

		if (!zeroAsMinValue) {
			minY = [[values lastObject] floatValue];
		}
		
		for (int j = 0; j < [values count]; j++) {
			if ([[values objectAtIndex:j] floatValue] > maxY) {
				maxY = [[values objectAtIndex:j] floatValue];
			}
			
			if (!zeroAsMinValue) {
				if ([[values objectAtIndex:j] floatValue] < minY) {
					minY = [[values objectAtIndex:j] floatValue];
				}
			}
		}
	}
	
	if (zeroAsMinValue) {
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
	}
	
	float step = (maxY - minY) / 5;
	float stepY = (rect.size.height - (offsetY * 2)) / maxY;
	
	if (!zeroAsMinValue) {
		stepY = (rect.size.height - (offsetY * 2)) / (maxY - minY);
	}
	
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSRightTextAlignment];
	
	NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, font, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
	
	for (int i = 0; i < 6; i++) {		
		int y = (i * step) * stepY;
		float value = i * step;
		
		if (!zeroAsMinValue) {
			value = i * step + minY;
		}
		
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
			NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
			[numberString drawInRect:NSMakeRect(0, y + 20, 50, 20) withAttributes:attsDict];
		}
	}
	
	[paragraphStyle release];
	
	int maxStep;
	
	if ([series count] > 5) {
		int stepCount = 5;
		int count = [series count] - 1;
		
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
		
	float stepX = (self.frame.size.width - (offsetX * 2)) / ([series count] - 1);

	paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSCenterTextAlignment];
	
	attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, font, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
	
	for (int i = 0; i < maxStep; i++) {
		int x = (i * step) * stepX;
		
		if (x > self.frame.size.width - (offsetX * 2)) {
			x = self.frame.size.width - (offsetX * 2);
		}
		
		int index = i * step;
		
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
	
	YBPointInfo *pointInfo = nil;
	NSPoint lastPoint;
	
	for (int i = 0; i < [graphs count]; i++) {
		NSMutableArray *values = [graphs objectAtIndex:i];
		NSColor *color = [NSColor clearColor];
		
		if ([values count] == 1) {
			int x = (self.frame.size.width - 120) / 2;
			int y = [[values objectAtIndex:0] intValue] * stepY;
			
			if (!zeroAsMinValue) {
				y = ([[values objectAtIndex:0] floatValue] - minY) * stepY;
			}
			
			NSPoint point;
			
			point.x = x;
			point.y = y;
			
			bullet.color = [self colorByIndex:i];
			[bullet drawAtPoint:point];

			lastPoint = point;
		} else {
			NSMutableArray *points = [[NSMutableArray alloc] init];
			
			for (int j = 0; j < [values count] - 1; j++) {
				int x = j * stepX;
				int y = [[values objectAtIndex:j] intValue] * stepY;

				if (!zeroAsMinValue) {
					y = ([[values objectAtIndex:j] floatValue] - minY) * stepY;
				}
			
				NSBezierPath *path = [NSBezierPath bezierPath];
		
				float lineDash[2];
				
				lineDash[0] = 6.0;
				lineDash[1] = 6.0;
		
				[path setLineWidth:lineWidth];
		
				NSPoint startPoint = {x + offsetX, y + offsetY};
						
				x = (j + 1) * stepX;
				y = [[values objectAtIndex:j + 1] intValue] * stepY;
		
				if (!zeroAsMinValue) {
					y = ([[values objectAtIndex:j + 1] floatValue] - minY) * stepY;
				}
			
				NSPoint endPoint = {x + offsetX, y + offsetY};
							
				[path moveToPoint:startPoint];
				[path lineToPoint:endPoint];

				[path closePath];
				
				if ([dataSource respondsToSelector:@selector(graphView: colorForGraph:)]) {
					color = [dataSource graphView:self colorForGraph:i];
				} else {
					color = [self colorByIndex:i];
				}
				
				[color set];
				[path stroke];
				
				[points addObject:[NSValue valueWithPoint:startPoint]];
				
				if (mousePoint.x > startPoint.x - (stepX / 2) && mousePoint.x < startPoint.x + (stepX / 2)) {
					pointInfo = [[[YBPointInfo alloc] init] autorelease];
								
					pointInfo.x = startPoint.x;
					pointInfo.y = startPoint.y;
				
					if ([dataSource respondsToSelector:@selector(graphView: markerTitleForGraph: forElement:)]) {
						pointInfo.title = [dataSource graphView:self markerTitleForGraph:i forElement:j];
					} else {
						pointInfo.title = [formatter stringFromNumber:[[graphs objectAtIndex:i] objectAtIndex:j]];
					}
				}

				if (drawBullet) {
					bullet.color = [self colorByIndex:i];
					[bullet drawAtPoint:startPoint];
				}
			
				lastPoint = endPoint;
			}
			
			if (fillGraph) {
				NSPoint startPoint = [[points objectAtIndex:0] pointValue];
				
				[points addObject:[NSValue valueWithPoint:lastPoint]];
				[points addObject:[NSValue valueWithPoint:NSMakePoint(lastPoint.x, offsetY)]];
				[points addObject:[NSValue valueWithPoint:NSMakePoint(startPoint.x, offsetY)]];
				[points addObject:[NSValue valueWithPoint:NSMakePoint(offsetX, offsetY)]];
				[points addObject:[NSValue valueWithPoint:startPoint]];
				
				NSBezierPath *path = [NSBezierPath bezierPath];
				[path setLineWidth:5.0];
				
				NSPoint point = [[points objectAtIndex:0] pointValue];
				[path moveToPoint:point];
				
				for (int i = 1; i < [points count]; i++) {
					point = [[points objectAtIndex:i] pointValue];
					[path lineToPoint:point];
				}
				
				[path closePath];

				[[color colorWithAlphaComponent:0.3] set];
				
				[path fill];
			}
			
			[points release];
		}
		
		if (mousePoint.x > lastPoint.x - (stepX / 2) && mousePoint.x < lastPoint.x + (stepX / 2)) {
			pointInfo = [[[YBPointInfo alloc] init] autorelease];
			
			pointInfo.x = lastPoint.x;
			pointInfo.y = lastPoint.y;
			
			if ([dataSource respondsToSelector:@selector(graphView: markerTitleForGraph: forElement:)]) {
				pointInfo.title = [dataSource graphView:self markerTitleForGraph:i forElement:[values count] - 1];
			} else {
				pointInfo.title = [formatter stringFromNumber:[[graphs objectAtIndex:i] objectAtIndex:[values count] - 1]];
			}
		}
		
		if (drawBullet) {
			bullet.color = [self colorByIndex:i];
			[bullet drawAtPoint:lastPoint];
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
		NSPoint point;
		point.x = pointInfo.x;
		point.y = pointInfo.y;

		[marker drawAtPoint:point inRect:rect withTitle:pointInfo.title];
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
	[self removeTrackingArea:trackingArea];
	[super dealloc];
}

@end
