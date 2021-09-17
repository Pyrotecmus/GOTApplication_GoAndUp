//
//  EpisodeTableViweCell.swift
//  GOTApplication
//
//  Created by Axel Imberdis on 17/09/2021.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell
{
    //MARK: Properties
    @IBOutlet weak var whichOne: UILabel!
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
