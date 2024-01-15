//
//  RestaurantReviewViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 26/12/2023.
//

import UIKit
struct resRev{
    var name:ResReviewKeys!
    var rating:Double!
}
class RestaurantReviewViewController: UIViewController {

    //@IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    var rateArray = [ResReviewModel]()
    var ratArray = [resRev]()
    var restaurentData:RestaurantModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        //self.bottomBarView.drawTwoCorner(roundTo: .top)
        self.loadData()
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getRestReviewList(self.restaurentData.docId) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.rateArray = userData!
            var service, foodQuality, ambience, cleanliness, valueforPrice, menuVariety, speedofService, location, specialAccommodations, beverageSelection, kidFriendliness, noiseLevel, wifiQuality, parkingEase: Double!
            (service, foodQuality, ambience, cleanliness, valueforPrice, menuVariety, speedofService, location, specialAccommodations, beverageSelection, kidFriendliness, noiseLevel, wifiQuality, parkingEase) = (0,0,0,0,0,0,0,0,0,0,0,0,0,0)
            for rate in self.rateArray{
                if let Service = rate.Service{
                    
                    service += Service
                }
                if let FoodQuality = rate.FoodQuality{
                    foodQuality += FoodQuality
                }
                if let Ambience = rate.Ambience{
                    ambience += Ambience
                }
                if let Cleanliness = rate.Cleanliness{
                    cleanliness += Cleanliness
                }
                if let ValueforPrice = rate.ValueforPrice{
                    valueforPrice += ValueforPrice
                }
                if let MenuVariety = rate.MenuVariety{
                    menuVariety += MenuVariety
                }
                if let SpeedofService = rate.SpeedofService{
                    speedofService += SpeedofService
                }
                if let Location = rate.Location{
                    location += Location
                }
                if let SpecialAccommodations = rate.SpecialAccommodations{
                    specialAccommodations += SpecialAccommodations
                }
                if let BeverageSelection = rate.BeverageSelection{
                    beverageSelection += BeverageSelection
                }
                if let KidFriendliness = rate.KidFriendliness{
                    kidFriendliness += KidFriendliness
                }
                if let NoiseLevel = rate.NoiseLevel{
                    noiseLevel += NoiseLevel
                }
                if let WifiQuality = rate.WifiQuality{
                    wifiQuality += WifiQuality
                }
                if let ParkingEase = rate.ParkingEase{
                    parkingEase += ParkingEase
                }
            }
            self.ratArray = [
                resRev(name: .Service, rating: service),
                resRev(name: .FoodQuality, rating: foodQuality),
                resRev(name: .Ambience, rating: ambience),
                resRev(name: .Cleanliness, rating: cleanliness),
                resRev(name: .ValueforPrice, rating: valueforPrice),
                resRev(name: .MenuVariety, rating: menuVariety),
                resRev(name: .SpeedofService, rating: speedofService),
                resRev(name: .Location, rating: location),
                resRev(name: .SpecialAccommodations, rating: specialAccommodations),
                resRev(name: .BeverageSelection, rating: beverageSelection),
                resRev(name: .KidFriendliness, rating: kidFriendliness),
                resRev(name: .NoiseLevel, rating: noiseLevel),
                resRev(name: .WifiQuality, rating: wifiQuality),
                resRev(name: .ParkingEase, rating: parkingEase)
            ]
            
            self.ivTableview.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RestaurantReviewViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantReviewTableViewCell", for: indexPath) as! RestaurantReviewTableViewCell
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        cell.lblName.text = self.ratArray[indexPath.row].name.rawValue
        if let rating = self.ratArray[indexPath.row].rating{
            
            cell.vRating.rating = rating
        }
        else{
            cell.vRating.rating = 0
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
