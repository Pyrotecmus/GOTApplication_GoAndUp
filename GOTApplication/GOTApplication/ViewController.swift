//
//  ViewController.swift
//  GOTApplication
//
//  Created by Axel Imberdis on 17/09/2021.
//

import UIKit

class ViewController: UIViewController {

    final let url = URL(string: "https://beta.goandup.paris/got.json")
    private var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        downloadJson()
    }


    private func downloadJson() {
        guard let downloadURL = url
            else
        {
            return
        }
        
        URLSession.shared.dataTask(with: downloadURL)
        {
            data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil
            else
            {
                print(error)
                print("something went wrong before downloading")
                return
            }
            do
            {
                let decoding = try JSONDecoder().decode(Episodes.self, from: data)
                let list = decoding._embedded
                self.episodes = list.episodes
                
                DispatchQueue.main.async
                {
                    print(self.episodes)
                    //self.tableView.reloadData()
                }
            }
            catch
            {
                print(error)
                print("something went wrong after downloading")
            }
        }.resume()
    }
    
}

