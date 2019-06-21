//
//  Extension_String.swift
//  RtspClient
//
//  Created by Brian Hamilton on 7/31/18.
//  Copyright © 2018 Andres Rojas. All rights reserved.


import Foundation
extension String {
        subscript(value: CountableClosedRange<Int>) -> Substring {
            get {
                return self[index(at: value.lowerBound)...index(at: value.upperBound)]
            }
        }
        
        subscript(value: CountableRange<Int>) -> Substring {
            get {
                return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
            }
        }
        
        subscript(value: PartialRangeUpTo<Int>) -> Substring {
            get {
                return self[..<index(at: value.upperBound)]
            }
        }
        
        subscript(value: PartialRangeThrough<Int>) -> Substring {
            get {
                return self[...index(at: value.upperBound)]
            }
        }
        
        subscript(value: PartialRangeFrom<Int>) -> Substring {
            get {
                return self[index(at: value.lowerBound)...]
            }
        }
        
        func index(at offset: Int) -> String.Index {
            return index(startIndex, offsetBy: offset)
        }
    }
    extension String {
        
        func sliceByCharacter(from: Character, to: Character) -> String? {
            let fromIndex = self.index(self.firstIndex(of: from)!, offsetBy: 1)
            let toIndex = self.index(self.firstIndex(of: to)!, offsetBy: -1)
            return String(self[fromIndex...toIndex])
        }
        
        func sliceByString(from:String, to:String) -> String? {
            //From - startIndex
            var range = self.range(of: from)
              let subString = String(self[range!.upperBound...])
            
            //To - endIndex
            range = subString.range(of: to)
            return String(subString[..<range!.lowerBound])
        }
        
    }

extension String {
    var utf8Array: [UInt8] {
        return Array(utf8)
    }
}
extension Dictionary {
    public init(keys: [Key], values: [Value]) {
        precondition(keys.count == values.count)
        
        self.init()
        
        for (index, key) in keys.enumerated() {
            self[key] = values[index]
        }
    }
}
extension String {
    var hexaBytes: [UInt8] {
        var position = startIndex
        return (0..<count/2).flatMap { _ in    // for Swift 4.1 or later use compactMap instead of flatMap
            defer { position = index(position, offsetBy: 2) }
            return UInt8(self[position...index(after: position)], radix: 16)
        }
    }
    var hexaData: Data { return hexaBytes.data }
}

extension Collection where Element == UInt8 {
    var data: Data {
        return Data(self)
    }
    var hexa: String {
        return map{ String(format: "%02X", $0) }.joined()
    }
}


