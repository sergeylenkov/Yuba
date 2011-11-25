//
//  AppDelegate.h
//  Map
//
//  Created by Sergey Lenkov on 25.11.11.
//  Copyright (c) 2011 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YBMapView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableDictionary *values;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet YBMapView *mapView;

@end
