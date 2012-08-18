/*
    EffectsPlayer.m
 
    A sound effects player
 
    You can make an instance of this, but the intention is to
    use the provided singleton instance, which is conditionally instantiated
    The singleton instance (if any) is released by the AppDelegate at exit
 */

#import "MediaPlayer/MediaPlayer.h"
#import "EffectsPlayer.h"

@implementation EffectsPlayer

static EffectsPlayer *playerInstance = nil;

// Keep one instance to share

+ (EffectsPlayer *)instance 
{	
	@synchronized(self) 
	{
		if (! playerInstance)
			playerInstance = [[EffectsPlayer alloc] init];
	}
	
	return playerInstance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        //
    }
    return self;
}

- (void)dealloc
{
    [player release];
    [super dealloc];
}


- (void)play:(NSString *)filename atVolume:(float)volume
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])    
    {
        [player release];
    
        NSURL *url = [NSURL fileURLWithPath:path];
    
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        player.delegate = nil;
        [player setVolume:volume];
        [player play];
    }
}

// We check to see if the stupid MP player is playing a DRM sound and,
// if so, bypass the effect
- (void)snap
{
    if ([MPMusicPlayerController applicationMusicPlayer].playbackState != MPMusicPlaybackStatePlaying)
        [self play:@"snap.mp3" atVolume:0.4];
}

- (void)squish
{
    if ([MPMusicPlayerController applicationMusicPlayer].playbackState != MPMusicPlaybackStatePlaying)
        [self play:@"squish.mp3" atVolume:0.6];
}

- (void)clank
{
    if ([MPMusicPlayerController applicationMusicPlayer].playbackState != MPMusicPlaybackStatePlaying)
        [self play:@"clank.mp3" atVolume:0.5];
}

- (void)dream
{
    if ([MPMusicPlayerController applicationMusicPlayer].playbackState != MPMusicPlaybackStatePlaying)
        [self play:@"power_on.mp3" atVolume:0.1];
}

- (void)byebye
{
    if ([MPMusicPlayerController applicationMusicPlayer].playbackState != MPMusicPlaybackStatePlaying)
        [self play:@"power_off.mp3" atVolume:0.8];
}

@end
