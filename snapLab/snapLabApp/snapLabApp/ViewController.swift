//
//  ViewController.swift
//  snapLabApp
//
//  Created by Ricardo Diaz on 3/21/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func getAirQualityButton(_ sender: Any) {
        // make an api call
        // parse the response
        // show the proper image based on the response
        fetchAirQuality()
        
    }
    
    func fetchAirQuality() {
        // http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
        
        //get components for API call
        let apiKey = ""
        // apiKey omitted for obvious reasons heh heh
        let city = "Los Angeles"
        let state = "California"
        let country = "USA"
        
        let urlString = "https://api.airvisual.com/v2/city?city=\(city)&state=\(state)&country=\(country)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Incorrect Website")
            return
        }
        
        // Make API Call
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print("Data: \(data)")
            print("Response: \(response)")
            print("Error: \(error)")
            
            // Parse API response
            guard let responseData = data else {
                // Let user know that there is no data
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let dataFromjson = json["data"] as? [String: Any],
                   let currentFromJson = dataFromjson["current"] as? [String: Any],
                   let pollutionFromJson = currentFromJson["pollution"] as? [String: Any],
                   let aqius = pollutionFromJson["aqius"] as? Int
                {
                    DispatchQueue.main.async {
                        self.showImageForAqiusValue(aqius)
                    }
                }
                
            } catch {
                // Let user know that there is no data
                print("Error getting json")
            }
        }
        
        task.resume()
        // video stopped at 1:04:21
        // Show the right image
    }
    
    func showImageForAqiusValue(_ value: Int) {
        print("Aq value is: \(value)")
        if (value <= 50) {
            // Show good image
            // airQualityHappy
            myImageView.image = UIImage(named: "airQualityHappy")
        } else if (value <= 100) {
            // show ok image
            // airQualityMeh
            myImageView.image = UIImage(named: "airQualityMeh")
        } else {
            // Show bad airquality image
            // airQualityGloomy
            myImageView.image = UIImage(named: "airQualityGloomy")
        }
    }

}

