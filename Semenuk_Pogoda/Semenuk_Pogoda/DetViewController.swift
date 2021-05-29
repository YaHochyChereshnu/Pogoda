//
//  DetViewController.swift
//  Semenuk_Pogoda
//
//  Created by user on 14.05.2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetViewController: UIViewController {

    var cityName = ""

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temp_c: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let colorTop = UIColor(red: 89/255, green: 156/255, blue: 169/255, alpha: 1.0).cgColor
//        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.view.bounds
//        gradientLayer.colors = [colorTop, colorBottom]
//        gradientLayer.locations = [0.0, 1.0]
//        self.view.layer.addSublayer(gradientLayer)
//        
        currentWeather(city: cityName)
    }
    
    func currentWeather(city: String) {
        let url = "http://api.weatherapi.com/v1/current.json?key=924a3bd9bac54d64b4765422213004&q=\(city)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                print(value)
                let name = json["location"]["name"].stringValue
                let temp = json["current"]["temp_c"].doubleValue
                let country = json["location"]["country"].stringValue
                let weatherURLString = "http:\(json["current"]["condition"]["icon"].stringValue)"
                print(weatherURLString)
                self.cityNameLabel.text = name
                self.temp_c.text = String(temp)
                self.countryLabel.text = country
                
                let weatherURL = URL(string: weatherURLString)
                if let data = try? Data(contentsOf: weatherURL!) {
                    self.imageWeather.image = UIImage(data: data)
                }
                
            case.failure(let error):
                print(error)
            }
        }
        
    }

}
