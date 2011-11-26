//
//  AppDelegate.h
//  Bar
//
//  Created by Sergey Lenkov on 26.11.11.
//  Copyright (c) 2011 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YBBarGraphView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableArray *series;
    NSMutableArray *values;
}

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet YBBarGraphView *barView;

@end
