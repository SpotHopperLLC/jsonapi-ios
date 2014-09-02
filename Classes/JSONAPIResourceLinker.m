//
//  JSONAPiResourceLinker.m
//  JSONAPI
//
//  Created by Josh Holtz on 12/24/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "JSONAPIResourceLinker.h"

@implementation JSONAPIResourceLinker

static JSONAPIResourceLinker *_defaultInstance = nil;

+ (instancetype)defaultInstance {
    if (!_defaultInstance) {
        _defaultInstance = [[JSONAPIResourceLinker alloc] init];
    }
    
    return _defaultInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.linkedTypeToLinksType = @{}.mutableCopy;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(%@) : %@", NSStringFromClass([self class]), self.linkedTypeToLinksType.allKeys];
}

- (void)link:(NSString*)resourceLinkType toLinkedType:(NSString*)linkedType {
    (self.linkedTypeToLinksType)[resourceLinkType] = linkedType;
}

- (NSString*)linkedType:(NSString*)resourceLinkType {
    NSString *type = (self.linkedTypeToLinksType)[resourceLinkType];
    if (type == nil) {
        type = resourceLinkType;
    }
    
    return type;
}

- (void)unlinkAll {
    [self.linkedTypeToLinksType removeAllObjects];
}

#pragma mark - Deprecated
#pragma mark -

+ (void)link:(NSString*)resourceLinkType toLinkedType:(NSString*)linkedType {
    [[self defaultInstance] link:resourceLinkType toLinkedType:linkedType];
}

+ (NSString*)linkedType:(NSString*)resourceLinkType {
    return [[self defaultInstance] linkedType:resourceLinkType];
}

+ (void)unlinkAll {
    [[self defaultInstance] unlinkAll];
}

@end
