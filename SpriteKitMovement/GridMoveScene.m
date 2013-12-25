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
        
        map = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < 10; i++) {
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
                tile.zPosition = 0;
                [self addChild:tile];
            }
            x++;
        }
        [self addChild:myShip];
        myShip.zPosition = 2;
        
        selectedSquare = [SKSpriteNode spriteNodeWithColor:[NSColor greenColor] size:CGSizeMake(100, 100)];
        selectedSquare.alpha = 0.25;
        selectedSquare.zPosition = 1;
        
        //init bounding values, ship will touch edge since it's double size while moving
        minPositionX = myShip.size.width;
        minPositionY = myShip.size.height;
        maxPositionX = size.width - myShip.size.width;
        maxPositionY = size.height - myShip.size.height;
        
        
        xPadding = 62;
        yPadding = 84;
        squareSize = 100;
        halfSquareSize = squareSize / 2;
        
        //magic offsets, not sure why this is yet
        //mouse position isn't accurate without them though
        mouseXOffset = 410;
        mouseYOffset = 175;
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
    //determine if mouse is close to ship
    CGPoint mousePosition = [self getMousePosition];
    if(abs(mousePosition.x - myShip.position.x) < myShip.size.width / 2 && abs(mousePosition.y - myShip.position.y) < myShip.size.height / 2) {
        moving = YES;
        CGFloat scale = myShip.xScale;
        CGFloat duration = 2 * (0.5 - scale);
        SKAction *fadeAndGrow = [SKAction group:@[[SKAction fadeAlphaTo:0.5 duration:duration], [SKAction scaleTo:0.5 duration:duration]]];
        [myShip removeAllActions];
        [myShip runAction:fadeAndGrow];
        [self addChild:selectedSquare];
    }
}

-(void)mouseUp:(NSEvent *)theEvent {
    if(moving) {
        moving = NO;
        CGFloat scale = myShip.xScale;
        CGFloat duration = (scale - 0.25) * 2;
        SKAction *fadeShrinkAndMove = [SKAction group:@[
            [SKAction fadeAlphaTo:1 duration:duration],
            [SKAction scaleTo:0.25 duration:duration],
            [SKAction moveTo:[self getSquareNearestToPosition:[self getBoundedMousePosition]] duration:duration]
        ]];
        [myShip removeAllActions];
        [myShip runAction:fadeShrinkAndMove];
        [selectedSquare removeFromParent];
    }
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

-(CGPoint)getMousePosition {
    NSPoint mouseLocation = [self convertPointFromView:[NSEvent mouseLocation]];
    return CGPointMake(mouseLocation.x - mouseXOffset, mouseLocation.y - mouseYOffset);
}

//method to bound the mouse cursor to within the window including ship size offset
-(CGPoint)getBoundedMousePosition {
    CGPoint mousePosition = [self getMousePosition];
    return CGPointMake(MIN(MAX(mousePosition.x, minPositionX), maxPositionX), MIN(MAX(mousePosition.y, minPositionY), maxPositionY));
}

-(void)update:(CFTimeInterval)currentTime {
    if(moving) {
        CGPoint mousePosition = [self getBoundedMousePosition];
        [myShip setPosition:mousePosition];
        [self updateSelectedSquare:mousePosition];
    }
}

-(void)updateSelectedSquare:(CGPoint)mousePosition {
    [selectedSquare setPosition:[self getSquareNearestToPosition:mousePosition]];
}

-(CGPoint)getSquareNearestToPosition:(CGPoint)position {
    //calculate which square the mouse pointer correlates to
    //return the center position of that square
    int newX = ((int)((position.x - xPadding + halfSquareSize) / squareSize)) * squareSize + xPadding;
    int newY = ((int)((position.y - yPadding + halfSquareSize) / squareSize)) * squareSize + yPadding;
    return CGPointMake(newX, newY);
}

-(void)changeScene {
    SKScene *queueScene = [QueuedMoveScene sceneWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:queueScene transition:doors];
}



@end