extension String {
    func zoomValue () -> String {
        var zoomString:String?
        let first = self.dropFirst(5)
        let next = first.dropLast(8)
        let second = self.dropFirst(7)
        let secondNext = second.dropLast(6)
        let third = self.dropFirst(10)
        let thirdNext = third.dropLast(3)
        let fourth = self.dropFirst(11)
        let nextFourth = fourth.dropLast(2)
        
        zoomString = ("\(next)" + "\(secondNext)" + "\(thirdNext)" + "\(nextFourth)")
        
        return zoomString!
    }
    
    
}
extension String {
    func sendZoom () -> Data {
        var data = Data()
        var one = String()
        var two = String()
        var three = String()
        var four = String()
        let firstString = self
        let i = String(firstString.dropLast(2))
        let n = String(firstString.dropFirst(1))
        one = String(firstString.dropLast(3))
        two = String(n.dropLast(2))
        three = String(i.dropLast(1))
        four = String(firstString.dropFirst(3))
        let finalString = "810104470\(one)0\(two)0\(three)0\(four)ff"
      
        
        data = finalString.hexaData
        
        return data
    }
    
}
extension String {
    func sendFocus () -> Data {
       //905000000000ff
        //90500p0q0r0sff
        //905000000001ff
        var data = Data()
        var one = String()
        var two = String()
        var three = String()
        var four = String()
        var string = self
       
        
        let a = string.dropFirst(5)
        one = String(a.dropLast(8))
        let n = String(string.dropLast(6))
        two = String(n.dropFirst(7))
        let q = string.dropFirst(9)
        three = String(q.dropLast(4))
        let z = string.dropLast(2)
        
        four = String(z.dropFirst(11))
       
       
     
      
        data =   "810104480\(one)0\(two)0\(three)0\(four)ff".hexaData
        
        return data
    }
    
}
extension String {
    func zoomDecimal () -> UInt64 {
        
        
        var result = UInt64(self, radix:16)
        
        result = (result! * 30) / 16384
        
        return result!
    }
    
    
}
extension String {
    func getAEMODE () -> String {
        
        var result = self
        if result == "905003ff" {
            result = "Manual"
            
        }
        if result == "905000ff" {
            result = "Full Auto"
            
        }
        if result == "90500Aff" {
            result = "Shutter Priority"
            
        }
        if result == "90500Aff" {
            result = "Iris Priority"
            
        }
        return result
    }
}
extension String {
    func getAEMODEDataReply() -> Data {
        var data = Data()
        var result = self
        if result == "905003ff" {
            result = "Manual"
            data = "8101043903FF".hexaData
        }
        if result == "905000ff" {
            result = "Full Auto"
            data = "8101043900FF".hexaData
        }
        if result == "90500Aff" {
            result = "Shutter Priority"
            data = "810104390AFF".hexaData
        }
        if result == "90500Aff" {
            result = "Iris Priority"
            data = "810104390BFF".hexaData
        }
        return data
    }
}
extension String {
    func getStabilizationMode () -> String {
        
        var result = self
        if result == "900502ff" {
            result = "Stabilzation On"
            
        }
        if result == "900503ff" {
            result = "Stabilzation Off"
            
        }
        
        return result
    }
}
extension String {
    func getStabilizationModeDataReply () -> Data {
        var stabData = Data()
        var result = self
        if result == "900502ff" {
            result = "Stabilzation On"
            stabData = "8101043402FF".hexaData
        }
        if result == "900503ff" {
            result = "Stabilzation Off"
            stabData = "8101043403FF".hexaData
        }
        
        return stabData
    }
}
extension String {
    func getICRMode () -> String {
        
        var data = Data()
        var result = self
        if result == "905002ff" {
            result = "ICR On"
            
        }
        if result == "905003ff" {
            result = "ICR Off"
            
        }
        
        return result
    }
}
extension String {
    func getICRModeDataReply () -> Data {
        
        var data = Data()
        var result = self
        if result == "905002ff" {
            result = "ICR On"
            data = "8101040102FF".hexaData
        }
        if result == "905003ff" {
            result = "ICR Off"
            data = "8101040103FF".hexaData
        }
        
        return data
    }
}
extension String {
    func getWideMode () -> String {
        var result = self
        if result == "905002ff" {
            result = "Wide-D On"
        }
        if result == "905003ff" {
            result = "Wide-D VE Off"
        }
        if result == "900506ff" {
            result = "VE On"
        }
        
        return result
    }
}

