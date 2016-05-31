//
//  Song.m
//  songs
//
//  Created by Сергей Фролов on 17.02.16.
//  Copyright © 2016 Cebrit. All rights reserved.
//

#import "Song.h"

@implementation Song

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.imageUrl = [dictionary objectForKey:@"picUrl"];
        self.artist   = [dictionary objectForKey:@"artist"];
        self.name     = [dictionary objectForKey:@"title"];
        self.songUrl  = [dictionary objectForKey:@"demoUrl"];
    }
    
    return self;
}

@end
