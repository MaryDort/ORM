//
//  MADUser.m
//  ORM
//
//  Created by Mariia Cherniuk on 29.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADUser.h"
#import "MADComment.h"

@implementation MADUser

- (NSString *)name {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setName:(NSString *)newName {
    return [self setFieldValue:newName forKey:@"name"];
}

- (NSString *)email {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setEmail:(NSString *)newEmail {
    return [self setFieldValue:newEmail forKey:@"email"];
}

- (NSArray *)comments {
    return [self getChildren:@"comment"];
}

@end