//WideD not right
extension String {
    func getWideModeDataReply () -> Data {
        var result = self
        var data = Data()
        if result == "900502ff" {
            result = "Wide-D On"
            data = "8101040103FF".hexaData
        }
        if result == "900503ff" {
            result = "Wide-D VE Off"
            data = "8101040103FF".hexaData
        }
        if result == "900506ff" {
            result = "VE On"
            data = "8101040103FF".hexaData
        }
        
        return data
    }
}
extension String {
    func getWhiteBalance () -> String {
        var result = self
        if result == "905000ff" {
            result = "Auto"
        }
        if result == "905001ff" {
            result = "Indoor"
        }
        if result == "905002ff" {
            result = "Outdoor"
        }
        if result == "905003ff" {
            result = "One Push WB"
        }
        if result == "905004ff" {
            result = "ATW"
        }
        if result == "905005ff" {
            result = "Manual"
        }
        if result == "905006ff" {
            result = "Outdoor Auto"
        }
        if result == "905007ff" {
            result = "Sodium Lamp Auto"
        }
        if result == "905008ff" {
            result = "Sodium Lamp"
        }
        if result == "905009ff" {
            result = "Sodium Lamp Outdoor Auto"
        }
        
        return result
    }
}
extension String {
    func getWhiteBalanceDataReply() -> Data {
        var result = self
        var data = Data()
        if result == "905000ff" {
            data = "8101043500FF".hexaData
        }
        if result == "905001ff" {
           data = "8101043501FF".hexaData
          
        }
        if result == "905002ff" {
           data = "8101043502FF".hexaData
        }
        if result == "905003ff" {
            data = "8101043503FF".hexaData
        }
        if result == "905004ff" {
            data = "8101043504FF".hexaData
        }
        if result == "905005ff" {
           data = "8101043506FF".hexaData
        }
        if result == "905006ff" {
           data = "8101043507FF".hexaData
        }
        if result == "905007ff" {
           data = "8101043508FF".hexaData
        }
        if result == "905008ff" {
            data = "8101043508FF".hexaData
        }
        if result == "905009ff" {
           data = "8101043509FF".hexaData
        }
        
        return data
    }
}
extension String
{
    func getGainDataReply () -> Data {
        var data = Data()
        var gain = String()
     
        let iFour = self
        print(iFour)
        
        if iFour ==  "90500000000fff" {
            gain = "50.0 dB"
          data = "8101044C0000000fFF".hexaData
        
        }
        if iFour == "90500000000eff" {
            gain = "46.4 dB"
            data = "8101044C0000000eFF".hexaData
        }
        if iFour == "90500000000dff" {
            gain = "42.8 dB "
            data = "8101044C0000000dFF".hexaData
        }
        if iFour == "90500000000cff" {
            data = "8101044C0000000cFF".hexaData
            gain = "39.3 dB"
        }
        if iFour == "90500000000bff" {
            gain = "35.7 dB dB "
            data = "8101044C0000000bFF".hexaData
        }
        if iFour == "90500000000aff" {
            gain = "32.1 dB"
            data = "8101044C0000000aFF".hexaData
        }
        if iFour == "905000000009ff" {
            data = "8101044C00000009FF".hexaData
            gain = "28.6 dB "
        }
        if iFour == "905000000008ff" {
            data = "8101044C00000008FF".hexaData
            gain = "25.0 dB" }
        
        
        if iFour == "905000000007ff" {
            data = "8101044C00000007FF".hexaData
            gain = "21.4 dB" }
        
        
        
        if iFour == "905000000006ff" {
            data = "8101044C00000006FF".hexaData
            gain = "17.8 dB"}
        
        if iFour == "905000000005ff" {
            data = "8101044C00000005FF".hexaData
            gain = "3.6 dB" }
        if iFour == "905000000004ff" {
            data = "8101044C00000004FF".hexaData
            gain = "10.7 dB"}
        if iFour == "905000000003ff" {
            data = "8101044C00000003FF".hexaData
            gain = "7.1 dB" }
        
        if iFour == "905000000002ff" {
            data = "8101044C00000002FF".hexaData
            gain = "3.6 dB" }
        
        
        if iFour == "905000000001ff" {
            data = "8101044C00000001FF".hexaData
            gain = "0 dB"
        }
        
        return data
    }
    
}
extension String
{
    func getGain () -> String {
        var gain = String()
        let i = self.dropLast(2)
        let iFour = i.dropFirst(8)
        
        if iFour == "000f" {
            gain = "50.0 dB"
        }
        if iFour == "000e" {
            gain = "46.4 dB"
        }
        if iFour == "000d" {
            gain = "42.8 dB "
        }
        if iFour == "000c" {
            gain = "39.3 dB"
        }
        if iFour == "000b" {
            gain = "35.7 dB dB "
        }
        if iFour == "000a" {
            gain = "32.1 dB"
        }
        if iFour == "0009" {
            gain = "28.6 dB "
        }
        if iFour == "0008" {
            gain = "25.0 dB" }
        
        
        if iFour == "0007" {
            gain = "21.4 dB" }
        
        
        
        if iFour == "0006" {
            gain = "17.8 dB"}
        
        if iFour == "0005" {
            gain = "3.6 dB" }
        if iFour == "0004" {
            gain = "10.7 dB"}
        if iFour == "0003" {
            gain = "7.1 dB" }
        
        if iFour == "0002" {
            gain = "3.6 dB" }
        
        
        if iFour == "0001" {
            gain = "0 dB"
        }
        
        return gain
    }
    
}

