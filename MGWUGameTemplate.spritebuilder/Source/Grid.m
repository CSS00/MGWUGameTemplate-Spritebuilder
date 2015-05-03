//
//  Grid.m
//  MGWUGameTemplate
//
//  Created by Congshan Lv on 3/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Tile.h"
#import "GameEnd.h"
#define MOVE_ACTION_TAG 1000

@implementation Grid {
    CGFloat _columnWidth;
    CGFloat _columnHeight;
    CGFloat _tileMarginVertical;
    CGFloat _tileMarginHorizontal;
    
    BOOL isMoving;
    
    NSMutableArray *_gridArray;
    NSNull *_noTile;
}
static const NSInteger GRID_WIDTH = 6;
static const NSInteger GRID_HEIGHT = 6;
static const NSInteger TILE_TYPES = 5;

//static const NSInteger START_TILES = 2;

static CCColor *color[5];

- (id)init{
        if(self=[super init]){
            self.score = 0;
            self.moves = 30;
        }
        return self;
}

- (void)didLoadFromCCB {
    _noTile = [NSNull null];
    _gridArray = [NSMutableArray array];
    for (int i = 0; i < GRID_HEIGHT; i++) {
        _gridArray[i] = [NSMutableArray array];
        for (int j = 0; j < GRID_WIDTH; j++) {
            _gridArray[i][j] = _noTile;
        }
    }
    isMoving = NO;
    [self initColors];
    [self setupBackground];

    //[self spawnStartTiles];
    
    // listen for swipes to the left
    UISwipeGestureRecognizer * swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    
    // listen for swipes to the right
    UISwipeGestureRecognizer * swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    
    // listen for swipes up
    UISwipeGestureRecognizer * swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    
    // listen for swipes down
    UISwipeGestureRecognizer * swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
    
}

-(void)initColors
{
    color[0] = [CCColor colorWithUIColor:[UIColor colorWithRed:1.0 green:0.6 blue:0.8 alpha:0.9]];
    color[1] = [CCColor colorWithUIColor:[UIColor colorWithRed:0.8 green:0.8 blue:1.0 alpha:0.9]];
    color[2] = [CCColor colorWithUIColor:[UIColor colorWithRed:0.6 green:1.0 blue:1.0 alpha:0.9]];
    color[3] = [CCColor colorWithUIColor:[UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:0.9]];
    color[4] = [CCColor colorWithUIColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.4 alpha:0.9]];
}

-(int)getRandomNumBetween:(int)lowerBound and:(int)upperBound
{
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    return rndValue;
}

-(Boolean)checkColorIndex:(int)index AtColumn:(int)column Row:(int)row
{
    if((column == 0 && row == 0)||
       (column == 1 && row == 0)||
       (column == 0 && row == 1)){
        return true;
    }
    if(column > 1)
    {
        Tile* nb_tile1 = _gridArray[column-1][row];
        Tile* nb_tile3 = _gridArray[column-2][row];
        if(index == [nb_tile3 colorIndex]
           && index == [nb_tile1 colorIndex]){
            return false;
        }
    }
    if(row > 1){
        Tile* nb_tile2 = _gridArray[column][row-1];
        Tile* nb_tile4 = _gridArray[column][row-2];
        
        if(index == [nb_tile4 colorIndex]
            && index == [nb_tile2 colorIndex]){
            return false;
        }
    }
    return true;
}

- (int)generateColorForColumn:(int)column Row:(int)row{
    int colorIndex =[self getRandomNumBetween:0 and:TILE_TYPES];
    while(1){
        if([self checkColorIndex:colorIndex AtColumn:column Row:row]){
            break;
        }
        else{
            colorIndex =[self getRandomNumBetween:0 and:TILE_TYPES];
        }
    }
    return colorIndex;
}

