//
//  GridMoveScene.h
//  SpriteKitMovement
//
//  Created by oberonix on 12/9/13.
//  Copyright (c) 2013 Buffbit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GridMoveScene : SKScene
    {
        @private
        SKSpriteNode *myShip;
        NSMutableArray *map;
        bool moving;
        int maxPositionX;
        int maxPositionY;
        int minPositionX;
        int minPositionY;
    }
    -(id)initWithSize:(CGSize)size;
    -(void)mouseDown:(NSEvent *)theEvent;
    -(void)mouseUp:(NSEvent *)theEvent;
    -(void)keyDown:(NSEvent *)theEvent;
    -(CGPoint)getMousePosition;
    -(CGPoint)getBoundedMousePosition;
    -(void)update:(CFTimeInterval)currentTime;
    -(void)changeScene;
@end
