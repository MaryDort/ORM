# ORM - example of ORM in Objective-C for PostgreSQL

# Features:
- CRUD operations
- Fetch by id, all
- Lazy load
- Relations: parents, children, siblings

# Example usage:

```objective-c
//        Create entity
        MADSection *section = [MADSection new];
        section.title = @"New Section";
        [section save];
        
        MADCategory *category = [MADCategory new];
        category.title = @"Basic";
        category.section = section;
        [category save];
        
        MADPost *post = [MADPost new];
        post.title = @"New Post";
        post.content = @"Hello World!";
        post.category = category;
//        Save
        [post save];
//        Fetch
        MADPost *post = [MADPost findFirstById:1];
        NSArray *allPosts = [MADPost showAll];

  ```
