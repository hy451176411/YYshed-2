//
//  ImageMacro.h
//  CBExtension
//
//  Created by  ly on 13-6-15.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#ifndef ProjectStructure_ImageMacro_h
#define ProjectStructure_ImageMacro_h

#define CachedImage(image)   [UIImage imageNamed:(image)]
#define ImageWithPath(path)  [UIImage imageWithContentsOfFile:(path)]
#define ImageWithImgName(name)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]

#endif
