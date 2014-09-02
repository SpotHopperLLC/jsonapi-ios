//
//  ModerManager.m
//  JSONAPI
//
//  Created by Brennan Stehling on 9/2/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "ModelManager.h"

#import "JSONAPI.h"

#import "CommentResource.h"
#import "PeopleResource.h"
#import "PostResource.h"

@implementation ModelManager

#pragma mark - Public
#pragma mark -

+ (void)prepareResources {
    [self linkResources];
    [self mapModels];
    [self registerFormatters];
}

+ (void)resetResources {
    [[JSONAPIResourceLinker defaultInstance] unlinkAll];
    [[JSONAPIResourceModeler defaultInstance] unmodelAll];
    [[JSONAPIResourceFormatter defaultInstance] unregisterAll];
}

#pragma mark - Private
#pragma mark -

// Initializes resource linking for JSONAPI
+ (void)linkResources {
    JSONAPIResourceLinker *linker = [JSONAPIResourceLinker defaultInstance];
    
    [linker link:@"author" toLinkedType:@"authors"];
    [linker link:@"authors" toLinkedType:@"authors"]; // Don't NEED this but why not be explicit
    [linker link:@"person" toLinkedType:@"people"];
    [linker link:@"chapter" toLinkedType:@"chapters"];
    [linker link:@"book" toLinkedType:@"books"];
}

// Initializes model linking for JSONAPI
+ (void)mapModels {
    JSONAPIResourceModeler *modeler = [JSONAPIResourceModeler defaultInstance];
    
    [modeler useResource:[CommentResource class] toLinkedType:@"comment"];
    [modeler useResource:[PeopleResource class] toLinkedType:@"authors"];
    [modeler useResource:[PeopleResource class] toLinkedType:@"people"];
    [modeler useResource:[PostResource class] toLinkedType:@"posts"];
}

// Initializes model formatting for JSONAPI
+ (void)registerFormatters {
}

@end
