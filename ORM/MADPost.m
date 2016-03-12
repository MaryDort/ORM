//
//  MADPost.m
//  ORM
//
//  Created by Mariia Cherniuk on 29.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADPost.h"
#import "MADComment.h"
#import "MADTag.h"
#import "MADCategory.h"

@implementation MADPost

- (NSString *)title {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setTitle:(NSString *)newTitle {
    return [self setFieldValue:newTitle forKey:@"title"];
}

- (NSString *)content {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setContent:(NSString *)newContent {
    return [self setFieldValue:newContent forKey:@"content"];
}

- (MADCategory *)category {
    return [self getParent:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setCategory:(MADCategory *)newCategory {
    return [self setParentValue:newCategory forKey:@"category"];
}

- (NSArray *)comments {
    return [self getChildren:@"comment"];
}

- (NSArray *)tags {
    return [self getSiblings:@"tag"];
}

@end