extension String {
    func getAFMode () ->  String {
        
        var result = self
        if result == "905000ff" {
            result = "Normal Auto"
            
        }
        if result == "905001ff" {
            
            result = "Interval AF"
            
            
        }
        if result == "905002ff" {
            result = "Trigger AF"
            
        }
        
        
        return result
    }
}
extension String {
    func getAFModeDataReply () ->  Data {
        var data = Data()
        var result = self
       
        if result == "905000ff" {
            data = "8101043802FF".hexaData
            
        }
        if result == "905001ff" {
             data =  "8101045701FF".hexaData
            result = "Interval AF"
          
            
        }
        if result == "905002ff" {
            result = "Zoom Trigger AF"
             data =  "8101045702FF".hexaData
            
        }
        if result == "905003ff" {
            data = "8101043803FF".hexaData
                   //"8101043803FF"
            
        }
        
        
        return data
    }
}
extension String {
    func getDefog () ->  String  {
        var defogData = [String:Data]()
        var result = self
        if result == "90500300ff" {
            result = "Defog Off"
            defogData = [result:"810104370300FF".hexaData]
        }
        if result == "90500201ff" {
            result = "Defog 1"
            defogData = [result:"810104370201FF".hexaData]
        }
        if result == "90500202ff" {
            result = "Defog 2"
            defogData = [result:"810104370202FF".hexaData]
        }
        if result == "90500203ff" {
            result = "Defog 3"
            defogData = [result:"810104370203FF".hexaData]
        }
        
        
        
        return result
    }
}
extension String {
    func getDefogDataReply () ->  Data  {
        var defogData =    Data()
        var result = self
        if result == "90500300ff" {
            result = "Defog Off"
            defogData = "810104370300FF".hexaData
        }
        if result == "90500201ff" {
            result = "Defog 1"
            defogData = "810104370201FF".hexaData
        }
        if result == "90500202ff" {
            result = "Defog 2"
            defogData = "810104370202FF".hexaData
        }
        if result == "90500203ff" {
            result = "Defog 3"
            defogData = "810104370203FF".hexaData
        }
        
        
        
        return defogData
    }
}
extension String {
    func getDZoomMode () -> String{
        
        
        var result = self
        if result == "905002ff" {
            
            result = "D-Zoom On"
            
        }
        if result == "905003ff" {
            result = "D-Zoom Off"
            
        }
        
        return result
    }
    
    
}
extension String {
    func getLeftRightMode () -> String{
        
        
        var result = self
        if result == "905002ff" {
            
            result = "Reverse On"
            
        }
        if result == "905003ff" {
            result = "Reverse Off"
            
        }
        
        return result
    }
    
    
}
extension String {
    func getLeftRightData() -> Data {
        
        var data = Data()
        var result = self
        if result == "905002ff" {
            
            result = "Reverse On"
            data = "8101046102FF".hexaData
            
        }
        if result == "905003ff" {
            result = "Reverse Off"
            data = "8101046103FF".hexaData
        }
        
        return data
    }
    
    
}
extension String {
    func getEFlipMode () -> String{
        
        
        var result = self
        if result == "905002ff" {
            
            result = "E-Flip On"
            
        }
        if result == "905003ff" {
            result = "E-Flip Off"
            
        }
        
        return result
    }
    
    
}
extension String {
    func cameraID () -> String{
        
        
        var result = self
        if result == "90500020070a010002ff" {
            
            result = "FCB-ER8550"
            
        }
        if result == "905000780467021202ff" {
            result = "KZ-33"
            
        }
        if result == "905000200640010502ff" {
            result = "FCB-EV7520A"
            
        }
        if result == "90500020046f070002ff" {
            result = "FCB-EV7520"
            
        }
        //90500020046f070002ff
        //905000200640010502ff
        return result
    }
    
    
}

extension String {
    func getEFlipModeData () -> Data {
        
        var data = Data()
        var result = self
        if result == "905002ff" {
            
            result = "E-Flip On"
            data = "8101046602FF".hexaData
            
        }
        if result == "905003ff" {
            result = "E-Flip Off"
            data = "8101046603FF".hexaData
        }
        
        return data
    }
    
    
}
extension String {
    func getDZoomModeDataReply () -> Data {
        
        var dzoomData = Data()
        var result = self
        if result == "905002ff" {
            
            result = "D-Zoom On"
            dzoomData = "8101040602FF".hexaData
        }
        if result == "905003ff" {
            result = "D-Zoom Off"
            dzoomData = "8101040603FF".hexaData
        }
        
        return dzoomData
    }
    
    
}

