//
//  GameEnd.h
//  MGWUGameTemplate
//
//  Created by Congshan Lv on 5/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameEnd : CCNode
- (void)newGame;
- (void)setMessage:(NSString *)message score:(NSInteger)score;
@end
