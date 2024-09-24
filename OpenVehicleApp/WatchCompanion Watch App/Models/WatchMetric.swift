//
//  WatchMetric.swift
//  OVWatch Watch App
//
//  Created by Peter Harry on 29/2/2024.
//  Copyright © 2024 Open Vehicle Systems. All rights reserved.
//

import Foundation

struct WatchMetric: Hashable, Codable {
  //c
  var charging: Bool
  var kwh: String
  var state: String
  var type: String
  var mode: String
  var time: String
  var current: String
  var power: String
  var voltage: String
  var climit: String
  var durationfull: String
  var durationrange: String
  var durationsoc: String
  var limitrange: String
  var limitsoc: String
  //b
  var battvoltage: String
  var soc: String
  var soh: String
  var chargecurrent: String
  var chargeduration: String
  var chargekwh: String
  var chargepower: String
  var chargestate: String
  var chargetype: String
  var cp_dooropen: Bool
  var estimatedrange: String
  var idealrange: String
  var lowvoltage: String
  var consumption: String
  //e
	var awake: Bool
	var charging12v: Bool
	var drivetime: String
	var on: Bool
  var parktime: String
  var headlights: String
  var locked: String
  //p
  var altitude: String
  var direction: String
  var gpshdop: String
  var gpslock: String
  var gpsmode: String
  var gpsspeed: String
  var gpssq: String
  var gpstime: String
  var latitude: String
  var longitude: String
  var odometer: String
  var satcount: String
  //d
  var doors1: Int
  var doors2: Int
  var cp: String
  var fl: String
  var fr: String
  var hood: String
  var rl: String
  var rr: String
  var trunk: String
  
  static let initial = WatchMetric(
    //c
    charging: false,
    kwh: "0",
    state: "",
    type: "",
    mode: "",
    time: "",
    current: "0",
    power: "0",
    voltage: "0",
    climit: "0",
    durationfull: "0",
    durationrange: "0",
    durationsoc: "0",
    limitrange: "0",
    limitsoc: "0",
    //b
    battvoltage: "0",
    soc: "0",
    soh: "0",
    chargecurrent: "0",
    chargeduration: "0",
    chargekwh: "0",
    chargepower: "0",
    chargestate: "0",
    chargetype: "0",
    cp_dooropen: false,
    estimatedrange: "0",
    idealrange: "0",
    lowvoltage: "0",
    consumption: "0",
    //e
		awake: false,
		charging12v: false,
		drivetime: "0",
		on: false,
    parktime: "0",
    headlights: "0",
    locked: "0",
    //p
    altitude: "0",
    direction: "0",
    gpshdop: "0",
    gpslock: "0",
    gpsmode: "0",
    gpsspeed: "0",
    gpssq: "0",
    gpstime: "0",
    latitude: "0",
    longitude: "0",
    odometer: "0",
    satcount: "0",
    //d
    doors1: 0,
    doors2: 0,
    cp: "0",
    fl: "0",
    fr: "0",
    hood: "0",
    rl: "0",
    rr: "0",
    trunk: "0"
    
  )
}