- (void)setupBackground
{
    CCNode *tile = [CCBReader load:@("Tile")];
    _columnWidth = tile.contentSize.width;
    _columnHeight = tile.contentSize.height;
    
    [tile performSelector:@selector(cleanup)];
    
    _tileMarginVertical = (self.contentSize.height - (GRID_HEIGHT*_columnHeight))/(GRID_HEIGHT + 1);
    _tileMarginHorizontal = (self.contentSize.width - (GRID_WIDTH*_columnWidth))/(GRID_WIDTH + 1);
    
    float x = _tileMarginHorizontal;
    float y = _tileMarginVertical;
    
    for(int i = 0; i < GRID_HEIGHT; i++){
        x = _tileMarginHorizontal;
        for (int j = 0; j < GRID_WIDTH; j++) {
            
            int colorIndex =[self generateColorForColumn:i Row:j];
            Tile *new_tile = (Tile*) [CCBReader load:@"Tile"];
            [new_tile setColor: color[colorIndex] OfIndex:colorIndex];
            [self addTile:new_tile AtColumn:i Row:j];
            
            x+= _columnWidth + _tileMarginHorizontal;
        }
        y += _columnHeight + _tileMarginVertical;
    }
    //[self printTileArray];
}

- (CGPoint)positionForColumn:(NSInteger)column row:(NSInteger)row {
    NSInteger x = _tileMarginHorizontal + column * (_tileMarginHorizontal + _columnWidth);
    NSInteger y = _tileMarginVertical + row * (_tileMarginVertical + _columnHeight);
    //printf("position for [%ld][%ld]: x = %ld, y = %ld\n", column, row, x, y);
    return CGPointMake(x,y);
}


- (void)addTile:(Tile*)tile AtColumn:(NSInteger)column Row:(NSInteger)row{
    _gridArray[column][row] = tile;
    tile.scale = 0.6f;
    //tile.visible = false;
    [self addChild:tile];
    tile.position = [self positionForColumn:column row:row];
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.2f];
    CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.1f scale:1.f];
    //CCActionShow *show = [CCActionShow action];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleUp]];//scaleUp
    sequence.tag = MOVE_ACTION_TAG;
    [tile runAction:sequence];
}

- (void)addTileAtColumn:(NSInteger)column row:(NSInteger)row {
    Tile *tile = (Tile*) [CCBReader load:@"Tile"];
    _gridArray[column][row] = tile;
    tile.scale = 0.f;
    [self addChild:tile];
    tile.position = [self positionForColumn:column row:row];
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
    CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.2f scale:1.f];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleUp]];
    sequence.tag = MOVE_ACTION_TAG;
    [tile runAction:sequence];
}

- (BOOL)convertPoint:(CGPoint)point toColumn:(NSInteger *)column row:(NSInteger *)row {
    NSParameterAssert(column);
    NSParameterAssert(row);
    CGPoint left_corner = CGPointMake(self.positionInPoints.x - self.contentSize.width/2,
                                      self.positionInPoints.y + self.contentSize.height/2);
    CGPoint new_point = CGPointMake(point.x - left_corner.x, left_corner.y - point.y);
    
    if (new_point.x >= 0 && new_point.x < self.contentSize.width &&
        new_point.y >= 0 && new_point.y < self.contentSize.height) {
        
        *column = new_point.x / (self.contentSize.width/GRID_WIDTH);
        *row = new_point.y / (self.contentSize.height/GRID_HEIGHT);
        return YES;
        
    } else {
        *column = NSNotFound;  // invalid location
        *row = NSNotFound;
        return NO;
    }
}

- (BOOL)swapColumn:(NSInteger)c1 Row:(NSInteger)r1 WithColumn:(NSInteger)c2 Row:(NSInteger)r2{
    if(c1 < 0 || c1 >= GRID_WIDTH
       || r1 < 0 || r1 >= GRID_HEIGHT
       || c2 < 0 || c2 >= GRID_WIDTH
       || r2 < 0 || r2 >= GRID_HEIGHT){
        return NO;
    }
    else{
        Tile* t1 = _gridArray[c1][r1];
        Tile* t2 = _gridArray[c2][r2];
        
        CGPoint p1 = [self positionForColumn:c1 row:r1];
        CGPoint p2 = [self positionForColumn:c2 row:r2];
        
//        t2.position = p1;
//        t1.position = p2;
        
        CCActionMoveTo *moveToP2 = [CCActionMoveTo actionWithDuration:0.2f position:p2];
        moveToP2.tag = MOVE_ACTION_TAG;
        [t1 runAction:moveToP2];
        
        CCActionMoveTo *moveToP1 = [CCActionMoveTo actionWithDuration:0.2f position:p1];
        moveToP1.tag = MOVE_ACTION_TAG;
        [t2 runAction:moveToP1];
        
        _gridArray[c1][r1] = t2;
        _gridArray[c2][r2] = t1;
        
        if(t1.colorIndex == t2.colorIndex){
            return NO;
        }
        else{
            return YES;
        }
    }
}

