//
//  SegueFromLeft.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/23/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class SegueFromLeft: UIStoryboardSegue {
  // Segue gesture from Right to Left
  override func perform()
  {
    let src = self.source
    let dst = self.destination
    
    src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
    // add -src.view.frame.size.width to change Left to Right
    dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
    
    UIView.animate(withDuration: 0.25,
                   delay: 0.0,
                   options: [.curveEaseIn, .curveEaseOut],
                   animations: {
                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
    },
                   completion: { finished in
                    // We must use dismiss for unwind segue
                    // If we want to use this for normal segue, we have to change to
                    // src.present(dst, animated: false, completion: nil)
                    src.dismiss(animated: false, completion: nil)
    }
    )
  }
}
