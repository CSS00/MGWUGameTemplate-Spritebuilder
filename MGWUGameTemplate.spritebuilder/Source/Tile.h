//
//  Tile.h
//  MGWUGameTemplate
//
//  Created by Congshan Lv on 3/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Tile : CCNode
-(void)setColor:(CCColor *)color OfIndex:(int)index;
//-(id)initWithColor:(CCColor *)color;
//-(id)initWithColor:(CCColor *)color AndIndex:(int)colorIndex;
//-(id)initWithBackgroundNode:(CCNodeColor *)backgroundNode;
//-(id)initWithBackgroundNode:(CCNodeColor *)backgroundNode AndIndex:(int)colorIndex;
-(CCNodeColor*)backgroundNode;
-(int)colorIndex;
@end
