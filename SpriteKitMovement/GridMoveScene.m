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
        
        SKTexture *tileTexture = [SKTexture textureWithImageNamed:@"tile"];
        
        map = [NSMutableArray arrayWithCapacity:10];        for (int i = 0; i < 10; i++) {
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:10];
            [map addObject:row];
            for (int j = 0; j < 7; j++) {
                [row addObject:[SKSpriteNode spriteNodeWithTexture:tileTexture]];
            }
        }
        int x = 0;
        for (NSMutableArray *row in map) {
            int y = 0;
            for (SKSpriteNode *tile in row) {
                tile.position = CGPointMake((x * 100) + 62, (y++ * 100) + 84);
                [self addChild:tile];
            }
            x++;
        }
        [self addChild:myShip];

    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
    moving = YES;
    CGFloat scale = myShip.xScale;
    CGFloat duration = 2 * (0.5 - scale);
    [myShip removeAllActions];
    [myShip runAction:[SKAction scaleTo:0.5 duration:duration]];
}

-(void)mouseUp:(NSEvent *)theEvent {
    moving = NO;
    CGFloat scale = myShip.xScale;
    CGFloat duration = (scale - 0.25) * 2;
    [myShip removeAllActions];
    [myShip runAction:[SKAction scaleTo:0.25 duration:duration]];
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

-(void)update:(CFTimeInterval)currentTime {
    if(moving) {
        NSPoint mouseLocation = [self convertPointFromView:[NSEvent mouseLocation]];
//        NSPoint mouseLocation = [NSEvent mouseLocation];
        [myShip setPosition:CGPointMake(mouseLocation.x - 410, mouseLocation.y - 175)];
    }
}


-(void)changeScene {
    SKScene *queueScene = [QueuedMoveScene sceneWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:queueScene transition:doors];
}



@end
