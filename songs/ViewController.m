//
//  ViewController.m
//  songs
//
//  Created by Сергей Фролов on 17.02.16.
//  Copyright © 2016 Cebrit. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Song.h"
#import "SongCell.h"
#import "SongViewController.h"

const int kLoadingCellTag = 9999;

@interface ViewController ()

@property (nonatomic, retain) NSMutableArray* songs;
@property (weak, nonatomic) IBOutlet UITableView *songsTableView;

- (void)fetchSongs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Songs";
    
    self.songs = [NSMutableArray array];
    
    _from       = 0;
    _limit      = 10;
    
    //[self fetchSongs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_from == 0 || (_from % 10 == 0)) {
        return self.songs.count + 1;
    }
    
    return self.songs.count;
}

- (UITableViewCell *)songCellForIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    
    SongCell *cell = [self.songsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[SongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Song *song = [self.songs objectAtIndex:indexPath.row];
    
    cell.artist.text = song.artist;
    cell.name.text   = song.name;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center = cell.view4image.center;
    
    [cell.view4image addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    if (song.imageView == nil) {
        NSURL *url = [NSURL URLWithString:song.imageUrl];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFImageResponseSerializer serializer];
        
        [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, UIImage *responseImage) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:responseImage];
            
            [imageView setFrame:CGRectMake(0, 0, 50, 50)];
            
            [cell.view4image addSubview:imageView];
            
            song.imageView = imageView;
            
            [self.songs setObject:song atIndexedSubscript:indexPath.row];
            
            [activityIndicator removeFromSuperview];
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } else {
        [cell.view4image addSubview:song.imageView];
    }
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center = cell.center;
    
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (indexPath.row < self.songs.count) {
        return [self songCellForIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
        [self fetchSongs];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.songsTableView indexPathForSelectedRow];
    
    if (indexPath) {
        Song *song = self.songs[indexPath.row];
        
        SongViewController *songVC = [segue destinationViewController];
        
        [songVC setImageUrl:song.imageUrl];
        [songVC setArtist:song.artist];
        [songVC setSong:song.name];
        [songVC setSongUrl:song.songUrl];
    }
}

- (void)fetchSongs {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-content-beeline.intech-global.com/public/marketplaces/1/tags/10/melodies?limit=%d&from=%d", _limit, _from]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        for (id songDictionary in [responseObject objectForKey:@"melodies"]) {
            Song *song = [[Song alloc] initWithDictionary:songDictionary];
            
            [self.songs addObject:song];
        }
        
        _from = self.songs.count;
        
        [self.songsTableView reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [[[UIAlertView alloc] initWithTitle:@"Ошибка загрузки данных!" message:@"Поробуйте позже" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles:nil, nil] show];
    }];
}

@end
