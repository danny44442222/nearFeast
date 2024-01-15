import UIKit

enum CustomAppFont: String {
    case poppinsSemiBold = "Poppins-SemiBold"
    case poppinsLight = "Poppins-Light"
    case poppinsRegular = "Poppins-Regular"
    case montserratMedium = "Montserrat-Medium"
    case montserratRegular = "Montserrat-Regular"
    case poppinsMedium = "Poppins-Medium"
}

extension UIFont {
    
    class func getFont(type: CustomAppFont, fontSize: CGFloat) -> UIFont {
        return getCustomFontByName(name: type.rawValue, fontSize: fontSize)
    }
    
    class func getCustomFontByName(name: String, fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: fontSize) {
           print("custom font set ")
            return font
        }
        
        return UIFont.systemFont(ofSize: fontSize)
    }
}
