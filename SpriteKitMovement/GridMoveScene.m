//
//  GridMoveScene.m
//  SpriteKitMovement
//
//  Created by oberonix on 12/9/13.
//  Copyright (c) 2013 Buffbit. All rights reserved.
//

#import "GridMoveScene.h"
#include "QueuedMoveScene.h"

@implementation GridMoveScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        
        //add the ship sprite
        myShip = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        myShip.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        myShip.scale = 0.25;
        [self addChild:myShip];
    }
    return self;
}

-(void)keyDown:(NSEvent *)theEvent {
    unsigned short x = [theEvent keyCode];
    switch (x) {
        case 53: //ESC - quit
            [[NSApplication sharedApplication] terminate:nil];
            break;
        case 49: //space - change scenes
            [self changeScene];
            break;
    }
}

-(void)changeScene {
    SKScene *queueScene = [QueuedMoveScene sceneWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:queueScene transition:doors];
}



@end
