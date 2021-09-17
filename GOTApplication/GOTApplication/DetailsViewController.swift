//
//  DetailsViewController.swift
//  GOTApplication
//
//  Created by Axel Imberdis on 17/09/2021.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    var episode: Episode?
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var episodedate: UILabel!
    @IBOutlet weak var episodeDescription: UILabel!
    @IBOutlet weak var episodeRuntime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(from: URL(string: (episode?.image.medium)!)!) { data, response, error in
            guard let data = data, error == nil else { return }
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self!.episodeImage.image = UIImage(data: data)
            }
        }
        
        episodeName.text = episode?.name
        episodedate.text = "Paru le " + episode!.airdate
        let htmlData = NSString(string: episode!.summary).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                  options: options,
                                                                  documentAttributes: nil)
        
        episodeDescription.text = attributedString?.string
        episodeRuntime.text = "Durée " + String(episode!.runtime) + " minutes"
        
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    @IBAction func EpisodeUrl(_ sender: Any) {
        if let url = URL(string: episode!.url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func Share(_ sender: Any) {
        
        let firstActivityItem = "Share the link"

        let secondActivityItem : NSURL = NSURL(string: episode!.url)!

        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
            
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.mail,
            UIActivity.ActivityType.airDrop
        ] as? UIActivityItemsConfigurationReading
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}
