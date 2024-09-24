//
//  WatchModel.swift
//  OVWatch Watch App
//
//  Created by Peter Harry on 29/2/2024.
//  Copyright © 2024 Open Vehicle Systems. All rights reserved.
//

import Combine
import WatchConnectivity

struct Doors: OptionSet {
  let rawValue: Int
  
  static let leftDoor = Doors(rawValue: 1 << 0)
  static let rightDoor = Doors(rawValue: 1 << 1)
  static let chargePort = Doors(rawValue: 1 << 2)
  static let pilot = Doors(rawValue: 1 << 3)
  static let charging = Doors(rawValue: 1 << 4)
  static let handBrake = Doors(rawValue: 1 << 6)
  static let carOn = Doors(rawValue: 1 << 7)
}

class WatchModel: NSObject, ObservableObject {
  static let shared = WatchModel()
  @Published var metricVal = WatchMetric.initial
  var carMode: CarMode {
      get {
        if metricVal.charging {
          return .charging
        } else if metricVal.on  {
          return .driving
        }
        return .idle
      }
  }
  
  var statusCharging = false
  var charging = false

  var topic = ""
  var session: WCSession
  
  init(session: WCSession = .default) {
    self.session = session
    super.init()
    self.session.delegate = self
    session.activate()
  }
  
  func setMetric(message:String, payload:NSArray) {
    print("Message received: \(message)")
    switch message {
    case "S":
      if (payload.count>=8)
      {
        metricVal.soc = payload[0] as? String ?? "0"
        //car_units = [lparts objectAtIndex:1];
        metricVal.voltage = payload[2] as? String ?? "0"
        //car_linevoltage = [[lparts objectAtIndex:2] intValue];
        metricVal.chargecurrent = payload[3] as? String ?? "0"
        //car_chargecurrent = [[lparts objectAtIndex:3] intValue];
        metricVal.chargestate = payload[4] as? String ?? "0"
        if (metricVal.chargestate == "charging") {
          metricVal.charging = true
        } else {
          metricVal.charging = false
        }
        //car_chargestate = [lparts objectAtIndex:4];
        metricVal.mode = payload[5] as? String ?? "0"
        //car_chargemode = [lparts objectAtIndex:5];
        metricVal.idealrange = payload[6] as? String ?? "0"
        //car_idealrange = [[lparts objectAtIndex:6] intValue];
        metricVal.estimatedrange = payload[7] as? String ?? "0"
        //car_estimatedrange = [[lparts objectAtIndex:7] intValue];
        //car_idealrange_s = [self convertDistanceUnits:car_idealrange];
        //car_estimatedrange_s = [self convertDistanceUnits:car_estimatedrange];
      }
      if (payload.count>=15)
      {
        metricVal.climit = payload[8] as? String ?? "0"
        //car_chargelimit = [[lparts objectAtIndex:8] intValue];
        metricVal.chargeduration = payload[9] as? String ?? "0"
        //car_chargeduration = [[lparts objectAtIndex:9] intValue];
        //metricVal.soc = payload[10] as? String ?? "0"
        //car_chargeb4 = [[lparts objectAtIndex:10] intValue];
        metricVal.chargekwh = payload[11] as? String ?? "0"
        //car_chargekwh = [[lparts objectAtIndex:11] intValue] / 10;
        //metricVal.ch = payload[0] as? String ?? "0"
        //car_chargesubstate = [[lparts objectAtIndex:12] intValue];
        //metricVal.soc = payload[0] as? String ?? "0"
        //car_chargestateN = [[lparts objectAtIndex:13] intValue];
        //metricVal.soc = payload[0] as? String ?? "0"
        //car_chargemodeN = [[lparts objectAtIndex:14] intValue];
      }
      if (payload.count>=19)
      {
        //metricVal.soc = payload[18] as? String ?? "0"
        //car_cac = [lparts objectAtIndex:18];
      }
      if (payload.count>=23)
      {
        metricVal.durationfull = payload[19] as? String ?? "0"
        //car_minutestofull = [[lparts objectAtIndex:19] intValue];
        metricVal.limitrange = payload[21] as? String ?? "0"
        //car_rangelimit = [[lparts objectAtIndex:21] intValue];
        metricVal.limitsoc = payload[22] as? String ?? "0"
        //car_soclimit = [[lparts objectAtIndex:22] intValue];
      }
      if(payload.count>=31)
      {
        //car_minutestorangelimit = [[lparts objectAtIndex:27] intValue];
        metricVal.durationrange = payload[27] as? String ?? "0"
        //car_minutestosoclimit = [[lparts objectAtIndex:28] intValue];
        metricVal.durationsoc = payload[28] as? String ?? "0"
        //car_chargetype = [[lparts objectAtIndex:30] intValue];
        metricVal.type = payload[30] as? String ?? "0"
      }
      break
    case "D":
      //print(payload)
      if (payload.count>=9)
      {
        let strVal = payload[0] as? String ?? "0"
        metricVal.doors1 = Int(strVal) ?? 0
        let doors = Doors(rawValue: metricVal.doors1)
				metricVal.on = doors.contains(.carOn)
				metricVal.cp_dooropen = doors.contains(.chargePort)
        print("Doors1 = 0x\(String(metricVal.doors1, radix: 2, uppercase: true))")
        let strVal1 = payload[1] as? String ?? "0"
        metricVal.doors2 = Int(strVal1) ?? 0
        print("Doors2 = 0x\(String(metricVal.doors2, radix: 2, uppercase: true))")
        metricVal.locked = payload[2] as? String ?? "0"
        //metricVal.soc = payload[3] as? String ?? "0"
        //metricVal.soc = payload[4] as? String ?? "0"
        //metricVal.soc = payload[5] as? String ?? "0"
        //metricVal.soc = payload[6] as? String ?? "0"
        metricVal.odometer = payload[7] as? String ?? "0"
        metricVal.gpsspeed = payload[8] as? String ?? "0"
      }
      if (payload.count>=10)
      {
        metricVal.parktime = payload[9] as? String ?? "0"
      } else {
        metricVal.parktime = "0"
      }
      if (payload.count>=15)
      {
        metricVal.lowvoltage = payload[14] as? String ?? "0"
      }
      break
    case "L":
      //print(payload)
      if (payload.count>=3)
      {
        metricVal.latitude = payload[0] as? String ?? "0"
        metricVal.longitude = payload[1] as? String ?? "0"
      }
      if (payload.count>=6)
      {
        metricVal.direction = payload[2] as? String ?? "0"
        metricVal.altitude = payload[3] as? String ?? "0"
        metricVal.gpslock = payload[4] as? String ?? "0"
        //metricVal.stale_gps = payload[5] as? String ?? "0"
      }
    default:
      break
    }
  }
}

extension WatchModel: WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if let error = error {
      print(error.localizedDescription)
    } else {
      print("The session has completed activation.")
    }
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    DispatchQueue.main.async {
      if let incoming = message["topic"] as? String {
        self.topic = incoming
      } else {
        if let payload = message[self.topic] as? NSArray {
          self.setMetric(message: self.topic, payload: payload)
        } else {
          print("There was an error")
        }
      }
    }
  }
}
