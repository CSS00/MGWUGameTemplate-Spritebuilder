//
//  Tile.m
//  MGWUGameTemplate
//
//  Created by Congshan Lv on 3/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Tile.h"

@implementation Tile {
    //CCLabelTTF *_valueLabel;
    int _colorIndex;
    CCNodeColor *_backgroundNode;
}

-(CCNodeColor*)backgroundNode
{
    return _backgroundNode;
}

-(int)colorIndex
{
    return _colorIndex;
}

-(void)setColor:(CCColor *)color OfIndex:(int)index
{
    [self.backgroundNode setColor:color];
    _backgroundNode = [CCNodeColor nodeWithColor: color];
    _colorIndex = index;
    [self setColor:color];
}

//-(id)initWithColor:(CCColor *)color
//{
//    if(self=[super init])
//    {
//        _backgroundNode = [CCNodeColor nodeWithColor: color];
//    }
//    return self;
//}
//
//-(id)initWithColor:(CCColor *)color AndIndex:(int)colorIndex
//{
//    if(self=[super init])
//    {
//        self.contentSize = CGSizeMake(36.00, 36.00);
//        _backgroundNode.contentSize = CGSizeMake(36.00, 36.00);
//        _backgroundNode = [CCNodeColor nodeWithColor: color];
//        _colorIndex = colorIndex;
//    }
//    return self;
//}
//
//-(id)initWithBackgroundNode:(CCNodeColor *)backgroundNode
//{
//    if(self=[super init])
//    {
//        _backgroundNode = backgroundNode;
//    }
//    return self;
//}
//
//-(id)initWithBackgroundNode:(CCNodeColor *)backgroundNode AndIndex:(int)colorIndex
//{
//    if(self=[super init])
//    {
//        [self setColor:backgroundNode.color];
//        _backgroundNode = backgroundNode;
//        _colorIndex = colorIndex;
//    }
//    return self;
//}

@end
