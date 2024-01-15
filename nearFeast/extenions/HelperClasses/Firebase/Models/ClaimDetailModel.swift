//
//  ClaimDetailModel.swift
//  MyReferral
//
//  Created by Adeel on 15/09/2020.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

class ClaimDetailModel {

    var time:Int64!
    var detail:[SubClaimDetailModel]!
    init(time:Int64,detail:[SubClaimDetailModel]) {
        self.time = time
        self.detail = detail
    }
    
    
    

}
class SubClaimDetailModel {

    
    var claimedPoints:Int!
    var time:Int64!
    init(time:Int64,claimedPoints:Int) {
        self.time = time
        self.claimedPoints = claimedPoints
    }
}
