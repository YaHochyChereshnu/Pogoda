//
//  citiesTVC.swift
//  Semenuk_Pogoda
//
//  Created by user on 30.04.2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class citiesTVC: UITableViewController {
    
    @IBOutlet weak var citytableView: UITableView!
   
    var cityName = ""
    
    struct Cities {
        var cityName = ""
        var cityTemp = 0.0
    }
    
    var cityTempArray: [Cities] = [Cities(cityName: "Moscow", cityTemp: 3.0)]
    
    func currentWeather(city: String) {
        let url = "http://api.weatherapi.com/v1/current.json?key=924a3bd9bac54d64b4765422213004&q=\(city)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let name = json["location"][]["name"].stringValue
                let temp = json["current"][]["temp_c"].doubleValue
                self.cityTempArray.append(Cities(cityName: name, cityTemp: temp))
                self.citytableView.reloadData()
            case .failure(let error):
                print(error)
        
            }
        }
        
    }

    @IBAction func addCityAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Добавить", message: "Введите название города", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Moscow"
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let newCityAction = UIAlertAction(title: "Добавить", style: .default) {
            (action) in
            let name = alert.textFields![0].text
            self.currentWeather(city: name!)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(newCityAction)
        
        self.present(alert, animated: true, completion: nil)
        print(cityTempArray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        citytableView.delegate = self
        citytableView.dataSource = self
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityTempArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! citiesNameCell

        cell.cityName.text = cityTempArray[indexPath.row].cityName
        cell.cityTemp.text = String(cityTempArray[indexPath.row].cityTemp)

        return cell
    }
    
 
       
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        cityName = cityTempArray[indexPath.row].cityName
        performSegue(withIdentifier: "detailVC", sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetViewController {
            vc.cityName = cityName
        }
       
    }
}

