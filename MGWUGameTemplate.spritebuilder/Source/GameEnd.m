//
//  GameEnd.m
//  MGWUGameTemplate
//
//  Created by Congshan Lv on 5/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameEnd.h"

@implementation GameEnd {
    CCLabelTTF *_msgLabel;
    CCLabelTTF *_scoreLabel;
}

- (void)newGame {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)setMessage:(NSString *)message score:(NSInteger)score {
    _msgLabel.string = message;
    _scoreLabel.string = [NSString stringWithFormat:@"%ld", score];
}

@end
