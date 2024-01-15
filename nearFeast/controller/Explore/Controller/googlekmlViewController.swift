//
//  googlekmlViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 11/01/2024.
//

import UIKit
import GoogleMapsUtils
import GoogleMaps
class googlekmlViewController: UIViewController {

    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblDiscover: UILabel!
    var proArray = [CountryModel]()
    var filterProArray = [CountryModel]()
    var kmlParser: GMUKMLParser!
    var renderer: GMUGeometryRenderer!
    var selectedOverlay:GMSOverlay!
    var overlayArray = [GMSOverlay]()
    var selecteCountry: CountryModel!
    var select = true
    var isDiscover = false
    override func viewDidLoad() {
        super.viewDidLoad()

        /*self.proArray = [
            countrymodel(name: "Germany", image:  #imageLiteral(resourceName: "Germany") ),
            countrymodel(name: "Croatia", image:  #imageLiteral(resourceName: "Croatia") ),
            countrymodel(name: "United Kingdom", image:  #imageLiteral(resourceName: "United Kingdom") ),
            countrymodel(name: "Malta", image:  #imageLiteral(resourceName: "Malta") ),
            countrymodel(name: "Greece", image:  #imageLiteral(resourceName: "Greece") ),
            countrymodel(name: "Netherlands", image:  #imageLiteral(resourceName: "Netherlands") )
        ]*/
        // Do any additional setup after loading the view.
        mapView.settings.myLocationButton = false
        mapView.isMyLocationEnabled = false
        mapView.camera = GMSCameraPosition(target: .init(latitude: 55.3781, longitude: 3.436), zoom: 2.0)
        mapView.setMinZoom(2.0, maxZoom: 3.0)
        mapView.delegate = self
        self.setupGoogleMap()
    }
    func setupGoogleMap() {
        DispatchQueue.main.async {
            do {
                if let styleURL = Bundle.main.url(forResource: "style_map", withExtension: "json") {
                    self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    self.renderKml()
                } else {
                    NSLog("Unable to find style.json")
                    
                }
            } catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.bottomBarView.drawTwoCorner(roundTo: .top)
        self.loadData()
        
    }
    func renderKml(title:String? = nil) {
        DispatchQueue.main.async {
            guard let path = Bundle.main.path(forResource: "world-administrative-boundaries", ofType: "kml") else {
                print("Invalid path")
                return
            }
            if let render = self.renderer{
                render.clear()
            }
            let url = URL(fileURLWithPath: path)
            
            self.kmlParser = GMUKMLParser(url: url)
            self.kmlParser.parse()
            
            self.renderer = GMUGeometryRenderer(
                map: self.mapView,
                geometries: self.kmlParser.placemarks,
                styles: self.kmlParser.styles
            )
            
            self.renderer.render()
            if let overlays = self.renderer.mapOverlays(){
                self.overlayArray.removeAll()
                for over in overlays{
                    if let polygon = over as? GMSPolygon {
                        if let tit = title{
                            if tit == over.title{
                                polygon.strokeWidth = 1.8
                                polygon.strokeColor = UIColor.black
                                polygon.fillColor = UIColor.red
                                polygon.map = self.mapView
                                self.selectedOverlay = polygon
                            }
                            else{
                                polygon.strokeWidth = 1.2
                                polygon.strokeColor = UIColor.black
                                polygon.fillColor = UIColor.lightGray
                                polygon.map = self.mapView
                            }
                        }
                        else{
                            polygon.strokeWidth = 1.2
                            polygon.strokeColor = UIColor.black
                            polygon.fillColor = UIColor.lightGray
                            polygon.map = self.mapView
                        }
                        
                        self.overlayArray.append(polygon)
                    }
                }
            }
        }
        
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getCountryList { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.proArray = userData!
            self.filterProArray = self.proArray.filter({ CountryModel1 in
                if let discover = CountryModel1.discover{
                    if let bools = discover[FirebaseData.getCurrentUserId().0] {
                        if bools{
                            return false
                        }
                        else{
                            return true
                        }
                    }
                    else{
                        return true
                    }
                }
                else{
                    return true
                }
            })
            self.ivTableview.reloadData()
        }
    }
    func removeroverlay(){
        if let overlay = self.selectedOverlay{
            if let polygon = overlay as? GMSPolygon {
                polygon.strokeWidth = 1.2
                polygon.strokeColor = UIColor.black
                polygon.fillColor = UIColor.lightGray
            }
        }
    }
    func renderload(title:String,location:CLLocationCoordinate2D){
        //self.renderer.clear()
        //self.renderer.render()
        
        if let overlays = renderer.mapOverlays(){
            self.overlayArray.removeAll()
            for over in overlays{
                DispatchQueue.main.async {
                    if let polygon = over as? GMSPolygon {
                        //if let tit = title{
                        if title == over.title{
                            polygon.strokeWidth = 1.8
                            polygon.strokeColor = UIColor.black
                            polygon.fillColor = UIColor.red
                            polygon.map = self.mapView
                            self.selectedOverlay = polygon
                            self.mapView.animate(toLocation: location)
                            print("trueeeeeee")
                            print(over.title ?? "")
                            if self.select{
                                self.select = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                                    let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .ExploreDetailViewController) as! ExploreDetailViewController
                                    vc.countryData = self.selecteCountry
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    self.select = true
                                }
                            }
                        }
                        else{
                            print(over.title ?? "")
                            polygon.strokeWidth = 1.2
                            polygon.strokeColor = UIColor.black
                            polygon.fillColor = UIColor.lightGray
                            polygon.map = self.mapView
                        }
                        //}
                        //else{
                        // polygon.strokeWidth = 1.2
                        //polygon.strokeColor = UIColor.black
                        //polygon.fillColor = UIColor.lightGray
                        // polygon.map = self.mapView
                        //}
                        
                        self.overlayArray.append(polygon)
                    }
                }
            }
        }
    }
    @IBAction func discoverBtnPressed(_ sender:UIButton){
        if self.isDiscover{
            self.isDiscover = false
            self.lblDiscover.text = "To Discover"
            sender.setImage(#imageLiteral(resourceName: "Group 16282"), for: .normal)
        }
        else{
            self.isDiscover = true
            self.lblDiscover.text = "To All"
            sender.setImage(#imageLiteral(resourceName: "Group 16280"), for: .normal)
        }
        self.ivTableview.reloadData()
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
extension googlekmlViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isDiscover{
            return self.filterProArray.count
        }
        else{
            return self.proArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTableViewCell", for: indexPath) as! ExploreTableViewCell
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        if self.isDiscover{
            cell.lblName.text = self.filterProArray[indexPath.row].name
            cell.ivImage.imageURLProfile(self.filterProArray[indexPath.row].icon, placholdr: #imageLiteral(resourceName: "01 – 1"))
            if let discover = self.filterProArray[indexPath.row].discover{
                if let bools = discover[FirebaseData.getCurrentUserId().0] {
                    if bools{
                        cell.ivDiscoverImage.image = #imageLiteral(resourceName: "Dish open")
                    }
                    else{
                        cell.ivDiscoverImage.image = #imageLiteral(resourceName: "Dish close")
                    }
                }
                else{
                    cell.ivDiscoverImage.image = #imageLiteral(resourceName: "Dish close")
                }
            }
            else{
                cell.ivDiscoverImage.image = #imageLiteral(resourceName: "Dish close")
            }
            
        }
        else{
            cell.lblName.text = self.proArray[indexPath.row].name
            cell.ivImage.imageURLProfile(self.proArray[indexPath.row].icon, placholdr: #imageLiteral(resourceName: "01 – 1"))
            if let discover = self.proArray[indexPath.row].discover{
                if let bools = discover[FirebaseData.getCurrentUserId().0] {
                    if bools{
                        cell.ivDiscoverImage.image = #imageLiteral(resourceName: "Dish open")
                    }
                    else{
                        cell.ivDiscoverImage.image = #imageLiteral(resourceName: "Dish close")
                    }
                }
                else{
                    cell.ivDiscoverImage.image = #imageLiteral(resourceName: "Dish close")
                }
            }
            else{
                cell.ivDiscoverImage.image = #imageLiteral(resourceName: "Dish close")
            }
        }
        
        cell.animate(.slideFade(way: .in, direction: .right), duration: 2.0, damping: 0.6, velocity: 1.0, force: 1.0).completion {
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isDiscover{
            self.selecteCountry = self.filterProArray[indexPath.row]
            self.renderload(title: self.filterProArray[indexPath.row].name, location: CLLocationCoordinate2D(latitude: self.filterProArray[indexPath.row].lat, longitude: self.filterProArray[indexPath.row].lng))
        }
        else{
            self.selecteCountry = self.proArray[indexPath.row]
            self.renderload(title: self.proArray[indexPath.row].name, location: CLLocationCoordinate2D(latitude: self.proArray[indexPath.row].lat, longitude: self.proArray[indexPath.row].lng))
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension googlekmlViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print(overlay.title ?? "")
//        if let coutry = self.selecteCountry,let title = overlay.title{
//            if coutry.name == title{
//                let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .ExploreDetailViewController) as! ExploreDetailViewController
//                vc.countryData = self.selecteCountry
//                //self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//        self.removeroverlay()
//        if let polygon = overlay as? GMSPolygon {
//            polygon.strokeWidth = 1.8
//                    polygon.strokeColor = UIColor.black
//                    polygon.fillColor = UIColor.red
//            self.selectedOverlay = polygon
//                }
    }
    
}
