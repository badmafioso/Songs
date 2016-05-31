//
//  SongViewController.h
//  songs
//
//  Created by Сергей Фролов on 18.02.16.
//  Copyright © 2016 Cebrit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SongViewController : UIViewController<AVAudioPlayerDelegate>
@property (weak, nonatomic) NSString *imageUrl;
@property (weak, nonatomic) NSString *songUrl;
@property (weak, nonatomic) NSString *artist;
@property (weak, nonatomic) NSString *song;

@end
