//
//  SongViewController.m
//  songs
//
//  ► by Сергей Фролов on 18.02.16.
//  Copyright © 2016 Cebrit. All rights reserved.
//

#import "SongViewController.h"
#import "AFNetworking.h"


@interface SongViewController ()
@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (IBAction)controlClick:(UIButton *)sender;

@end

@implementation SongViewController

@synthesize imageUrl, songUrl, artist, song;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center = self.imageContentView.center;
    
    [self.imageContentView addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    [self.controlBtn setTitle:@"►" forState:UIControlStateNormal];
    
    self.artistLabel.text = self.artist;
    self.songLabel.text   = self.song;
    
    NSURL *url = [NSURL URLWithString:self.imageUrl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, UIImage *responseImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:responseImage];
        
        [imageView setFrame:CGRectMake(0, 0, 200, 200)];
        
        //imageView.center = self.imageContentView.center;
        
        //[imageView sizeToFit];
        
        [self.imageContentView addSubview:imageView];
        
        [activityIndicator removeFromSuperview];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)controlClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"||"]) {
        [sender setTitle:@"►" forState:UIControlStateNormal];
        
        [self.audioPlayer stop];
        
    } else {
        [sender setTitle:@"||" forState:UIControlStateNormal];
        
        NSURL *playUrl    = [NSURL URLWithString:self.songUrl];
        NSData *soundData = [NSData dataWithContentsOfURL:playUrl];
        
        NSError *error;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        
        if (!error) {
            
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
        } else {
            NSLog(@"Error: %@", error);
            
            [[[UIAlertView alloc] initWithTitle:@"Произошла ошибка" message:@"Попробуйте позже" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles:nil, nil] show];
        }
    }
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.controlBtn setTitle:@"►" forState:UIControlStateNormal];
}

@end
