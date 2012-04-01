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
@synthesize isHighlighted;

- (void)dealloc {
	[color release];
	[borderColor release];
	[super dealloc];
}

- (id)init {
    self = [super init];
    
	if (self) {		
		self.color = [NSColor blackColor];
		self.borderColor = [NSColor whiteColor];
		
		self.size = 6;
		self.borderWidht = 2;
		self.type = 0;
        self.isHighlighted = NO;
	}
	
	return self;
}


- (void)drawAtPoint:(NSPoint)point {
    [self drawAtPoint:point highlighted:isHighlighted];
}

- (void)drawAtPoint:(NSPoint)point highlighted:(BOOL)highlighted {
    NSInteger _size = size;
    
    if (highlighted) {
        _size = _size * 1.5;
    }
    
	if (type == YBBulletTypeCircle) {
		NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(point.x - (_size / 2), point.y - (_size / 2), _size, _size)];
        
		[path setLineWidth:borderWidht];
		[path closePath];
		
		[borderColor set];
		[path stroke];
		
		[color set];		
		[path fill];
	}
	
	if (type == YBMarkerTypeSquare) {
		NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSMakeRect(point.x - (_size / 2), point.y - (_size / 2), _size, _size)];
		
		[path setLineWidth:borderWidht];
		[path closePath];
		
		[borderColor set];
		[path stroke];
		
		[color set];		
		[path fill];
	}	
}

@end
