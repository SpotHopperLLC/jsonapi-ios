//
//  JSONAPIResourceModeler.m
//  JSONAPI
//
//  Created by Josh Holtz on 12/24/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "JSONAPIResourceModeler.h"

#import "JSONAPI.h"


#pragma mark - Class Extension
#pragma mark -

@interface JSONAPIResourceModeler ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *resourceToLinkedType;

@end

@implementation JSONAPIResourceModeler

static JSONAPIResourceModeler *_defaultInstance = nil;

+ (instancetype)defaultInstance {
    if (!_defaultInstance) {
        _defaultInstance = [[JSONAPIResourceModeler alloc] init];
    }
    
    return _defaultInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.resourceToLinkedType = @{}.mutableCopy;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(%@) : %@", NSStringFromClass([self class]), self.resourceToLinkedType];
}

- (void)useResource:(Class)jsonApiResource toLinkedType:(NSString *)linkedType {
    [self.resourceToLinkedType setValue:jsonApiResource forKey:linkedType];
}

- (Class)resourceForLinkedType:(NSString *)linkedType {
    Class c = self.resourceToLinkedType[linkedType];

#ifndef NDEBUG
    if ([JSONAPI isDebuggingEnabled]) {
        NSLog(@"Warning: Class not defined for '%@' (%@)", linkedType, NSStringFromSelector(_cmd));
    }
#endif
    
    return c;
}

- (void)unmodelAll {
    [self.resourceToLinkedType removeAllObjects];
}

#pragma mark - Deprecated
#pragma mark -

+ (void)useResource:(Class)jsonApiResource toLinkedType:(NSString *)linkedType {
    [[JSONAPIResourceModeler defaultInstance] useResource:jsonApiResource toLinkedType:linkedType];
}

+ (Class)resourceForLinkedType:(NSString *)linkedType {
    return [[JSONAPIResourceModeler defaultInstance] resourceForLinkedType:linkedType];
}

+ (void)unmodelAll {
    [[JSONAPIResourceModeler defaultInstance] unmodelAll];
}

@end
