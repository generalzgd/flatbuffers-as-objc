//
//  FBMutableArray.m
//  flatbuf-objc
//
//  Created by SC on 16/5/18.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "FBMutableArray.h"

@interface FBMutableArray ()

@property (nonatomic, strong)NSMutableArray *backendArray;

@end

@implementation FBMutableArray

-(instancetype)init {
    
    if (self = [super init]) {
        _backendArray = [@[] mutableCopy];
    }
    
    return self;
}

// *** Super's Required Methods (because you're going to use them) ***

-(void)addObject:(id)anObject {
    if(anObject == nil)return;
    [_backendArray addObject:anObject];
}

-(void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    if(anObject == nil || _backendArray.count >= index)return;
    [_backendArray insertObject:anObject atIndex:index];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if(anObject == nil || _backendArray.count >= index)return;
    [_backendArray replaceObjectAtIndex:index withObject:anObject];
}

-(instancetype)objectAtIndex:(NSUInteger)index {
    if(_backendArray.count >= index)return nil;
    return [_backendArray objectAtIndex:index];
}

-(NSUInteger)count {
    return _backendArray.count;
}

-(void)removeObject:(id)anObject {
    if(anObject == nil)return;
    [_backendArray removeObject:anObject];
}

-(void)removeLastObject {
    [_backendArray removeLastObject];
}

-(void)removeAllObjects {
    [_backendArray removeAllObjects];
}

-(void)removeObjectAtIndex:(NSUInteger)index {
    if(_backendArray.count >= index)return;
    [_backendArray removeObjectAtIndex:index];
}

@end
