
//
//  main.m
//  ORM
//
//  Created by Mariia Cherniuk on 28.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MADEntity.h"
#import "MADPost.h"
#import "MADCategory.h"
#import "MADTag.h"
#import "MADSection.h"
#import "MADUser.h"
#include "MADComment.h"
#import "MADExceptions.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        MADEntity *entity = [MADEntity sharedEntity];
        
        NSLog(@"TEST parents");
        MADPost *firstPost = [MADPost findFirstById:1];
        NSLog(@"%@", firstPost.title);
        NSLog(@"%@", firstPost.category.title);
        firstPost.category = [MADCategory findFirstById:2];
        [firstPost save];
        NSLog(@"%@", firstPost.category.title);
        
        
        NSLog(@"TEST children");
        MADCategory *firstCategory = [MADCategory findFirstById:1];
        for (MADPost *post in firstCategory.posts) {
            NSLog(@"%@", post.title);
        }
        
//        
//        article = Article(1)
//        for tag in article.tags: # select * from tag natural join article_tag where article_id=?
//            print(tag.value)
        NSLog(@"TEST siblings");
        MADPost *secondPost = [MADPost findFirstById:2];
        for (MADTag *tag in secondPost.tags) {
            NSLog(@"%@", tag.name);
        }
    }
    return 0;
}
