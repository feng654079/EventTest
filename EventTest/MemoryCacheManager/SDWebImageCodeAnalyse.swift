//
//  SDWebImageCodeAnalyse.swift
//  EventTest
//
//  Created by apple on 2021/1/20.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import SnapKit
import SDWebImage

class SDWebImageCodeAnalyseVC: UIViewController {
    
    let imageView = UIImageView(frame: .zero)
    let refreshBtn = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    func setupUI() {
        self.view.addSubview(imageView)
        self.view.addSubview(refreshBtn)
        
        imageView.snp.makeConstraints { (m) in
            m.size.equalTo(CGSize(width: 200, height: 200))
            m.center.equalTo(view)
        }
        
        refreshBtn.setTitle("刷新", for: .normal)
        refreshBtn.setTitleColor(.blue, for: .normal)
        refreshBtn.snp.makeConstraints { (m) in
            m.centerX.equalTo(imageView)
            m.top.equalTo(imageView.snp_bottomMargin).offset(20)
        }
    }
    
    func setupActions() {
        refreshBtn.addTarget(self, action: #selector(refreshBtnTouched(_:)), for: .touchUpInside)
    }
    
    @objc func refreshBtnTouched(_ sender:UIButton) {
    debugPrint(NSHomeDirectory())
        imageView.sd_setImage(with: URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201407%2F10%2F095206sh0sls6xkmsklh3x.jpg.thumb.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1613714825&t=a24ecf3ce0fccbe022f24835f7b69cb9"))
        
        
    }
}
