//
//  YBBullet.m
//  Yuba
//
//  Created by Sergey Lenkov on 30.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "YBBullet.h"

@implementation YBBullet

@synthesize color;
@synthesize borderColor;
@synthesize size;
@synthesize borderWidht;
@synthesize type;

- (id)init {
	if (self = [super init]) {		
		self.color = [NSColor blackColor];
		self.borderColor = [NSColor whiteColor];
		
		self.size = 6;
		self.borderWidht = 2;
		self.type = 0;
	}
	
	return self;
}

- (void)drawAtPoint:(NSPoint)point {
	if (type == PTBulletTypeCircle) {
		NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(point.x - (size / 2), point.y - (size / 2), size, size)];
		
		[path setLineWidth:borderWidht];
		[path closePath];
		
		[borderColor set];
		[path stroke];
		
		[color set];		
		[path fill];
	}
	
	if (type == PTMarkerTypeSquare) {
		NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSMakeRect(point.x - (size / 2), point.y - (size / 2), size, size)];
		
		[path setLineWidth:borderWidht];
		[path closePath];
		
		[borderColor set];
		[path stroke];
		
		[color set];		
		[path fill];
	}	
}

- (void)dealloc {
	[color release];
	[borderColor release];
	[super dealloc];
}

@end
