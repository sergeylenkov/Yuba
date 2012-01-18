//
//  MarkerView.m
//  Graph
//
//  Created by Sergey Lenkov on 18.01.12.
//  Copyright (c) 2012 Positive Team. All rights reserved.
//

#import "MarkerView.h"

@implementation MarkerView

@synthesize text;

- (void)setText:(NSString *)newText {
    [text release];
    text = [newText copy];
    
    titleField.stringValue = text;
}

@end
