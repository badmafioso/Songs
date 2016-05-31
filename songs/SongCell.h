//
//  SongCell.h
//  songs
//
//  Created by Сергей Фролов on 17.02.16.
//  Copyright © 2016 Cebrit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view4image;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
