//
//  CircleView.swift
//  PatchworxSocial
//
//  Created by Paul Denton on 22/11/2016.
//  Copyright © 2016 patchworx. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }

}
