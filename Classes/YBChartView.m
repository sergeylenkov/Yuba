#import "YBChartView.h"

#define OFFSET 20
#define OFFSET_WITH_INFO 30
#define OFFSET_LEGENT 60

@implementation YBChartView

@synthesize series;
@synthesize values;
@synthesize formatter;
@synthesize drawInfo;
@synthesize info;
@synthesize drawLegend;
@synthesize delegate;
@synthesize dataSource;
@synthesize maxChartsCount;
@synthesize showMarker;
@synthesize marker;
@synthesize font;
@synthesize infoFont;
@synthesize legendFont;
@synthesize backgroundColor;
@synthesize textColor;
@synthesize isGradient;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        formatter = [[NSNumberFormatter alloc] init];
		
		[formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];	      
		
		series = [[NSMutableArray alloc] init];
		values = [[NSMutableArray alloc] init];
		legends = [[NSMutableArray alloc] init];
		
		self.backgroundColor = [NSColor whiteColor];
		self.textColor = [NSColor blackColor];
		
		self.drawInfo = NO;
		self.info = @"";
		
		self.drawLegend = YES;
		self.maxChartsCount = 5;
		self.font = [NSFont boldSystemFontOfSize:11];
		self.legendFont = [NSFont boldSystemFontOfSize:11];
		self.infoFont = [NSFont systemFontOfSize:11];
		self.isGradient = NO;
        
		marker = [[YBMarker alloc] init];
		
		showMarker = NO;
		hideMarker = NO;
		enableMarker = YES;
		
		NSTrackingAreaOptions trackingOptions =	NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
		
		trackingArea = [[[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingOptions owner:self userInfo:nil] autorelease];
		[self addTrackingArea:trackingArea];
    }
	
    return self;
}

