//
//  ExploreDetailViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 21/11/2023.
//

import UIKit

struct itemmodel{
    var name:String!
    var item:[TraditionDishModel]!
}
class ExploreDetailViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var proArray = [itemmodel]()
    var countryData: CountryModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTitle.text = self.countryData.name
        // Do any additional setup after loading the view.
        self.updateDiscover()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.loadData()
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getTraditionalDishByCountryList(self.countryData.docId) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            guard let userData = userData else{return}
            if userData.count > 0{
                let data = Dictionary(grouping: userData) { data in
                    return data.type
                }
                if data.count > 0{
                    self.proArray.removeAll()
                    for ids in data.keys{
                        self.proArray.append(itemmodel(name: ids,item: data[ids]))
                    }
                    self.proArray.sort { itemmodel1, itemmodel2 in
                        return itemmodel1.name < itemmodel2.name
                    }
                    for (i,_) in self.proArray.enumerated(){
                        self.proArray[i].item.sort { TraditionDishModel1, TraditionDishModel2 in
                            return TraditionDishModel1.name < TraditionDishModel2.name
                        }
                    }
                }
            }
            self.ivTableview.reloadData()
        }
    }
    func updateDiscover(){
        let count = CountryModel()
        var dic = [String:Bool]()
        if let discovr = self.countryData.discover{
            dic = discovr
        }
        dic[FirebaseData.getCurrentUserId().0] = true
        count.discover = dic
        FirebaseData.updateCountriesData(self.countryData.docId, dic: count) { error in
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
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
extension ExploreDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.proArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreDetail0TableViewCell", for: indexPath) as! ExploreDetail0TableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.lblName.text = self.countryData.name
            cell.lblDetail.text = self.countryData.details
            if let image = self.countryData.image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            else{
                cell.ivImage.image = #imageLiteral(resourceName: "01 – 1")
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreDetail1TableViewCell", for: indexPath) as! ExploreDetail1TableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.lblName.text = self.proArray[indexPath.row].name
            cell.itemCollection.delegate = self
            cell.itemCollection.dataSource = self
            cell.itemCollection.tag = indexPath.row
            cell.itemCollection.createDirectionCollection(8,.horizontal)
            DispatchQueue.main.async {
                cell.itemCollection.reloadData()
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension ExploreDetailViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.proArray[collectionView.tag].item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.lblName.text = self.proArray[collectionView.tag].item[indexPath.row].name
        cell.lblDetail.text = "$\(self.proArray[collectionView.tag].item[indexPath.row].price ?? "")"
        if let image = self.proArray[collectionView.tag].item[indexPath.row].image{
            cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        else{
            cell.ivImage.image = #imageLiteral(resourceName: "01 – 1")
        }
        if let rating = self.proArray[collectionView.tag].item[indexPath.row].rating,rating.count > 0{
            var count = 0.0
            for rate in rating{
                count += rate
            }
            var rate = count/Double(rating.count)
            rate = rate.roundToPlaces(places: 1)
            cell.lblRating.text = "\(rate)"
            cell.lblRateCount.text = "(\(rating.count))"
            cell.vRating.rating = rate
        }
        else{
            cell.lblRateCount.text = "(0)"
            cell.lblRating.text = "0.0"
            cell.vRating.rating = 1
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .TraditionalDishViewController) as! TraditionalDishViewController
        vc.dishData = self.proArray[collectionView.tag].item[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRows:CGFloat = 2.2
        let spacingBetweenCellsIphone:CGFloat = 8
        
        let totalSpacing = (2 * spacingBetweenCellsIphone) + ((numberOfItemsPerRows - 1) * spacingBetweenCellsIphone)
        let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRows
        return CGSize(width: width , height: width)
    }
    
}
