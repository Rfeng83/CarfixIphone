//
//  BaseTableReturnData.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 11/01/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

protocol BaseTableReturnData {
    func tableSelection(sender: BaseTableController, section: Int?, row: Int?)
}
