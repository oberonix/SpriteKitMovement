//
//  AppDelegate.m
//  SpriteKitMovement
//
//  Created by oberonix on 12/7/13.
//  Copyright (c) 2013 Buffbit. All rights reserved.
//

#import "AppDelegate.h"
#import "QueuedMoveScene.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    CGSize size = CGSizeMake(1024, 768);
    SKScene *scene = [QueuedMoveScene sceneWithSize:size];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
