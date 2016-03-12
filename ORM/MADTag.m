//
//  MADTag.m
//  ORM
//
//  Created by Mariia Cherniuk on 28.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADTag.h"
#import "MADPost.h"

@implementation MADTag

- (NSString *)name {
    return [self fieldValueForKey:[NSString stringWithUTF8String:sel_getName(_cmd)]];
}

- (void)setName:(NSString *)newName {
    return [self setFieldValue:newName forKey:@"name"];
}

- (NSArray *)posts {
    return [self getSiblings:@"post"];
}

@end