- (void)draw {
	[series removeAllObjects];
	[values removeAllObjects];
	[legends removeAllObjects];
	
	int count = [dataSource numberOfCharts];
	
	for (int i = 0; i < count; i++) {
		[values addObject:[dataSource chartView:self valueForChart:i]];
		[legends addObject:[dataSource chartView:self titleForChart:i]];
	}

	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
	[backgroundColor set];
   
	NSRectFill(rect);

	if ([values count] == 0) {
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[paragraphStyle setAlignment:NSCenterTextAlignment];
		
		NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, infoFont, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
		
		[@"No data" drawInRect:NSMakeRect(rect.size.width / 2 - 50, rect.size.height / 2 - 50, 100, 100) withAttributes:attsDict];
		
		[paragraphStyle release];
		
		return;
		
		return;
	}
	
	float max = 0.0;
	
	for (int i = 0; i < [values count]; i++) {
		max = max + [[values objectAtIndex:i] floatValue];
	}

	if (max == 0.0) {		
		return;
	}
	
	float percent = max / 100.0;	
	float startAngle = 0.0;
	
	if (percent == 0.0) {
		percent = 1.0;
	}
	
	NSMutableArray *chartSeries = [[NSMutableArray alloc] init];
	NSMutableArray *chartValues = [[NSMutableArray alloc] init];
	
	int maxCount = [values count];
	
//	for (int i = 0; i < [values count]; i++) {
//		if ([[values objectAtIndex:i] floatValue] > 0.0) {
//			maxCount = maxCount + 1;
//		}
//	}
	
	if (maxCount > maxChartsCount) {
		maxCount = maxChartsCount;		
	}
	
	for (int i = 0; i < maxCount; i++) {
		[chartSeries addObject:[legends objectAtIndex:i]];
		[chartValues addObject:[values objectAtIndex:i]];		
	}

	if (maxCount >= maxChartsCount) {
		float other = 0.0;

		for (int i = maxCount; i < [values count]; i++) {
			other = other + [[values objectAtIndex:i] floatValue];
		}
		
		[chartSeries addObject:@"Other"];
		[chartValues addObject:[NSNumber numberWithFloat:other]];
	}	

	float chartSpaceHeight;
	float chartSpaceWidth;
	
	if (drawLegend) {
		chartSpaceWidth = rect.size.width - OFFSET_LEGENT;
	} else {
		chartSpaceWidth = rect.size.width;
	}

	if (drawInfo) {
		chartSpaceHeight = rect.size.height - OFFSET_WITH_INFO;
	} else {
		chartSpaceHeight = rect.size.height;
	}

	NSPoint center;
		
	if (drawLegend) {
		center.x = (rect.size.width - OFFSET_LEGENT) / 2;
	} else {
		center.x = (rect.size.width - (OFFSET * 2)) / 2;
	}
		
	if (drawInfo) {
		center.y = (rect.size.height - OFFSET_WITH_INFO) / 2;
		center.y = center.y + OFFSET_WITH_INFO;
	} else {
		center.y = rect.size.height / 2;
	}
	
	// draw pie chart
	
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSLeftTextAlignment];
	
	NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, infoFont, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName,  paragraphStyle, NSParagraphStyleAttributeName, nil];
	
	[paragraphStyle release];
	
	YBPointInfo *pointInfo = nil;
	
    float radius = chartSpaceHeight / 2;
    
    if (chartSpaceHeight > chartSpaceWidth) {
        radius = chartSpaceWidth / 2;
    }
    
    radius = radius - OFFSET * 2;
    
	for (int i = 0; i < [chartValues count]; i++) {
		float percents = [[chartValues objectAtIndex:i] floatValue] / percent;
		float endAngle = startAngle + percents * 3.6;

        if (percents == 0.0) {
            continue;
        }
        
		NSBezierPath *path = [NSBezierPath bezierPath];
		[path setLineWidth:0.1];

		[path moveToPoint:center];
		[path appendBezierPathWithArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle];
		
		if (i < maxChartsCount) {
			if ([dataSource respondsToSelector:@selector(colorForChart:)]) {			
				[[dataSource colorForChart:i] set];
			} else {
				[[YBChartView colorByIndex:i] set];
			}			
		} else {
			[[YBChartView colorByIndex:-1] set];
		}		
        
		[path fill];
        
		if ([path containsPoint:mousePoint]) {
			pointInfo = [[[YBPointInfo alloc] init] autorelease];
			pointInfo.x = mousePoint.x;
			pointInfo.y = mousePoint.y;

			if ([dataSource respondsToSelector:@selector(chartView: markerTitleForChart: withValue: andPercent:)]) {
				pointInfo.title = [dataSource chartView:self markerTitleForChart:[chartSeries objectAtIndex:i] withValue:[chartValues objectAtIndex:i] andPercent:[NSNumber numberWithFloat:percents]];
			} else {
				pointInfo.title = @"";
			}
			
			if (i < maxChartsCount) {
				//marker.backgroundColor = [YBChartView markerColorByIndex:i];
			} else {
				//marker.backgroundColor = [YBChartView markerColorByIndex:-1];
			}
		}
		
		// draw line and title

		NSString *title = [chartSeries objectAtIndex:i];
		
		if ([dataSource respondsToSelector:@selector(chartView: legendTitleForChart: withValue: andPercent:)]) {
			title = [dataSource chartView:self legendTitleForChart:[chartSeries objectAtIndex:i] withValue:[chartValues objectAtIndex:i] andPercent:[NSNumber numberWithFloat:percents]];
		}
		
		NSSize labelSize = [title sizeWithAttributes:attsDict];
		
		float delta = (endAngle - startAngle) / 2;
						
		NSPoint toPoint = center;
		NSPoint fromPoint = center;
		NSPoint textPoint = center;
		
		fromPoint.x = radius * cos((M_PI * (startAngle + delta)) / 180.0);
		fromPoint.y = radius * sin((M_PI * (startAngle + delta)) / 180.0);
		
		toPoint.x = (radius + 20) * cos((M_PI * (startAngle + delta)) / 180.0);
		toPoint.y = (radius + 20) * sin((M_PI * (startAngle + delta)) / 180.0);
		
		textPoint.x = (radius + 30) * cos((M_PI * (startAngle + delta)) / 180.0);
		textPoint.y = (radius + 30) * sin((M_PI * (startAngle + delta)) / 180.0);
		
		//NSString *title = [chartSeries objectAtIndex:i];		

		/*radius = chartSpaceHeight / 2;
		
		if (chartSpaceHeight > chartSpaceWidth) {
			radius = chartSpaceWidth / 2;
		}*/

		fromPoint.x = fromPoint.x + center.x;
		fromPoint.y = fromPoint.y + center.y;
		
		toPoint.x = toPoint.x + center.x;
		toPoint.y = toPoint.y + center.y;
		
		textPoint.x = textPoint.x + center.x;
		textPoint.y = textPoint.y + center.y;
		
		path = [NSBezierPath bezierPath];
		
		[path setLineWidth:1.0];
		
		[path moveToPoint:fromPoint];		
		[path lineToPoint:toPoint];
		
		[path closePath];
		
		[[NSColor grayColor] set];
		[path stroke];
		
		float pointAngle = startAngle + delta;
		float offsetX = 0.0;
		float offsetY = 0.0;
		
		if (pointAngle > 90 && pointAngle < 180) {
			offsetX = labelSize.width * -1;
			//offsetY = (labelSize.height / 2) * -1;
		}
		
		if (pointAngle >= 180 && pointAngle < 270) {
			offsetX = labelSize.width * -1;
			offsetY = (labelSize.height / 2) * -1;
		}
		
		if (pointAngle >= 270 && pointAngle <= 360) {
			offsetX = 0;
			offsetY = (labelSize.height / 2) * -1;
		}
		
		if (pointAngle >= 0 && pointAngle <= 90) {
			offsetX = 0;
			offsetY = 0;
		}
		
		textPoint.x = textPoint.x + offsetX;
		textPoint.y = textPoint.y + offsetY;
		
		[title drawAtPoint:textPoint withAttributes:attsDict];
		
		startAngle = startAngle + percents * 3.6;
	}
	
    if (isGradient) {
        NSColor *color = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.15];
        
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:color endingColor:[color highlightWithLevel:0.6]];
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:center];
        [path appendBezierPathWithArcWithCenter:center radius:radius startAngle:0.0 endAngle:360.0];
        [gradient drawInBezierPath:path angle:90.0];
        
        [gradient release];
    }    
    
	// draw marker
	
	if (showMarker && !hideMarker && enableMarker && pointInfo != nil) {
		NSPoint point;
		point.x = pointInfo.x;
		point.y = pointInfo.y;
				
		[marker drawAtPoint:point inRect:rect withTitle:pointInfo.title];
	}
	
	// draw legend
	
	if (drawLegend) {
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[paragraphStyle setAlignment:NSLeftTextAlignment];
		[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
		int n = 0;
        int width = 0;
        
        for (int i = 0; i < [chartSeries count]; i++) {
            NSString *legend = [chartSeries objectAtIndex:i];
            
            NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:legendFont, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
            NSSize size = [legend sizeWithAttributes:attsDict];
            
            if (size.width > width) {
                width = size.width;
            }
        }
        
		for (int i = 0; i < [chartValues count]; i++) {
			if ([[chartValues objectAtIndex:i] floatValue] > 0) {
				int top = rect.size.height - OFFSET_LEGENT;
				
				NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, font, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName,  paragraphStyle, NSParagraphStyleAttributeName, nil];
				
				if (i < 5) {
					[[YBChartView colorByIndex:i] set];
				} else {
					[[YBChartView colorByIndex:-1] set];
				}
				
				NSRectFill(NSMakeRect(rect.size.width - width - OFFSET_LEGENT - 20, top - n * 30, 10, 10));				
				[[chartSeries objectAtIndex:i] drawInRect:NSMakeRect(rect.size.width - width - OFFSET_LEGENT, (top - n * 30) - 4, width, 16) withAttributes:attsDict];
		 
				n = n + 1;
			}
		}
		
		[paragraphStyle release];
	}
	
	// draw info

	if (drawInfo) {
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[paragraphStyle setAlignment:NSCenterTextAlignment];

		NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, font, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
	 
		[info drawInRect:NSMakeRect(0, 20, rect.size.width, 20) withAttributes:attsDict];
		
		[paragraphStyle release];
	}
	
	[chartSeries release];
	[chartValues release];
}

