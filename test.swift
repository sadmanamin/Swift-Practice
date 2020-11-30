import UIKit
import Foundation
 
 
//A Class that returns necessary String operations
class StringExt{
 
    static func idx(str: String, pos:Int)-> Character{
        let index = str.index(str.startIndex, offsetBy: pos)
        return str[index]
    }
 
    static func find(str: String, char: Character) -> Int{
        var tmp = 0
 
        for c in str{
            if c == char{
                break
            }
            tmp = tmp + 1
        }
 
        return tmp
    }
 
    static func substr(str: String, idx1: Int, idx2: Int) -> String{
        let firstIndex = str.index(str.startIndex, offsetBy: idx1)
        let secondIndex = str.index(str.startIndex, offsetBy: idx2+1)
        let range = firstIndex..<secondIndex
        return String(str[range])
    }
 
    static func split(str:String,char:Character) -> Array<String>{
        var i:Int = 0
        var tmpStr:String = ""
        var list:[String] = []
 
        for ch in str{
            if ch == char || i == str.count-1{
                list.append(tmpStr)
                tmpStr = ""
 
            }
 
            else{
                tmpStr.append(ch)
            }
 
            i=i+1
        }
        return list
    }
 
}
 
//sample class for the Static Analysis
class Person {
 
    var name = ""
    var age = 0
 
    // This dictionary will be referred to whenever a function corresponding to the key needs to be invoked.
    lazy var dict: [String : () -> ()] = ["call" : { self.call(name: "", phone: "", message: "", count: 0) }, "reset" : { self.reset() }, "returnSomething" : { self.returnSomething(itemOne: "", itemTwo: "") }]
 
    @objc func call(name: String, phone: String, message: String, count: Int) {
 
        // Static Analysis Starts
        let funcArgs = #function
        let types = type(of: call)
        let temStr = StringExt.substr(str:funcArgs, idx1:StringExt.find(str:funcArgs,char:"(")+1,idx2:StringExt.find(str:funcArgs,char:")")-1)
        let argList = StringExt.split(str:temStr,char:":")
        print(argList)
        if(argList.count>3){
            print("warning: Method contains more than 3 parameter having types",types)
        }
        // Static Analysis Ends
    }
 
 
    @objc func reset() {
 
        // Static Analysis Starts
        let funcArgs = #function
        let types = type(of: reset)
        let temStr = StringExt.substr(str:funcArgs, idx1:StringExt.find(str:funcArgs,char:"(")+1,idx2:StringExt.find(str:funcArgs,char:")")-1)
        let argList = StringExt.split(str:temStr,char:":")
        if(argList.count>3){
            print("warning: Method contains more than 3 parameter having types",types)
        }
        // Static Analysis Ends
 
        name = ""
        age = 0
    }
 
    @objc func returnSomething(itemOne: String, itemTwo: String) {
        print("\(itemOne) \(itemTwo)")
    }
 
}
 
 
 
 
// returns the name of the method of a class passed in as parameter cls.
func getMethodNamesForClass(cls: AnyClass) -> Array<String> {
    var methodCount: UInt32 = 0
    var finalMethodList:[String] = []
    let methodList = class_copyMethodList(cls, &methodCount)
    if let methodList = methodList, methodCount > 0 {
        enumerateCArray(array: methodList, count: methodCount) { i, m in
            let name = methodName(m: m) ?? "unknown"
            finalMethodList.append(name)
            //print("#\(i): \(name)")
        }
 
        free(methodList)
    }
    return finalMethodList
}
 
func enumerateCArray<T>(array: UnsafePointer<T>, count: UInt32, f: (UInt32, T) -> Void) {
    var ptr = array
    for i in 0..<count {
        f(i, ptr.pointee)
        ptr = ptr.successor()
    }
}
func methodName(m: Method) -> String? {
    let sel = method_getName(m)
    let nameCString = sel_getName(sel)
    return String(cString: nameCString)
}
 
//func printMethodNamesForClassNamed(classname: String) {
//    // NSClassFromString() is declared to return AnyClass!, but should be AnyClass?
//    let maybeClass: AnyClass? = NSClassFromString(classname)
//    if let cls: AnyClass = maybeClass {
//        printMethodNamesForClass(cls: cls)
//    } else {
//        print("\(classname): no such class")
//    }
//}
 
func invokeMethodWithName(signature: String, cls: AnyClass) {
    let components = signature.components(separatedBy: "With")
    if let _ = cls as? Person.Type {
        let person = Person()
        if let closure = person.dict[components[0]] {
            closure()
        }
    }
}
 
 
var methodList:[String] = getMethodNamesForClass(cls: Person.self)
for str in methodList{
    print(str)
}
 
invokeMethodWithName(signature: methodList[2], cls: Person.self)