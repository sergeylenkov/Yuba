//
//  AppDelegate.h
//  Graph
//
//  Created by Sergey Lenkov on 25.11.11.
//  Copyright (c) 2011 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YBGraphView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableArray *series;
    NSMutableArray *values;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet YBGraphView *graphView;

@end
