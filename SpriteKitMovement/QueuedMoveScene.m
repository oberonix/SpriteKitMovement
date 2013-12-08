//
//  MyScene.m
//  spritekitTest
//
//  Created by oberonix on 12/7/13.
//  Copyright (c) 2013 Buffbit. All rights reserved.
//

#import "QueuedMoveScene.h"

@implementation QueuedMoveScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        
        //add the ship sprite
        myShip = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        myShip.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        myShip.scale = 0.25;
        
        //create other layer containers
        markerNode = [SKNode node];
        lineNode = [SKNode node];
        
        //add nodes to scene for proper layering
        [self addChild:lineNode];
        [self addChild:markerNode];
        [self addChild:myShip];
        
        //initialize the ships current path line (green)
        currentMoveLine = [SKShapeNode node];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        currentMoveLine.path = pathToDraw;
        [currentMoveLine setStrokeColor:[SKColor greenColor]];
        
        //initialize all other variables
        currentDestination = myShip.position;
        eventQueue = [NSMutableArray array];
        destinationSpriteArray = [NSMutableArray array];
        destinationLineArray = [NSMutableArray array];
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
    //if shift isn't being held down clear queue and run immediately
    if (!([theEvent modifierFlags] & NSShiftKeyMask)) {
        [self cancelPendingActions];
    }
    
    //if there is a preceding action in the queue draw a pending action line
    NSEvent *previousEvent = [eventQueue lastObject];
    if(previousEvent != Nil) {
        [self addRedLineFrom: [previousEvent locationInNode:self] To:[theEvent locationInNode:self]];
    }
    
    //add a destination marker and queue the event
    [self addDestinationMarker:[theEvent locationInNode:self]];
    [eventQueue addObject:theEvent];
    
    //if this is the first action, start action queue
    if(!myShip.hasActions) {
        [lineNode addChild:currentMoveLine];
        [self runNextMoveAction];
    }
}

-(void)keyDown:(NSEvent *)theEvent {
    unsigned short x = [theEvent keyCode];
    switch (x) {
        case 53: //ESC - quit
            [[NSApplication sharedApplication] terminate:nil];
            break;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    //if there is a move happening adjust green line with current position
    if([eventQueue count] > 0) {
        [self updateCurrentMoveLine];
    }
}

/*** Helper Methods ***/

-(void)runNextMoveAction {
    NSEvent *nextEvent = eventQueue[0];
    currentDestination = [nextEvent locationInNode:self];
    SKAction *moveAction = [self eventToMoveAction:nextEvent];
    [myShip runAction:moveAction completion:^(void) {
        [self onMoveDone];
    }];
}

-(SKAction *)eventToMoveAction:(NSEvent *)event {
    CGPoint clickPoint = [event locationInNode:self];
    CGPoint shipPos = myShip.position;
    CGFloat distance = sqrtf((clickPoint.x - shipPos.x) * (clickPoint.x - shipPos.x) + (clickPoint.y - shipPos.y) * (clickPoint.y - shipPos.y));
    return [SKAction moveTo:clickPoint duration:distance / 250];
}

-(void)onMoveDone {
    //if there are more queued actions remove the next line to be replaced by a green one
    if([destinationLineArray count] > 0) {
        SKShapeNode *destinationLine = destinationLineArray[0];
        [destinationLineArray removeObjectAtIndex:0];
        [destinationLine removeFromParent];
    }
    
    //finish up current action by removing items from queue
    [eventQueue removeObjectAtIndex:0];
    [destinationSpriteArray[0] removeFromParent];
    [destinationSpriteArray removeObjectAtIndex:0];
    
    //if there are more events
    if([eventQueue count] > 0) {
        //update current line before next animation frame kicks in
        [self updateCurrentMoveLine];

        //start the next action
        [self runNextMoveAction];
    }
    else {
        [currentMoveLine removeFromParent];
    }
}

-(void)cancelPendingActions {
    [eventQueue removeAllObjects];
    for(SKShapeNode *node in destinationLineArray) {
        [node removeFromParent];
    }
    [destinationLineArray removeAllObjects];
    for(SKSpriteNode *node in destinationSpriteArray) {
        [node removeFromParent];
    }
    [destinationSpriteArray removeAllObjects];
    [myShip removeAllActions];
    [currentMoveLine removeFromParent];
}

-(void)addDestinationMarker:(CGPoint)location {
    SKSpriteNode *destinationNode = [SKSpriteNode spriteNodeWithImageNamed:@"Marker"];
    destinationNode.position = location;
    destinationNode.scale = 0.5;
    [destinationSpriteArray addObject:destinationNode];
    [markerNode addChild:destinationNode];
}

-(void)addRedLineFrom:(CGPoint)from To:(CGPoint)to {
    SKShapeNode *line = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, from.x, from.y);
    CGPathAddLineToPoint(pathToDraw, NULL, to.x, to.y);
    line.path = pathToDraw;
    [line setStrokeColor:[SKColor redColor]];
    [destinationLineArray addObject:line];
    [lineNode addChild:line];
}

-(void)updateCurrentMoveLine {
    CGMutablePathRef r = CGPathCreateMutable();
    CGPathMoveToPoint(r, NULL, myShip.position.x, myShip.position.y);
    CGPathAddLineToPoint(r, NULL, currentDestination.x, currentDestination.y);
    currentMoveLine.path = r;
}

@end
