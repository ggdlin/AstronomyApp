//
//  ViewController.swift
//  AstronomyApp
//
//  Created by Ivanov Sergey on 13.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let urlPictureOfTheDay = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.color = .blue
        stackView.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchData()
    }
}

extension ViewController {
    
    func fetchData() {
        guard let url = URL(string: urlPictureOfTheDay) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                print("unable dataFetch, error: \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            do {
                let potd = try JSONDecoder().decode(AstronomyPicture.self, from: data)
                if let url = URL(string: potd.url) {
                                        
                    URLSession.shared.dataTask(with: url) { (data, _, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        guard let data = data, let image = UIImage(data: data) else { return }
                        
                        DispatchQueue.main.async {
                            self.titleLabel.text = "\(potd.date) \(potd.title)"
                            self.explanationLabel.text = potd.explanation
                            self.imageView.image = image
                            self.activityIndicator.stopAnimating()
                            self.stackView.isHidden.toggle()
                        }
                        
                    }.resume()
                }
            } catch let error {
                print("error JSON decode: \(error)")
            }
        }.resume()
    }
}
