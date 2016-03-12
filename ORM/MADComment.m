//
//  MADComment.m
//  ORM
//
//  Created by Mariia Cherniuk on 29.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADComment.h"
#import "MADUser.h"
#import "MADPost.h"

@implementation MADComment

- (NSNumber *)date {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setDate:(NSNumber *)newDate {
    return [self setFieldValue:newDate forKey:@"date"];
}

- (NSString *)text {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setText:(NSString *)newText {
    return [self setFieldValue:newText forKey:@"text"];
}

- (NSString *)author {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setAuthor:(NSString *)newAuthor {
    return [self setFieldValue:newAuthor forKey:@"author"];
}

- (NSString *)user {
    return [self getParent:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setUser:(MADUser *)newUser{
    return [self setParentValue:newUser forKey:@"user"];
}

- (NSString *)post {
    return [self getParent:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setPost:(MADPost *)newPost {
    return [self setParentValue:newPost forKey:@"post"];
}

@end
