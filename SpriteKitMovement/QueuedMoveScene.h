//
//  MyScene.h
//  spritekitTest
//

//  Copyright (c) 2013 Buffbit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface QueuedMoveScene : SKScene
    {
        @private
        SKSpriteNode *myShip;
        NSMutableArray *eventQueue;
        NSMutableArray *destinationSpriteArray;
        NSMutableArray *destinationLineArray;
        SKShapeNode *currentMoveLine;
        CGPoint currentDestination;
        SKNode *markerNode;
        SKNode *lineNode;
    }
    -(void)runNextMoveAction;
    -(SKAction *)eventToMoveAction:(NSEvent *)event;
    -(void)onMoveDone;
    -(void)cancelPendingActions;
    -(void)addDestinationMarker:(CGPoint)location;
    -(void)addRedLineFrom:(CGPoint)from To:(CGPoint)to;
    -(void)updateCurrentMoveLine;
@end
