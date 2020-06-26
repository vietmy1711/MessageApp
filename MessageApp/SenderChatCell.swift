//
//  SenderChatCell.swift
//  MessageApp
//
//  Created by MM on 6/25/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit

class SenderChatCell: UITableViewCell {

    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imvImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        imvImage.image = nil
        imvAvatar.isHidden = false
    }
    
    func setupCell() {
        imvAvatar.layer.cornerRadius = 16
        vwContainer.layer.cornerRadius = 8
        imageView?.layer.cornerRadius = 8
    }
    
    func configWithMessage(message: Message, isSuccessive: Bool) {
        lblText.text = message.text
        if isSuccessive {
            imvAvatar.isHidden = true
        }
        if var image = message.image {
            while image.size.width > 300 || image.size.height > 300 {
                if image.size.width > 300 {
                    let ratio: CGFloat = CGFloat(image.size.width / 300)
                    let targetSize = CGSize(width: image.size.width / ratio, height: image.size.height / ratio)
                    image = resizeImage(image: image, targetSize: targetSize)
                }
                if image.size.height > 300 {
                    let ratio: CGFloat = CGFloat(image.size.height / 300)
                    let targetSize = CGSize(width: image.size.width / ratio, height: image.size.height / ratio)
                    image = resizeImage(image: image, targetSize: targetSize)
                }
            }
            imvImage.image = image
        }
    }
    
   func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
       let size = image.size

       let widthRatio  = targetSize.width  / size.width
       let heightRatio = targetSize.height / size.height

       // Figure out what our orientation is, and use that to form the rectangle
       var newSize: CGSize
       if(widthRatio > heightRatio) {
           newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
       } else {
           newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
       }

       // This is the rect that we've calculated out and this is what is actually used below
       let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

       // Actually do the resizing to the rect using the ImageContext stuff
       UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
       image.draw(in: rect)
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return newImage!
   }
}
