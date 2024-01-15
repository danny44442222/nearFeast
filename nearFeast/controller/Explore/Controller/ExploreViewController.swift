//
//  ExploreViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 21/11/2023.
//

import UIKit
import GoogleMapsUtils
import GoogleMaps

struct countrymodel{
    var name:String!
    var image:UIImage!
}
class ExploreViewController: UIViewController {

    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    @IBOutlet weak var mapView: UIImageView!
    @IBOutlet weak var lblDiscover: UILabel!
    var proArray = [CountryModel]()
    var filterProArray = [CountryModel]()
    var selecteCountry: CountryModel!
    var select = true
    var isDiscover = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.bottomBarView.drawTwoCorner(roundTo: .top)
        self.loadData()
        
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
    func renderload(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20){
            let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .ExploreDetailViewController) as! ExploreDetailViewController
            vc.countryData = self.selecteCountry
            self.navigationController?.pushViewController(vc, animated: true)
            self.select = true
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
extension ExploreViewController:UITableViewDelegate,UITableViewDataSource{
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
            
            self.renderload()
        }
        else{
            self.selecteCountry = self.proArray[indexPath.row]
            self.renderload()
        }
        self.mapView.image = UIImage(named: self.selecteCountry.name)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

