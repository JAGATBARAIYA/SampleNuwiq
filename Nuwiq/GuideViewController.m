//
//  GuideViewController.m
//  Nuwiq
//
//  Created by Manish on 27/08/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "GuideViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Common.h"

@interface GuideViewController ()
{
    MPMoviePlayerController *theMoviPlayer;
}

@property (strong, nonatomic) IBOutlet UIView *videoView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"nuwiq" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    theMoviPlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    theMoviPlayer.controlStyle = MPMovieControlStyleDefault;
    if (IPHONE6PLUS){
        theMoviPlayer.view.frame = CGRectMake(8, 0, 382, 200);
    }else if (IPHONE6){
        theMoviPlayer.view.frame = CGRectMake(8, 0, 340, 200);
    }else if (IPHONE4 || IPHONE5) {
        theMoviPlayer.view.frame = CGRectMake(8, 0, 290, 200);
    }
    [_videoView addSubview:theMoviPlayer.view];
    [theMoviPlayer.view bringSubviewToFront:self.view];
    [theMoviPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
