//
//  YBMarker.m
//  Yuba
//
//  Created by Sergey Lenkov on 28.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "YBMarker.h"

@implementation YBMarker

@synthesize font;
@synthesize textColor;
@synthesize backgroundColor;
@synthesize borderColor;
@synthesize borderWidht;
@synthesize type;
@synthesize position;
@synthesize shadow;

- (id)init {
	if (self = [super init]) {
		NSFontManager *fontManager = [NSFontManager sharedFontManager];
		self.font = [fontManager fontWithFamily:@"Helvetica Neue" traits:NSBoldFontMask weight:0 size:10];
		
		self.textColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
		self.backgroundColor = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
		self.borderColor = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
		
		self.borderWidht = 2;
		self.type = 0;
		self.position = 0;
		self.shadow = NO;
	}
	
	return self;
}

- (void)drawAtPoint:(NSPoint)point inRect:(NSRect)rect withTitle:(NSString *)title {
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSCenterTextAlignment];
	
	NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, font, NSFontAttributeName, [NSNumber numberWithInt:NSNoUnderlineStyle], NSUnderlineStyleAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];

	NSSize labelSize = [title sizeWithAttributes:attsDict];
	
	int minWidth = 40;
	int width = labelSize.width;
	
	if (width < minWidth) {
		width = minWidth;
	}

	int minHeight = 20;
	int height = labelSize.height;
	
	if (height < minHeight) {
		height = minHeight;
	}	
	
	int rectWidth = width + 16;
	int rectHeight = height + 8;
	
	if (type == YBMarkerTypeRect) {		
		NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSMakeRect(point.x - (rectWidth / 2), point.y + 4, rectWidth, rectHeight)];			
		[path setLineWidth:borderWidht];
		
		[borderColor set];
		[path stroke];
		
		[backgroundColor set];
		[path fill];
		
		int offsetX = rectWidth - width;
		int offsetY = rectHeight - height;
		
		[title drawInRect:NSMakeRect((point.x - (rectWidth / 2)) + (offsetX / 2), point.y + (offsetY / 2) + 4, width, height) withAttributes:attsDict];
	}
	
	if (type == YBMarkerTypeRoundedRect) {
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(point.x - (rectWidth / 2), point.y + 4, rectWidth, rectHeight) xRadius:5 yRadius:5];
		[path setLineWidth:borderWidht];
		
		[borderColor set];
		[path stroke];
		
		[backgroundColor set];
		[path fill];
		
		int offsetX = rectWidth - width;
		int offsetY = rectHeight - height;
		
		[title drawInRect:NSMakeRect((point.x - (rectWidth / 2)) + (offsetX / 2), point.y + (offsetY / 2) + 4, width, height) withAttributes:attsDict];
	}
	
	if (type == YBMarkerTypeRectWithArrow) {
		NSBezierPath *path = [NSBezierPath bezierPath];
		[path setLineWidth:borderWidht];
		
		NSPoint drawPoint;			
		
		int x = point.x - (rectWidth / 2);
		int y = point.y + 14;
		
		if (y + rectHeight < rect.size.height) {
			drawPoint.x = x;
			drawPoint.y = y;
		
			[path moveToPoint:drawPoint];
		
			drawPoint.x = x;
			drawPoint.y = y + rectHeight;
		
			[path lineToPoint:drawPoint];			
		
			drawPoint.x = x + rectWidth;
			drawPoint.y = y + rectHeight;
		
			[path lineToPoint:drawPoint];
		
			drawPoint.x = x + rectWidth;
			drawPoint.y = y;
		
			[path lineToPoint:drawPoint];
		
			drawPoint.x = x + (rectWidth / 2) + 10;
			drawPoint.y = y;
		
			[path lineToPoint:drawPoint];
		
			drawPoint.x = x + (rectWidth / 2);
			drawPoint.y = y - 10;
		
			[path lineToPoint:drawPoint];
		
			drawPoint.x = x + (rectWidth / 2) - 10;
			drawPoint.y = y;
		
			[path lineToPoint:drawPoint];
		
			drawPoint.x = x;
			drawPoint.y = y;
			
			[path lineToPoint:drawPoint];			
		} else {
			y = point.y - 14;
			
			drawPoint.x = x;
			drawPoint.y = y;
			
			[path moveToPoint:drawPoint];
			
			drawPoint.x = x;
			drawPoint.y = y - rectHeight;
			
			[path lineToPoint:drawPoint];			
			
			drawPoint.x = x + rectWidth;
			drawPoint.y = y - rectHeight;
			
			[path lineToPoint:drawPoint];
			
			drawPoint.x = x + rectWidth;
			drawPoint.y = y;
			
			[path lineToPoint:drawPoint];
			
			drawPoint.x = x + (rectWidth / 2) + 10;
			drawPoint.y = y;
			
			[path lineToPoint:drawPoint];
			
			drawPoint.x = x + (rectWidth / 2);
			drawPoint.y = y + 10;
			
			[path lineToPoint:drawPoint];
			
			drawPoint.x = x + (rectWidth / 2) - 10;
			drawPoint.y = y;
			
			[path lineToPoint:drawPoint];
			
			drawPoint.x = x;
			drawPoint.y = y;
			
			[path lineToPoint:drawPoint];
		}

		[path closePath];
		
		NSShadow *markerShadow = [[[NSShadow alloc] init] autorelease];
		
		if (shadow) {
			[markerShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.660 alpha:1.000]];
			[markerShadow setShadowBlurRadius:3];
			[markerShadow setShadowOffset:NSMakeSize(0.0, -1.0)];
			
			[markerShadow set];
		}
		
		[borderColor set];
		[path stroke];
		
		[backgroundColor set];
		[path fill];
		
		
		int offsetX = rectWidth - width;
		int offsetY = rectHeight - height;
		
		if (shadow) {
			[markerShadow setShadowColor:nil];
			[markerShadow set];
		}		
		
		if (point.y + 14 + rectHeight < rect.size.height) {
			[title drawInRect:NSMakeRect((point.x - (rectWidth / 2)) + (offsetX / 2), point.y + (offsetY / 2) + 16, width, height) withAttributes:attsDict];
		} else {
			[title drawInRect:NSMakeRect((point.x - (rectWidth / 2)) + (offsetX / 2), point.y - height - 16, width, height) withAttributes:attsDict];
		}
	}
	
	[paragraphStyle release];
}

- (void)dealloc {
	[font release];
	[textColor release];
	[backgroundColor release];
	[borderColor release];
	[super dealloc];
}

@end
