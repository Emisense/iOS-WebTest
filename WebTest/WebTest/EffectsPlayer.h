/*
    EffectsPlayer.h
 
    A sound effects player
 
    You can make an instance of this, but the intention is to
    use the provided singleton instance, which is conditionally instantiated
    The singleton instance (if any) is released by the AppDelegate at exit
*/

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface EffectsPlayer : NSObject {
    AVAudioPlayer *player;
}

+ (EffectsPlayer *)instance;

- (void)snap;
- (void)squish;
- (void)clank;
- (void)dream;
- (void)byebye;

@end
