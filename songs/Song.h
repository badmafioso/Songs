//
//  Song.h
//  songs
//
//  Created by Сергей Фролов on 17.02.16.
//  Copyright © 2016 Cebrit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Song : NSObject

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *songUrl;
@property (weak, nonatomic) UIImageView *imageView;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