extension String {
    func getNearLimit () -> String {
        
        var result = self
        
        if result == "905000000000ff" {
            result = "Infinity"
        }
        if result == "905004000000ff" {
            result = "6M"
        }
        if result == "905003000000ff" {
            result = "10M"
        }
        if result == "905002000000ff" {
            result = "20M"
        }
        if result == "905005000000ff" {
            result = "4.2M"
        }
        if result == "905006000000ff" {
            result = "3.1M"
        }
        if result == "905007000000ff" {
            result = "2.5M"
        }
        if result == "905008000000ff" {
            result = "2.0M"
        }
        if result == "905009000000ff" {
            result = "1.65M"
        }
        if result == "90500a000000ff" {
            result = "1.4M"
        }
        if result == "90500b000000ff" {
            result = "1.2M"
        }
        if result == "90500c000000ff" {
            result = "0.8.2M"
        }
        if result == "90500d000000ff" {
            result = "30cm"
        }
        if result == "90500e000000ff" {
            result = "11cm"
        }
        if result == "90500f000000ff" {
            result = "1cm"
        }
        return result
    }
    
    
}


extension String {
    func getIrisDataReply () -> Data {
       
      let iris = self
        let i = self.dropLast(2)
        let iFour = i.dropFirst(8)
        var data = Data()
       
         var irisSetting = String()
        if iris == "905000000101ff" {
            data = "8101044B00000101FF".hexaData
            irisSetting = "F1.6"
        }
        if iris ==  "905000000100ff"  {
            irisSetting = "F2.0"
            data = "8101044B00000100FF".hexaData
        }
        if iris == "90500000000fff" {
            irisSetting = "F2.4"
            data = "8101044B000000fFF".hexaData
        }
        if iris == "90500000000eff"  {
            irisSetting = "F2.8"
            data = "8101044B000000eFF".hexaData
        }
        if iris == "90500000000dff"  {
            data = "8101044B000000dFF".hexaData
            irisSetting = "F3.4"
        }
        if iris == "90500000000cff"  {
            data = "8101044B000000cFF".hexaData
            irisSetting = "F4.0"
        }
        if iris == "90500000000bff"  {
            data = "8101044B000000bFF".hexaData
            irisSetting = "F4.8"
        }
        if iris == "90500000000aff"  {
            data = "8101044B000000aFF".hexaData
            irisSetting = "F5.6"
        }
        if iris == "905000000009ff"  {
            data = "8101044B0000009FF".hexaData
            irisSetting = "F6.8"
        }
        if iris == "905000000008ff"  {
            data = "8101044B0000008FF".hexaData
            irisSetting = "F8.0"
        }
        if iris == "905000000007ff"  {
            data = "8101044B0000007FF".hexaData
            irisSetting = "F9.6"
        }
        if iris == "905000000006ff"  {
            data = "8101044B0000006FF".hexaData
            irisSetting = "F11"
        }
        if iris == "905000000005ff"  {
            data = "8101044B0000005FF".hexaData
            irisSetting = "F14"
        }
        if  iris == "905000000000ff"  {
            data = "8101044B0000000FF".hexaData
            irisSetting = "CLOSE"
        }
        
        
        return data
    }
    
}


