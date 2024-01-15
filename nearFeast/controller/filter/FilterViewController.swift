//
//  FilterViewController.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit
import RangeSeekSlider
struct dishbymodel{
    var name:Dishby!
    var isSelected:Bool! = false
}
struct reviewbymodel{
    var name:ResReviewKeys!
    var isSelected:Bool! = false
}
class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var headerData:[FilterType] = [.Location, .Distance, .TypeofFood , .SortDishesBy, .DietaryPreference, .SortRestaurantsBy, .Ratings]
    var foodType = [FoodTypeModel]()
    var dietType = [DietTypeModel]()
    var dishby = [dishbymodel]()
    var review = [reviewbymodel]()
    var ismiles = false
    var isAsending = true
    var distance:Int = 1
    var maxdistance:CGFloat = 0
    var selectedDishType:String!
    var selectedFoodType:String!
    var selectedReview:String!
    var selectedStar = 0
    var selectedCity:String!
    var delegate:UIViewController!
    
    var userData:UserModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            UIView.animate(withDuration: 1.0, delay: 0.1,options: .curveEaseInOut) {
                self.view.backgroundColor = UIColor().colorsFromAsset(name: .black80Color)
            } completion: { value in
                
            }
            
        }
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.userData = userData
            self.distance = Int(self.userData.defDist ?? 0)
            self.selectedStar = Int(self.userData.defStar ?? 0)
            self.selectedCity = self.userData.defCity ?? ""
            FirebaseData.getFoodtypeList { error, userData in
                if let error = error{
                    self.stopAnimating()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.foodType = userData!
                FirebaseData.getDiettypeList { error, userData1 in
                    self.stopAnimating()
                    if let error = error{
                        PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                        return
                    }
                    self.dietType = userData1!
                    self.loadrate()
                }
            }
        }
        
    }
    func loadrate(){
        self.review = [
            reviewbymodel(name:.Service),
            reviewbymodel(name:.FoodQuality),
            reviewbymodel(name:.Ambience),
            reviewbymodel(name:.Cleanliness),
            reviewbymodel(name:.SpeedofService),
            reviewbymodel(name:.Location),
            reviewbymodel(name:.SpecialAccommodations),
            reviewbymodel(name:.BeverageSelection),
            reviewbymodel(name:.KidFriendliness),
            reviewbymodel(name:.NoiseLevel),
            reviewbymodel(name:.WifiQuality),
            reviewbymodel(name:.ParkingEase)
        ]
        self.dishby = [
            dishbymodel(name: .Popularity),
            dishbymodel(name: .Rating),
            dishbymodel(name: .Distance),
            dishbymodel(name: .Price),
            dishbymodel(name: .Newest)
        ]
        self.tableView.reloadData()
    }
    @objc func didTapKilometerButton(_ sender: UIButton) {
        self.ismiles = false
        self.tableView.reloadData()
        
    }
    
    @objc func didTapMilesButton(_ sender: UIButton) {
        self.ismiles = true
        self.tableView.reloadData()
        

    }
    @objc func didTap1StarButton(_ sender: UIButton) {
        self.selectedStar = 1
        self.tableView.reloadSections([6], with: .automatic)
    }
    @objc func didTap2StarButton(_ sender: UIButton) {
        self.selectedStar = 2
        self.tableView.reloadSections([6], with: .automatic)
    }
    @objc func didTap3StarButton(_ sender: UIButton) {
        self.selectedStar = 3
        self.tableView.reloadSections([6], with: .automatic)
    }
    @objc func didTap4StarButton(_ sender: UIButton) {
        self.selectedStar = 4
        self.tableView.reloadSections([6], with: .automatic)
    }
    @objc func didTap5StarButton(_ sender: UIButton) {
        self.selectedStar = 5
        self.tableView.reloadSections([6], with: .automatic)
    }
    @objc func didTapSubmitButton(_ sender: UIButton) {
        let foodtypr = self.foodType.filter { FoodTypeModel1 in
            return FoodTypeModel1.isSelected
        }
//        let dishby = self.dishby.filter { dishbymodel1 in
//            return dishbymodel1.isSelected
//        }
        let diettype = self.dietType.filter { DietTypeModel1 in
            return DietTypeModel1.isSelected
        }
        let reviewby = self.review.filter { reviewbymodel1 in
            return reviewbymodel1.isSelected
        }
        switch self.delegate{
        case let controller as HomeViewController:
            controller.loadfilterData(selectedCity: selectedCity,dishby: self.selectedDishType,distance: distance, selectedDietType: diettype,selectedFoodType: foodtypr,selectedReview: reviewby,selectedStar: selectedStar)
        case let controller as FavouriteViewController:
            controller.loadfilterData(selectedCity: selectedCity,dishby: self.selectedDishType,distance: distance, selectedDietType: diettype,selectedFoodType: foodtypr,selectedReview: reviewby,selectedStar: selectedStar)
        default:
            break
        }
        
    }
    @objc func didChangedSlider(_ sender: UISlider) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FilterRangeSliderTableViewCell
        cell.lblValue.text = "\(Int(sender.value))"
        self.distance = Int(sender.value)
    }
    @IBAction func didTapCancel(_ sender: Any) {
        for id in self.foodType{
            id.isSelected = false
        }
        self.selectedFoodType = nil
        for id in self.dietType{
            id.isSelected = false
        }
        self.selectedReview = nil
        for (i,id) in self.dishby.enumerated(){
            self.dishby[i].isSelected = false
            
        }
        for (i,id) in self.review.enumerated(){
            self.review[i].isSelected = false
            
        }
        self.selectedDishType = nil
        self.distance = 1
        self.selectedCity = nil
        self.selectedStar = 0
        self.tableView.reloadData()
    }
}
extension FilterViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch self.headerData[textField.tag]{
        case .SortDishesBy:
            let picker = SimplePickerView(textField, controller: self)
            picker.delegate = self
            picker.mainPickerView.dataSource = self
            picker.mainPickerView.delegate = self
        default:
            break
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag{
        case 3,4,5:
            textField.resignFirstResponder()
        default:
            self.selectedCity = textField.text
        }
        
    }
}
extension FilterViewController:SimplePickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.dishby.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dishby[row].name.rawValue
    }
    
    func didFinish(pickerView: UIPickerView) {
        self.selectedDishType = self.dishby[pickerView.selectedRow(inComponent: 0)].name.rawValue
        self.tableView.reloadSections([3], with: .automatic)
    }
    
    func didCancel() {
        self.view.endEditing(true)
        self.selectedDishType = nil
        self.tableView.reloadSections([3], with: .none)
    }
    
    
}
extension FilterViewController:UITableViewDelegate, UITableViewDataSource{
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.headerData[indexPath.section] {
        case .Location:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterLocationTableViewCell") as! FilterLocationTableViewCell
            cell.tfLocation.delegate = self
            cell.tfLocation.tag = indexPath.section
            cell.tfLocation.placeholder = "New York"
            cell.tfLocation.text = self.selectedCity
            
//            if self.ismiles{
//                cell.milesButton.backgroundColor = .red
//                cell.kilometerButton.backgroundColor = .white
//                cell.kilometerButton.setTitleColor(UIColor.gray, for: .normal)
//                cell.milesButton.setTitleColor(UIColor.white, for: .normal)
//            }
//            else{
//                cell.kilometerButton.backgroundColor = .red
//                cell.kilometerButton.setTitleColor(UIColor.white, for: .normal)
//                cell.milesButton.backgroundColor = .white
//                cell.milesButton.setTitleColor(UIColor.gray, for: .normal)
//            }
//            cell.milesButton.addTarget(self, action: #selector(self.didTapMilesButton(_:)), for: .touchUpInside)
//            cell.kilometerButton.addTarget(self, action: #selector(self.didTapKilometerButton(_:)), for: .touchUpInside)
            return cell
        case .Distance:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRangeSliderTableViewCell") as! FilterRangeSliderTableViewCell
            cell.rangeSlider.value = Float(self.distance)
            cell.lblValue.text = "\(self.distance)"
            cell.rangeSlider.addTarget(self, action: #selector(self.didChangedSlider(_:)), for: .touchUpInside)
            return cell
        case .SortDishesBy:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterLocationTableViewCell") as! FilterLocationTableViewCell
            cell.tfLocation.delegate = self
            cell.tfLocation.text = self.selectedDishType
            cell.tfLocation.tag = indexPath.section
            cell.tfLocation.placeholder = "Papularity"
            return cell
        case .TypeofFood,.DietaryPreference,.SortRestaurantsBy:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTypeSearchTableViewCell") as! FilterTypeSearchTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.section
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
            }
                return cell
        case .Ratings:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRatingTableViewCell") as! FilterRatingTableViewCell
            cell.btn1Star.addTarget(self, action: #selector(self.didTap1StarButton(_:)), for: .touchUpInside)
            cell.btn2Star.addTarget(self, action: #selector(self.didTap2StarButton(_:)), for: .touchUpInside)
            cell.btn3Star.addTarget(self, action: #selector(self.didTap3StarButton(_:)), for: .touchUpInside)
            cell.btn4Star.addTarget(self, action: #selector(self.didTap4StarButton(_:)), for: .touchUpInside)
            cell.btn5Star.addTarget(self, action: #selector(self.didTap5StarButton(_:)), for: .touchUpInside)
            cell.btnSubmit.addTarget(self, action: #selector(self.didTapSubmitButton(_:)), for: .touchUpInside)
            switch self.selectedStar{
            case 1:
                cell.btn1Star.backgroundColor = .red
                cell.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
                cell.btn2Star.backgroundColor = .white
                cell.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
                cell.btn3Star.backgroundColor = .white
                cell.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
                cell.btn4Star.backgroundColor = .white
                cell.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
                cell.btn5Star.backgroundColor = .white
                cell.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
                
            case 2:
                cell.btn1Star.backgroundColor = .white
                cell.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
                cell.btn2Star.backgroundColor = .red
                cell.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
                cell.btn3Star.backgroundColor = .white
                cell.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
                cell.btn4Star.backgroundColor = .white
                cell.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
                cell.btn5Star.backgroundColor = .white
                cell.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
            case 3:
                cell.btn1Star.backgroundColor = .white
                cell.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
                cell.btn2Star.backgroundColor = .white
                cell.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
                cell.btn3Star.backgroundColor = .red
                cell.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
                cell.btn4Star.backgroundColor = .white
                cell.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
                cell.btn5Star.backgroundColor = .white
                cell.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
            case 4:
                cell.btn1Star.backgroundColor = .white
                cell.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
                cell.btn2Star.backgroundColor = .white
                cell.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
                cell.btn3Star.backgroundColor = .white
                cell.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
                cell.btn4Star.backgroundColor = .red
                cell.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
                cell.btn5Star.backgroundColor = .white
                cell.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
            case 5:
                cell.btn1Star.backgroundColor = .white
                cell.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
                cell.btn2Star.backgroundColor = .white
                cell.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
                cell.btn3Star.backgroundColor = .white
                cell.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
                cell.btn4Star.backgroundColor = .white
                cell.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
                cell.btn5Star.backgroundColor = .red
                cell.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
            default:
                cell.btn1Star.backgroundColor = .white
                cell.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
                cell.btn2Star.backgroundColor = .white
                cell.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
                cell.btn3Star.backgroundColor = .white
                cell.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
                cell.btn4Star.backgroundColor = .white
                cell.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
                cell.btn5Star.backgroundColor = .white
                cell.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
            }
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: tableView.frame.size.width, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = headerData[section].rawValue
        myLabel.textColor = .black
        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
}
extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag{
        case 2:
            return self.foodType.count
        case 3:
            return self.dishby.count
        case 4:
            return self.dietType.count
        case 5:
            return self.review.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        switch collectionView.tag{
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeOfSearch1CollectionViewCell", for: indexPath) as! TypeOfSearch1CollectionViewCell
            cell.mainView.layer.borderWidth = 1.0
            cell.mainView.layer.borderColor = UIColor(hex: "#EFEFEF").cgColor
            cell.mainView.layer.cornerRadius = 10.0
            cell.dataLabel.text = self.foodType[indexPath.row].name
            if let img = self.foodType[indexPath.row].image{
                cell.ivImage.imageURLProfile(img, placholdr: #imageLiteral(resourceName: "01 – 1.png"))
            }
            else{
                cell.ivImage.image = #imageLiteral(resourceName: "01 – 1.png")
            }
            
            if self.foodType[indexPath.row].isSelected{
                cell.mainView.layer.backgroundColor = UIColor.red.cgColor
                cell.dataLabel.textColor = UIColor.white
            }
            else{
                cell.mainView.layer.backgroundColor = UIColor.white.cgColor
                cell.dataLabel.textColor = UIColor.black
            }
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeOfSearch1CollectionViewCell", for: indexPath) as! TypeOfSearch1CollectionViewCell
            cell.mainView.layer.borderWidth = 1.0
            cell.mainView.layer.borderColor = UIColor(hex: "#EFEFEF").cgColor
            cell.mainView.layer.cornerRadius = 10.0
            cell.dataLabel.text = self.dietType[indexPath.row].name
            if let img = self.dietType[indexPath.row].image{
                cell.ivImage.imageURLProfile(img, placholdr: #imageLiteral(resourceName: "01 – 1.png"))
            }
            else{
                cell.ivImage.image = #imageLiteral(resourceName: "01 – 1.png")
            }
            if self.dietType[indexPath.row].isSelected{
                cell.mainView.layer.backgroundColor = UIColor.red.cgColor
                cell.dataLabel.textColor = UIColor.white
            }
            else{
                cell.mainView.layer.backgroundColor = UIColor.white.cgColor
                cell.dataLabel.textColor = UIColor.black
            }
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeOfSearchCollectionViewCell", for: indexPath) as! TypeOfSearchCollectionViewCell
            cell.mainView.layer.borderWidth = 1.0
            cell.mainView.layer.borderColor = UIColor(hex: "#EFEFEF").cgColor
            cell.mainView.layer.cornerRadius = 10.0
            cell.dataLabel.text = self.review[indexPath.row].name.rawValue
            if self.review[indexPath.row].isSelected{
                cell.mainView.layer.backgroundColor = UIColor.red.cgColor
                cell.dataLabel.textColor = UIColor.white
            }
            else{
                cell.mainView.layer.backgroundColor = UIColor.white.cgColor
                cell.dataLabel.textColor = UIColor.black
            }
            return cell
        default:
            return UICollectionViewCell()
        }
        
        //cell.addShadowColor(shadowColor: UIColor.black, offSet: CGSize(width: 0.0, height: 1.0), opacity: 0.2, shadowRadius: 3.0, cornerRadius: 10, corners: UIRectCorner.allCorners, fillColor: UIColor.white)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        for i in self.foodType{
//            i.isSelected = false
//        }
        
        switch collectionView.tag{
        case 2:
            if self.foodType[indexPath.row].isSelected{
                self.foodType[indexPath.row].isSelected = false
            }
            else{
                self.foodType[indexPath.row].isSelected = true
            }
        case 3:
            if self.dishby[indexPath.row].isSelected{
                self.dishby[indexPath.row].isSelected = false
            }
            else{
                self.dishby[indexPath.row].isSelected = true
            }
        case 4:
            if self.dietType[indexPath.row].isSelected{
                self.dietType[indexPath.row].isSelected = false
            }
            else{
                self.dietType[indexPath.row].isSelected = true
            }
        case 5:
            if self.review[indexPath.row].isSelected{
                self.review[indexPath.row].isSelected = false
            }
            else{
                self.review[indexPath.row].isSelected = true
            }
        default:
            break
        }
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width/3 - 20
        let height = 40.0
        return CGSize(width: width, height: height)
    }

}
