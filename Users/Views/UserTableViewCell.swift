//
//  UserTableViewCell.swift
//  Users
//
//  Created by Ivan Petrukha on 15.06.2018.
//  Copyright © 2018 cellforrow. All rights reserved.
//

import UIKit

protocol UserTableViewCellDelegate: class {
    func userTableViewCellDidSelectURL(_ sender: UserTableViewCell)
}

class UserTableViewCell: UITableViewCell, Delegating {

    weak var delegate: UserTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.text = nil
        self.urlButton.setTitle(nil, for: [])
        self.avatarImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.avatarImageView.layer.cornerRadius = 7.0
    }
    
    @IBAction func urlButtonAction(_ sender: UIButton) {
        self.delegate?.userTableViewCellDidSelectURL(self)
    }
}

extension UserTableViewCell: Configurable {
    
    func configure(with user: User) {
        
        self.nameLabel.text = user.login
        self.urlButton.setTitle(user.htmlUrl, for: [])
        
        DispatchQueue.global(qos: .background).async {
            if let imageURL = URL(string: user.avatarUrl), let imageData = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    self.avatarImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
}
