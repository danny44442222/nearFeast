//
//  AllYelpViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 11/01/2024.
//

import UIKit
import CoreLocation
import GoogleMaps
class AllYelpViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    var isSearch = false
    var restArray = [YelpRestModel]()
    var filterRestArray = [YelpRestModel]()
    var locationManager = CLLocationManager()
    var curentPosition: CLLocationCoordinate2D!
    var curentLoc: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
       // bottomTabBarView.applyGradient(colors: [.init(red: 210.0, green: 26.0, blue: 0.01, alpha: 1.0), .init(red: 182.0, green: 0.0, blue: 4.0, alpha: 1.0)], angle: 130.0)
        self.setupController()
    }
    private func setupController() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    func loadRestauentapi(_ address:String){
        PopupHelper.showAnimating(self)
        var dataDic = [String:Any]()
        dataDic[Constant.term] = Constant.restaurant
        dataDic[Constant.location] = address
        self.callWebService(data:dataDic,action:.businesses_search,.get)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text,!text.isEmpty{
            self.isSearch = true
            self.filterRestArray = self.restArray.filter({ remind in
                if let name = remind.name,!name.isEmpty,name.lowercased().contains(text.lowercased()){
                    print("notes")
                    return true
                }
                if let details = remind.country,!details.isEmpty,details.lowercased().contains(text.lowercased()){
                    print("type")
                    return true
                }
                return false
                
            })
        }
        else{
            self.isSearch = false
            self.filterRestArray.removeAll()
        }
        self.collectionView.reloadData()
    }
    func callWebService(_ id:String? = nil,data: [String:Any]? = nil, action:webserviceUrl,_ httpMethod:httpMethod){
        
        WebServicesHelper.callWebService(Parameters: data,suburl: id, action: action, httpMethodName: httpMethod) { (indx,action,isNetwork, error, dataDict) in
            self.stopAnimating()
            print(dataDict)
            
            if isNetwork{
                if let err = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                }
                else{
                    if let dic = dataDict as? Dictionary<String,Any>{
                        switch action {
                        case .businesses_search:
                            if let businesses = dic["businesses"] as? NSArray{
                                self.restArray.removeAll()
                                for dada in businesses{
                                    let model = YelpRestModel(dic: dada as! NSDictionary)
                                    self.restArray.append(model!)
                                }
                                self.collectionView.reloadData()
                            }
                            else if let msg = dic[Constant.message] as? String{
                                PopupHelper.showAlertControllerWithError(forErrorMessage: msg, forViewController: self)
                            }
                        default:
                            break
                        }
                        
                    }
                    else{
                        PopupHelper.showAlertControllerWithError(forErrorMessage: "something went wrong", forViewController: self)
                    }
                }
            }
            else{
                PopupHelper.alertWithNetwork(title: "Network Connection", message: "Please connect your internet connection", controler: self)
                
            }
        }
    }
}
extension AllYelpViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isSearch = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty{
            self.isSearch = false
        }
        else{
            self.isSearch = true
        }
        self.collectionView.reloadData()
    }
}
extension AllYelpViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSearch{
            return self.filterRestArray.count
        }
        else{
            return self.restArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        if self.isSearch{
            cell.lblName.text = self.filterRestArray[indexPath.row].name
            cell.lblDetail.text = self.filterRestArray[indexPath.row].name
            if let image = self.filterRestArray[indexPath.row].image_url{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let rating = self.filterRestArray[indexPath.row].rating{

                cell.lblRating.text = "\(rating)"
                cell.lblRateCount.text = "(\(self.filterRestArray[indexPath.row].review_count ?? 0))"
                cell.vRating.rating = rating
            }
            else{
                cell.lblRateCount.text = "(0)"
                cell.lblRating.text = "0.0"
                cell.vRating.rating = 1
            }
        }
        else{
            cell.lblName.text = self.restArray[indexPath.row].name
            cell.lblDetail.text = self.restArray[indexPath.row].name
            if let image = self.restArray[indexPath.row].image_url{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let rating = self.restArray[indexPath.row].rating{
                
                cell.lblRating.text = "\(rating)"
                cell.lblRateCount.text = "(\(self.restArray[indexPath.row].review_count ?? 0))"
                cell.vRating.rating = rating
            }
            else{
                cell.lblRateCount.text = "(0)"
                cell.lblRating.text = "0.0"
                cell.vRating.rating = 1
            }
        }
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.addShadowColor(shadowColor: UIColor.black, offSet: CGSize(width: 0.0, height: 1.0), opacity: 0.2, shadowRadius: 3.0, cornerRadius: 16, corners: UIRectCorner.allCorners, fillColor: UIColor.white)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/2 - 40
        let height = width + 20
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let urlDestination = URL.init(string: self.restArray[indexPath.row].url) {
            UIApplication.shared.open(urlDestination)
        }
    }
}
extension AllYelpViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")
      self.curentLoc = location
    self.curentPosition = location.coordinate
    if self.curentPosition != nil{
        manager.stopUpdatingLocation()
    }
      let geocoder = GMSGeocoder()
      geocoder.reverseGeocodeCoordinate(location.coordinate){response , error in
          guard let address: GMSAddress = response?.firstResult()
              else
          {
              return
          }
          self.loadRestauentapi(address.locality ?? "New York")
      }
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
        PopupHelper.alertWithAppSetting(title: "Alert", message: "Please enable your location", controler: self)
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}
