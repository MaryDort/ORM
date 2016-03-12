//
//  MADCategory.m
//  ORM
//
//  Created by Mariia Cherniuk on 29.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADCategory.h"
#import "MADPost.h"
#import "MADSection.h"

@implementation MADCategory

- (NSString *)title {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setTitle:(NSString *)newTitle {
    return [self setFieldValue:newTitle forKey:@"title"];
}

- (NSString *)description {
    return [[super description] stringByAppendingString:[NSString stringWithFormat:@"%@", [self title]]];
}

- (NSString *)section {
    return [self getParent:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setSection:(MADSection *)newSection {
    return [self setParentValue:newSection forKey:@"section"];
}

- (NSArray *)posts {
    return [self getChildren:@"post"];
}

@end