extension String {
    func getIris () -> String {
        var irisSetting = String()
        let i = self.dropLast(2)
        let iFour = i.dropFirst(8)
        
        if iFour == "0101" {
            irisSetting = "F1.6"
        }
        if iFour == "0100" {
            irisSetting = "F2.0"
        }
        if iFour == "000f" {
            irisSetting = "F2.4"
        }
        if iFour == "000e" {
            irisSetting = "F2.8"
        }
        if iFour == "000d" {
            irisSetting = "F3.4"
        }
        if iFour == "000c" {
            irisSetting = "F4.0"
        }
        if iFour == "000b" {
            irisSetting = "F4.8"
        }
        if iFour == "000a" {
            irisSetting = "F5.6"
        }
        if iFour == "0009" {
            irisSetting = "F6.8"
        }
        if iFour == "0008" {
            irisSetting = "F8.0"
        }
        if iFour == "0007" {
            irisSetting = "F9.6"
        }
        if iFour == "0006" {
            irisSetting = "F11"
        }
        if iFour == "0005" {
            irisSetting = "F14"
        }
        if iFour == "0000" {
            irisSetting = "CLOSE"
        }
        
        
        return irisSetting
    }
    
}
extension String {
    func getIris8550 () -> String {
        var irisSetting = String()
      
        let iFour = self
        
    
        if iFour == "905000000109ff" {
            irisSetting = "F2.0"
        }
        if iFour == "905000000108ff" {
            irisSetting = "F2.2"
        }
        if iFour == "905000000107ff" {
            irisSetting = "F2.4"
        }
        if iFour == "905000000106ff" {
            irisSetting = "F2.6"
        }
        if iFour == "905000000105ff" {
            irisSetting = "F2.8"
        }
        if iFour == "905000000104ff" {
            irisSetting = "F3.1"
        }
        if iFour == "905000000103ff" {
            irisSetting = "3.4"
        }
        if iFour == "905000000102ff" {
            irisSetting = "F3.7"
        }
        if iFour == "905000000101ff" {
            irisSetting = "F4.0"
        }
        if iFour == "905000000100ff" {
            irisSetting = "F4.4"
        }
        if iFour == "90500000000fff" {
            irisSetting = "F4.8"
        }
        if iFour == "90500000000eff" {
            irisSetting = "F5.2"
        }
        if iFour == "0000" {
            irisSetting = "CLOSE"
        }
        if iFour == "90500000000dff" {
            irisSetting = "F5.6"
        }
        if iFour == "90500000000cff" {
            irisSetting = "F6.2"
        }
        if iFour == "90500000000bff" {
            irisSetting = "F6.8"
        }
        if iFour == "90500000000aff" {
            irisSetting = "F7.3"
        }
        if iFour == "905000000009ff" {
            irisSetting = "F8.0"
        }
        if iFour == "905000000008ff" {
            irisSetting = "F8.7"
        }
        if iFour == "905000000007ff" {
            irisSetting = "F9.6"
        }
        if iFour == "905000000006ff" {
            irisSetting = "F10.0"
        }
        if iFour == "905000000005ff" {
            irisSetting = "F11.0"
        }

        
        return irisSetting
    }
    
}
extension String {
    func getShutterSpeed8550 () -> String {
        
        var shutterSpeed = String()
       
         let n = self
        
        
        if n == "905000000201ff"{
            shutterSpeed = "1/10000"
        }
        if n == "905000000200ff"{
            shutterSpeed = "1/6000"
        }
        if n == "90500000010eff"{
            shutterSpeed = "1/3000"
        }
        if n == "90500000010fff"{
            shutterSpeed = "1/4000"
        }
        if n == "90500000010dff"{
            shutterSpeed = "1/2000"
        }
        if n == "90500000010cff"{
            shutterSpeed = "1/1500"
        }
        if n == "90500000010bff"{
            shutterSpeed = "1/1000"
        }
        if n == "90500000010aff"{
            shutterSpeed = "1/725"
        }
        if n == "905000000109ff"{
            shutterSpeed = "1/500"
        }
        if n == "905000000108ff"{
            shutterSpeed = "1/350"
        }
        if n == "905000000107ff"{
            shutterSpeed = "1/250"
        }
        if n == "905000000106ff"{
            shutterSpeed = "1/180"
        }
        if n == "905000000105ff"{
            shutterSpeed = "1/125"
        }
        if n == "905000000104ff"{
            shutterSpeed = "1/100"
        }
        if n == "905000000103ff"{
            shutterSpeed = "1/90"
        }
        if n == "905000000102ff"{
            shutterSpeed = "1/60"
        }
        if n == "905000000101ff"{
            shutterSpeed = "1/50"
        }
        if n == "905000000100ff" {
            shutterSpeed = "1/30"
        }
        if n == "90500000000fff"{
            shutterSpeed = "1/20"
        }
        if n == "90500000000eff"{
            shutterSpeed = "1/15"
        }
        if n == "90500000000dff"{
            shutterSpeed = "1/10"
        }
        if n == "90500000000cff"{
            shutterSpeed = "1/8"
        }
        
        if n == "90500000000bff"{
            shutterSpeed = "1/6"
        }
        if n == "90500000000aff"{
            shutterSpeed = "1/4"
        }
        if n == "905000000009ff"{
            shutterSpeed = "1/3"
        }
        if n == "905000000008ff"{
            shutterSpeed = "1/2"
        }
        if n == "905000000007ff"{
            shutterSpeed = "1/1.5"
        }
        if n == "905000000006ff"{
            shutterSpeed = "1/1.5"
        }
        return shutterSpeed
    }
}




