//
//  SVGAData.swift
//  giftswift
//
//  Created by kevin on 2020/5/5.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

/**

NSArray *items = @[
                       @"https://github.com/yyued/SVGA-Samples/blob/master/EmptyState.svga?raw=true",
                       @"https://github.com/yyued/SVGA-Samples/blob/master/HamburgerArrow.svga?raw=true",
                       @"https://github.com/yyued/SVGA-Samples/blob/master/PinJump.svga?raw=true",
                       @"https://github.com/svga/SVGA-Samples/raw/master/Rocket.svga",
                       @"https://github.com/yyued/SVGA-Samples/blob/master/TwitterHeart.svga?raw=true",
                       @"https://github.com/yyued/SVGA-Samples/blob/master/Walkthrough.svga?raw=true",
                       @"https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true",
                       @"https://github.com/yyued/SVGA-Samples/blob/master/halloween.svga?raw=true",
                       @"https://github.com/yyued/SVGA-Samples/blob/master/kingset.svga?raw=true",
                       @"https://github.com/yyued/SVGA-Samples/blob/master/posche.svga?raw=true",
                       @"https://github.com/yyued/SVGA-Samples/blob/master/rose.svga?raw=true",
                       ];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [parser parseWithURL:[NSURL URLWithString:items[arc4random() % items.count]]
         completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             if (videoItem != nil) {
                 self.aPlayer.videoItem = videoItem;
                 NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
                 [para setLineBreakMode:NSLineBreakByTruncatingTail];
                 [para setAlignment:NSTextAlignmentCenter];
                 NSAttributedString *str = [[NSAttributedString alloc]
                                            initWithString:@"Hello, World! Hello, World!"
                                            attributes:@{
                                                NSFontAttributeName: [UIFont systemFontOfSize:28],
                                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                                NSParagraphStyleAttributeName: para,
                                            }];
                 [self.aPlayer setAttributedText:str forKey:@"banner"];
                 [self.aPlayer startAnimation];
             }
         } failureBlock:nil];

//        [parser parseWithURL:[NSURL URLWithString:@"https://github.com/svga/SVGA-Samples/raw/master_aep/BitmapColorArea1.svga"] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
//            if (videoItem != nil) {
//                self.aPlayer.videoItem = videoItem;
//                [self.aPlayer setImageWithURL:[NSURL URLWithString: @"https://i.imgur.com/vd4GuUh.png"] forKey:@"matte_EEKdlEml.matte"];
//                [self.aPlayer startAnimation];
//            }
//        } failureBlock:nil];
    
//    [parser parseWithNamed:@"Rocket" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
//        self.aPlayer.videoItem = videoItem;
//        [self.aPlayer startAnimation];
//    } failureBlock:nil];

*/

struct SVGAData {

    static let parser = SVGAParser()
    
    static func loadData() ->Promise<SVGAVideoEntity?> {
        
        let url = "https://github.com/yyued/SVGA-Samples/blob/master/rose.svga?raw=true"
        
        return Promise<SVGAVideoEntity?> { (filfull, reject) in
            
            guard let theUrl = URL(string: url) else {
                reject(KVError(msg: "url is null", code: -1))
                KLog("加载svga失败")
                return
            }
            
            parser.parse(with: theUrl, completionBlock: { (entity) in
                filfull(entity)
                
            }) { (error) in
                KLog("解析svga失败")
                reject(KVError(msg: "解析svga错误", code: -1))
                
            }
        
        }
        
    }
    
    
}
