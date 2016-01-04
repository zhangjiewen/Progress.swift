//
//  Utilities.swift
//  Progress.swift
//
//  Created by Justus Kandzi on 04/01/16.
//  Copyright © 2016 Justus Kandzi. All rights reserved.
//
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

func getTimeOfDay() -> Double {
    var tv = timeval()
    gettimeofday(&tv, nil)
    return Double(tv.tv_sec) + Double(tv.tv_usec) / 1000000
}

extension Double {
    func format(decimalPartLength: Int, minimumIntegerPartLength: Int = 0) -> String {
        let value = String(self)
        let components = value.characters
            .split() { $0 == "." }
            .map { String($0) }
        
        guard var integerPart = components.first else {
            return stringWithZeros(minimumIntegerPartLength)
        }
        
        let missingLeadingZeros = minimumIntegerPartLength - integerPart.characters.count
        if missingLeadingZeros > 0 {
            integerPart = stringWithZeros(missingLeadingZeros) + integerPart
        }
        
        if decimalPartLength == 0 {
            return integerPart
        }
        
        var decimalPlaces = components.last?.substringWithRange(0, end: decimalPartLength) ?? "0"
        let missingPlaceCount = decimalPartLength - decimalPlaces.characters.count
        decimalPlaces += stringWithZeros(missingPlaceCount)
        
        return "\(integerPart).\(decimalPlaces)"
    }
    
    private func stringWithZeros(count: Int) -> String {
        return Array(count: count, repeatedValue: "0").joinWithSeparator("")
    }
}

extension String {
    func substringWithRange(start: Int, end: Int) -> String {
        var end = end
        if start < 0 || start > self.characters.count {
            return ""
        }
        else if end < 0 || end > self.characters.count {
            end = self.characters.count
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(end))
        return self[range]
    }
}
