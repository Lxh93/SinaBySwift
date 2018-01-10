//
//  LXHTitleButton.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/12.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

class LXHTitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 1.设置标题颜色
        self.setTitleColor(UIColor.orange, for: .normal)
        // 2.设置标题字体大小
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        // 3.设置图标
        self.setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        self.setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.bounds.size.width
    }
    
}

//- (void)encodeWithCoder:(NSCoder *)encoder
//
//{
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([Movie class], &count);
//
//    for (int i = 0; i<count; i++) {
//        // 取出i位置对应的成员变量
//        Ivar ivar = ivars[i];
//        // 查看成员变量
//        const char *name = ivar_getName(ivar);
//        // 归档
//        NSString *key = [NSString stringWithUTF8String:name];
//        id value = [self valueForKey:key];
//        [encoder encodeObject:value forKey:key];
//    }
//    free(ivars);
//    }
//
//    - (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        unsigned int count = 0;
//        Ivar *ivars = class_copyIvarList([Movie class], &count);
//        for (int i = 0; i<count; i++) {
//            // 取出i位置对应的成员变量
//            Ivar ivar = ivars[i];
//            // 查看成员变量
//            const char *name = ivar_getName(ivar);
//            // 归档
//            NSString *key = [NSString stringWithUTF8String:name];
//            id value = [decoder decodeObjectForKey:key];
//            // 设置到成员变量身上
//            [self setValue:value forKey:key];
//
//        }
//        free(ivars);
//    }
//    return self;
//}
//@end