extension String {
    func getShutterSpeed () -> String {
        
        var shutterSpeed = String()
        let f = self.dropLast(2)
        let n = f.dropFirst(8)
        //
        
        
        if n == "0105"{
            shutterSpeed = "1/10000"
        }
        if n == "0104"{
            shutterSpeed = "1/6000"
        }
        if n == "0103"{
            shutterSpeed = "1/3000"
        }
        if n == "0102"{
            shutterSpeed = "1/4000"
        }
        if n == "0101"{
            shutterSpeed = "1/2000"
        }
        if n == "0100"{
            shutterSpeed = "1/1500"
        }
        if n == "000f"{
            shutterSpeed = "1/1000"
        }
        if n == "000e"{
            shutterSpeed = "1/725"
        }
        if n == "000d"{
            shutterSpeed = "1/500"
        }
        if n == "000c"{
            shutterSpeed = "1/350"
        }
        if n == "000b"{
            shutterSpeed = "1/250"
        }
        if n == "000a"{
            shutterSpeed = "1/180"
        }
        if n == "0009"{
            shutterSpeed = "1/125"
        }
        if n == "0008"{
            shutterSpeed = "1/100"
        }
        if n == "0007"{
            shutterSpeed = "1/90"
        }
        if n == "0006"{
            shutterSpeed = "1/60"
        }
        if n == "0005"{
            shutterSpeed = "1/30"
        }
        if n == "0004"{
            shutterSpeed = "1/15"
        }
        if n == "0003"{
            shutterSpeed = "1/8"
        }
        if n == "0002"{
            shutterSpeed = "1/4"
        }
        if n == "0001"{
            shutterSpeed = "1/2"
        }
        if n == "0000"{
            shutterSpeed = "1/1"
        }
        
        
        return shutterSpeed
    }
}







extension String {
    func getShutterSpeedDataReply () -> Data {
         var data = Data()
         var shutterSpeed = String()
         let f = self.dropLast(2)
         let n = f.dropFirst(8)
        //
        
        
        if n == "905000000105ff"{
            shutterSpeed = "1/10000"
             data = "8101044A0000105FF".hexaData
        }
        if n == "905000000104ff"{
            shutterSpeed = "1/6000"
             data = "8101044A0000104FF".hexaData
        }
        if n == "905000000103ff"{
            shutterSpeed = "1/3000"
             data = "8101044A0000103FF".hexaData
        }
        if n == "905000000102ff"{
            shutterSpeed = "1/4000"
             data = "8101044A0000102FF".hexaData
        }
        if n == "905000000101ff"{
            shutterSpeed = "1/2000"
             data = "8101044A0000101FF".hexaData
        }
        if n == "9050000000100ff"{
            shutterSpeed = "1/1500"
             data = "8101044A0000100FF".hexaData
        }
        if n == "90500000000fff"{
            shutterSpeed = "1/1000"
             data = "8101044A000000fFF".hexaData
        }
        if n == "90500000000eff"{
            shutterSpeed = "1/725"
             data = "8101044A000000eFF".hexaData
        }
        if n == "90500000000dff"{
            shutterSpeed = "1/500"
             data = "8101044A000000dFF".hexaData
        }
        if n == "90500000000cff"{
            shutterSpeed = "1/350"
             data = "8101044A000000cFF".hexaData
        }
        if n == "90500000000bff"{
            shutterSpeed = "1/250"
            data = "8101044A000000bFF".hexaData
        }
        if n == "90500000000aff"{
            shutterSpeed = "1/180"
            data = "8101044A000000aFF".hexaData
        }
        if n == "905000000009ff"{
            shutterSpeed = "1/125"
            data = "8101044A0000009FF".hexaData
        }
        if n == "905000000008ff"{
            shutterSpeed = "1/100"
             data = "8101044A0000008FF".hexaData
        }
        if n == "905000000007ff"{
            shutterSpeed = "1/90"
             data = "8101044A0000007FF".hexaData
        }
        if n == "905000000006ff"{
            shutterSpeed = "1/60"
             data = "8101044A0000006FF".hexaData
        }
        if n == "905000000005ff"{
            shutterSpeed = "1/30"
             data = "8101044A0000005FF".hexaData
        }
        if n == "905000000004ff"{
            shutterSpeed = "1/15"
             data = "8101044A0000004FF".hexaData
        }
        if n == "905000000003ff"{
            shutterSpeed = "1/8"
             data = "8101044A0000003FF".hexaData
        }
        if n == "905000000002ff"{
            shutterSpeed = "1/4"
             data = "8101044A0000002FF".hexaData
        }
        if n == "905000000001ff"{
            shutterSpeed = "1/2"
             data = "8101044A0000001FF".hexaData
        }
        if n == "905000000000ff"{
            shutterSpeed = "1/1"
             data = "8101044A0000000FF".hexaData
        }
        
        
        return data
    }
}







