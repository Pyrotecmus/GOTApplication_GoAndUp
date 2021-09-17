//
//  EpisodeTableViewController.swift
//  GOTApplication
//
//  Created by Axel Imberdis on 17/09/2021.
//

import Foundation
import UIKit

class EpisodeTableViewController: UITableViewController {
    final let url = URL(string: "https://beta.goandup.paris/got.json")
    private var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "EpisodeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EpisodeTableViewCell
        else
        {
            fatalError("The dequeued cell is not an instance of FilmTableViewCell")
        }
        
        
        cell.episodeName.text = episodes[indexPath.row].name
        cell.whichOne.text = "season " + String(episodes[indexPath.row].season) + " episode " + String(episodes[indexPath.row].number)
        getData(from: URL(string: episodes[indexPath.row].image.medium)!) { data, response, error in
            guard let data = data, error == nil else { return }
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                cell.episodeImage.image = UIImage(data: data)
            }
        }
        
        return cell
    }

    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
                    self.tableView.reloadData()
                }
            }
            catch
            {
                print(error)
                print("something went wrong after downloading")
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        let destinationNavigationController = segue.destination as! UINavigationController
            
        let targetController = destinationNavigationController.viewControllers.first as! DetailsViewController?
            
            
        guard let selectedFilmCell = sender as? EpisodeTableViewCell
            else
        {
            fatalError("Unexpected sender : \(sender)")
        }
            
        guard let indexPath = tableView.indexPath(for: selectedFilmCell)
            else
        {
            fatalError("The selected cell is not being displayed by the table")
        }
            
        let selectedEpisode = episodes[indexPath.row]
        
        targetController?.episode = selectedEpisode
    }
}

