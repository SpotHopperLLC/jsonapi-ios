//
//  JSONAPIResourceFormatter.m
//  JSONAPI
//
//  Created by Josh Holtz on 7/9/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "JSONAPIResourceFormatter.h"

#import "JSONAPI.h"

@interface JSONAPIResourceFormatter ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *formatBlocks;

@end

@implementation JSONAPIResourceFormatter

static JSONAPIResourceFormatter *_defaultInstance = nil;

+ (instancetype)defaultInstance {
    if (!_defaultInstance) {
        _defaultInstance = [[JSONAPIResourceFormatter alloc] init];
    }
    
    return _defaultInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.formatBlocks = @{}.mutableCopy;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(%@) : %@", NSStringFromClass([self class]), self.formatBlocks.allKeys];
}

- (void)registerFormat:(NSString*)name withBlock:(id(^)(id jsonValue))block {
    self.formatBlocks[name] = [block copy];
}

- (id)performFormatBlock:(NSString*)value withName:(NSString*)name {
    id(^block)(NSString *);
    block = (self.formatBlocks)[name];
    if (block != nil) {
        return block(value);
    }
    else {
#ifndef NDEBUG
        [JSONAPI warnOfMappingFailure:[NSString stringWithFormat:@"Formatting block was not defined for '%@' (%@)",
                                       name, NSStringFromSelector(_cmd)]];
#endif
        return nil;
    }
}

- (BOOL)hasFormatBlock:(NSString*)name {
    NSAssert(self.formatBlocks, @"Property must be defined");
    return [self.formatBlocks.allKeys containsObject:name];
}

- (void)unregisterAll {
    [self.formatBlocks removeAllObjects];
}

#pragma mark - Deprecated
#pragma mark -

+ (void)registerFormat:(NSString*)name withBlock:(id(^)(id jsonValue))block {
    [[self defaultInstance] registerFormat:name withBlock:block];
}

+ (id)performFormatBlock:(NSString*)value withName:(NSString*)name {
    return [[self defaultInstance] performFormatBlock:value withName:name];
}

@end