+ (NSColor *)colorByIndex:(NSInteger)index {
	NSColor *color;
	
	switch (index) {
		case 0:
			color = [NSColor colorWithDeviceRed:1/255.0 green:165/255.0 blue:218/255.0 alpha:1.0];
			break;
		case 1:
			color = [NSColor colorWithDeviceRed:122/255.0 green:184/255.0 blue:37/255.0 alpha:1.0];
			break;		
		case 2:
			color = [NSColor colorWithDeviceRed:202/255.0 green:85/255.0 blue:43/255.0 alpha:1.0];
			break;
		case 3:
			color = [NSColor colorWithDeviceRed:241/255.0 green:182/255.0 blue:49/255.0 alpha:1.0];
			break;
		case 4:
			color = [NSColor colorWithDeviceRed:129/255.0 green:52/255.0 blue:79/255.0 alpha:1.0];
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

+ (NSColor *)markerColorByIndex:(NSInteger)index {
	NSColor *color;
	
	switch (index) {
		case 0:
			color = [NSColor colorWithDeviceRed:5/255.0 green:141/255.0 blue:199/255.0 alpha:0.6];
			break;
		case 1:	
			color = [NSColor colorWithDeviceRed:80/255.0 green:180/255.0 blue:50/255.0 alpha:0.6];
			break;		
		case 2:
			color = [NSColor colorWithDeviceRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:0.6];
			break;
		case 3:
			color = [NSColor colorWithDeviceRed:255/255.0 green:158/255.0 blue:1/255.0 alpha:0.6];
			break;
		case 4:
			color = [NSColor colorWithDeviceRed:252/255.0 green:210/255.0 blue:2/255.0 alpha:0.6];
			break;
		case 5:
			color = [NSColor colorWithDeviceRed:248/255.0 green:255/255.0 blue:1/255.0 alpha:0.6];
			break;
		case 6:
			color = [NSColor colorWithDeviceRed:176/255.0 green:222/255.0 blue:9/255.0 alpha:0.6];
			break;
		case 7:
			color = [NSColor colorWithDeviceRed:106/255.0 green:249/255.0 blue:196/255.0 alpha:0.6];
			break;
		case 8:
			color = [NSColor colorWithDeviceRed:178/255.0 green:222/255.0 blue:255/255.0 alpha:0.6];
			break;
		case 9:
			color = [NSColor colorWithDeviceRed:4/255.0 green:210/255.0 blue:21/255.0 alpha:0.6];
			break;
		default:
			color = [NSColor colorWithDeviceRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.6];
			break;
	}
	
	return color;
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

- (void)mouseDown:(NSEvent *)event {
	enableMarker = !enableMarker;
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
	[values release];
	[formatter release];
	[info release];
	[marker release];
	[font release];
	[super dealloc];
}

@end
