//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import SourceKittenFramework

struct ClosureModel: Model {
    var name: String
    var type: String
    let nameSuffix = "Handler"
    var mediumName: String
    var longName: String
    var fullName: String
    var offset: Int64 = .max
    let returnAs: String
    let defaultReturnType: String
    let staticKind: String
    let genericTypeNames: [String]
    let paramNames: [String]
    let paramTypes: [String]
    
    init(name: String, mediumName: String, longName: String, fullName: String, genericTypeParams: [ParamModel], paramNames: [String], paramTypes: [String], returnType: String, staticKind: String) {
        self.name = name + nameSuffix
        self.mediumName = mediumName + nameSuffix
        self.longName = longName + nameSuffix
        self.fullName = fullName + nameSuffix
        self.staticKind = staticKind

        let genericTypeNameList = genericTypeParams.map {$0.name}
        self.paramNames = paramNames
        self.paramTypes = paramTypes
        let displayableParamTypes = paramTypes.map { (t: String) -> String in
            let comps = t.components(separatedBy: CharacterSet(charactersIn: "()-> "))
            return genericTypeNameList.filter({comps.contains($0)}).isEmpty ? t : AnyString
        }
        self.genericTypeNames = genericTypeNameList
        let displayableParamStr = displayableParamTypes.joined(separator: ", ")
        let funcReturnType = returnType == UnknownVal ? "" : returnType
        var displayableReturnType = funcReturnType
        let returnComps = funcReturnType.components(separatedBy: CharacterSet(charactersIn: "()-> "))
        
        var returnAsStr = ""
        if !genericTypeNameList.filter({returnComps.contains($0)}).isEmpty {
            displayableReturnType = AnyString
            returnAsStr = funcReturnType
        }
        self.type = "((" + displayableParamStr + ") -> (" + displayableReturnType + "))?"
        self.defaultReturnType = displayableReturnType
        self.returnAs = returnAsStr
    }
    
    func render(with identifier: String) -> String? {
        return applyClosureTemplate(name: identifier,
                                    type: type,
                                    genericTypeNames: genericTypeNames,
                                    paramVals: paramNames,
                                    paramTypes: paramTypes,
                                    returnAs: returnAs,
                                    returnDefaultType: defaultReturnType)
    }
}