- (void)swipeSucColumn:(NSInteger)c1 Row:(NSInteger)r1 WithColumn:(NSInteger)c2 Row:(NSInteger)r2{
    self.moves -= 1;
    [self checkForMatch];
    if(self.moves == 0){
        [self endGameWithMessage:@"Game Over!"];
    }
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer{
    //CCLOG(@"swipeLeft");
    CGPoint point = [recognizer locationInView:[recognizer view]];
    NSInteger column, row;
    [self convertPoint:point toColumn:&column row:&row];
    if(column > 0){
        BOOL suc = [self swapColumn:column Row:row WithColumn:(column-1) Row:row];
        if(suc){
            [self swipeSucColumn:column Row:row WithColumn:(column-1) Row:row];
        }
    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer{
    //CCLOG(@"swipeRight");
    CGPoint point = [recognizer locationInView:[recognizer view]];
    NSInteger column, row;
    [self convertPoint:point toColumn:&column row:&row];
    if(column < GRID_WIDTH - 1){
        BOOL suc = [self swapColumn:column Row:row WithColumn:(column+1) Row:row];
        if(suc){
            [self swipeSucColumn:column Row:row WithColumn:(column+1) Row:row];
        }
    }
}

- (void)swipeDown:(UISwipeGestureRecognizer *)recognizer{
    //CCLOG(@"swipeDown");
    CGPoint point = [recognizer locationInView:[recognizer view]];
    NSInteger column, row;
    [self convertPoint:point toColumn:&column row:&row];
    if(row > 0){
        BOOL suc = [self swapColumn:column Row:row WithColumn:column Row:(row-1)];
        if(suc){
            [self swipeSucColumn:column Row:row WithColumn:column Row:(row-1)];
        }
    }
}

- (void)swipeUp:(UISwipeGestureRecognizer *)recognizer{
    //CCLOG(@"swipeUp");
    CGPoint point = [recognizer locationInView:[recognizer view]];
    NSInteger column, row;
    [self convertPoint:point toColumn:&column row:&row];
    if(row < GRID_HEIGHT - 1){
        BOOL suc = [self swapColumn:column Row:row WithColumn:column Row:(row+1)];
        if(suc){
            [self swipeSucColumn:column Row:row WithColumn:column Row:(row+1)];
        }
    }
}

- (void)move:(CGPoint)direction{
    
}

- (BOOL)indexValid:(NSInteger)x y:(NSInteger)y {
    BOOL indexValid = TRUE;
    indexValid &= x >= 0;
    indexValid &= y >= 0;
    if (indexValid) {
        indexValid &= x < (int) [_gridArray count];
        if (indexValid) {
            indexValid &= y < (int) [(NSMutableArray*) _gridArray[x] count];
        }
    }
    return indexValid;
}

- (void)moveTile:(Tile *)tile fromIndex:(NSInteger)oldX oldY:(NSInteger)oldY newX:(NSInteger)newX newY:(NSInteger)newY {
    //printf("move from %ld, %ld to %ld, %ld\n", oldX, oldY, newX, newY);
    _gridArray[newX][newY] = _gridArray[oldX][oldY];
    _gridArray[oldX][oldY] = _noTile;
    
    CGPoint newPosition = [self positionForColumn:newX row:newY];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:newPosition];
    moveTo.tag = MOVE_ACTION_TAG;
    
    [tile runAction:moveTo];
}

- (void)update:(CCTime)delta {
    
}

- (void)checkForMatch{
    for(int i = 0; i < GRID_WIDTH; i++){
        for(int j = 0; j < GRID_HEIGHT; j++){
            
            Tile* cur_tile = _gridArray[i][j];
            //CCLOG(@"for tile:%d, %d\n", i, j);
            
            if(cur_tile == (Tile*)_noTile){
                //CCLOG(@"Invalid tile!\n");
                continue;
            }
            
            int match_i = 1, match_j = 1;
            bool matchFlag [GRID_WIDTH][GRID_HEIGHT];
            for(int m = 0; m < GRID_WIDTH; m++){
                for(int n = 0; n < GRID_HEIGHT; n++){
                    matchFlag[m][n] = false;
                }
            }
            matchFlag[i][j] = true;
            
            // check i, left
            int temp_i = i-1;
            while(temp_i >= 0){
                Tile* temp_tile = _gridArray[temp_i][j];
                if(temp_tile == (Tile*)_noTile){
                    //CCLOG(@"Invalid tile!\n");
                    temp_i --;
                    continue;
                }
                if(temp_tile.colorIndex == cur_tile.colorIndex){
                    //[_match_i addObject:temp_tile];
                    match_i ++;
                    matchFlag[temp_i][j] = true;
                }
                else{
                    break;
                }
                temp_i --;
            }
            // check i, right
            temp_i = i+1;
            while(temp_i < GRID_WIDTH){
                Tile* temp_tile = _gridArray[temp_i][j];
                if(temp_tile == (Tile*)_noTile){
                    //CCLOG(@"Invalid tile!\n");
                    temp_i ++;
                    continue;
                }
                if(temp_tile.colorIndex == cur_tile.colorIndex){
                    //[_match_i addObject:temp_tile];
                    match_i ++;
                    matchFlag[temp_i][j] = true;
                }
                else{
                    break;
                }
                temp_i ++;
            }
            
            // check j, left
            int temp_j = j-1;
            while(temp_j >= 0){
                Tile* temp_tile = _gridArray[i][temp_j];
                if(temp_tile == (Tile*)_noTile){
                    //CCLOG(@"Invalid tile!\n");
                    temp_j --;
                    continue;
                }
                if(temp_tile.colorIndex == cur_tile.colorIndex){
                    //[_match_j addObject:temp_tile];
                    match_j ++;
                    matchFlag[i][temp_j] = true;
                }
                else{
                    break;
                }
                temp_j --;
            }
            // check j, right
            temp_j = j+1;
            while(temp_j < GRID_HEIGHT){
                Tile* temp_tile = _gridArray[i][temp_j];
                if(temp_tile == (Tile*)_noTile){
                    //CCLOG(@"Invalid tile!\n");
                    temp_j ++;
                    continue;
                }
                if(temp_tile.colorIndex == cur_tile.colorIndex){
                    //[_match_j addObject:temp_tile];
                    match_j ++;
                    matchFlag[i][temp_j] = true;
                }
                else{
                    break;
                }
                temp_j ++;
            }
            //CCLOG(@"matches i = %d, j = %d\n", match_i, match_j);
            if(match_i >= 3 && match_j >= 3){
                // eliminate blocks @ both column i and row j
                for(int column = 0; column < GRID_WIDTH; column++){
                    if(matchFlag[column][j] == true){
                        [self removeTileAtColumn:column Row:j];
                    }
                }
                for(int row = 0; row < GRID_HEIGHT; row++){
                    if(matchFlag[i][row] == true){
                        [self removeTileAtColumn:i Row:row];
                    }
                }
                [self regenerateTiles];
                self.score += match_i + match_j - 1;
            }
            else if(match_i >= 3 && match_j < 3){
                // eliminate blocks @ column i
                for(int column = 0; column < GRID_WIDTH; column++){
                    if(matchFlag[column][j] == true){
                        [self removeTileAtColumn:column Row:j];
                    }
                }
                [self regenerateTiles];
                self.score += match_i;
            }
            else if(match_i < 3 && match_j >= 3){
                // eliminate blocks @ row j
                for(int row = 0; row < GRID_HEIGHT; row++){
                    if(matchFlag[i][row] == true){
                        [self removeTileAtColumn:i Row:row];
                    }
                }
                [self regenerateTiles];
                self.score += match_j;
            }
            
        }
    }
}

- (void) removeTileAtColumn:(int)column Row:(int)row{
    // Remove tile at column*row
    Tile *tile = _gridArray[column][row];
    [self removeChild:tile];
    _gridArray[column][row] = _noTile;
}

- (void) printTileArray{
    for(int n = GRID_WIDTH - 1; n >= 0; n--){
        for(int m = 0; m < GRID_WIDTH; m++){
            if(_gridArray[m][n] != _noTile)
                printf("%d ", [_gridArray[m][n] colorIndex]);
            else
                printf("* ");
        }
        printf("\n");
    }
    printf("\n");
}

- (void) regenerateTiles{
    //CCLOG(@"regenerate\n");
    
    for(int i = 0; i < GRID_WIDTH; i++){
        for(int j = 0; j < GRID_HEIGHT; j++){
            
            Tile *cur_tile = _gridArray[i][j];
            int next = j + 1;
            
            if(cur_tile == (Tile*)_noTile && next == GRID_HEIGHT){
                //[self printTileArray];
                //CCLOG(@"new column = %d, row = %d\n", i, j);
                
                int colorIndex =[self generateColorForColumn:i Row:j];
                Tile *new_tile = (Tile*) [CCBReader load:@"Tile"];
                [new_tile setColor: color[colorIndex] OfIndex:colorIndex];
                [self addTile:new_tile AtColumn:i Row:j];
            }
            else if(cur_tile == (Tile*)_noTile && next < GRID_HEIGHT){
                //[self printTileArray];
                while(next < GRID_HEIGHT && _gridArray[i][next] == _noTile){
                    next ++;
                }
                if(next < GRID_HEIGHT){
                    Tile *next_tile = _gridArray[i][next];
                    [self moveTile:next_tile fromIndex:i oldY:next newX:i newY:j];
                }
                else{
                    //CCLOG(@"new column = %d, row = %d\n", i, j);
                    
                    int colorIndex =[self generateColorForColumn:i Row:j];
                    Tile *new_tile = (Tile*) [CCBReader load:@"Tile"];
                    [new_tile setColor: color[colorIndex] OfIndex:colorIndex];
                    [self addTile:new_tile AtColumn:i Row:j];
                }
            }
        }
    }
}

- (void)endGameWithMessage:(NSString*)message {
    CCLOG(@"%@",message);
    GameEnd *gameEndPopover = (GameEnd *)[CCBReader load:@"GameEnd"];
    gameEndPopover.positionType = CCPositionTypeNormalized;
    gameEndPopover.position = ccp(0.5, 0.5);
    gameEndPopover.zOrder = INT_MAX;
    [gameEndPopover setMessage:message score:self.score];
    [self addChild:gameEndPopover];
}

//- (void)spawnRandomTile {
//    BOOL spawned = FALSE;
//    while (!spawned) {
//        NSInteger randomRow = arc4random() % GRID_HEIGHT;
//        NSInteger randomColumn = arc4random() % GRID_WIDTH;
//        BOOL positionFree = (_gridArray[randomColumn][randomRow] == _noTile);
//        if (positionFree) {
//            [self addTileAtColumn:randomColumn row:randomRow];
//            spawned = TRUE;
//        }
//    }
//}

//- (void)spawnStartTiles {
//    for (int i = 0; i < START_TILES; i++) {
//        [self spawnRandomTile];
//    }
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    // 1
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInNode:self];
//    printf("selected column = %f, row = %f", location.x, location.y);
//    // 2
//    NSInteger column, row;
//    if ([self convertPoint:location toColumn:&column row:&row]) {
//
//        // 3
//        Tile *tile = _gridArray[column][row];
//        if (tile != nil) {
//
//            // 4
//            //self.swipeFromColumn = column;
//            //self.swipeFromRow = row;
//            printf("selected column = %ld, row = %ld", (long)column, (long)row);
//        }
//    }
//}
//

@end
