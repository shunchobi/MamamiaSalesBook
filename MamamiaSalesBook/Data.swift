//
//  Data.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/16.
//

import Foundation


///
///
///
//商品の全データを保持するクラス（listはカテゴリーごとに分けられた商品を全て保持）
///
///
///
 class ProductCategolies : ObservableObject{
     
     private let keyName: String = "ProductCategolies"
    
    //カテゴリー分けされた全商品のデータ
     @Published var list : [aProductCategoly] = []
     
     //listをローカルに保存
     func SaveProductData(){
         if let encoded = try? JSONEncoder().encode(list){
             UserDefaults.standard.set(encoded, forKey: keyName)
         }
     }
     
     //listをローカルデータから読み込む
     init(){
         if let data = UserDefaults.standard.data(forKey: keyName){
             if let decoded = try? JSONDecoder().decode([aProductCategoly].self, from: data){
                 list = decoded
                 return
             }
         }
         list = []
    }

     //新しいカテゴリーを追加
     public func AddCategoly(_categolyName : String, _indexNum : Int){
        let aProduct = aProductCategoly(_name: _categolyName, _index: _indexNum)
        list.append(aProduct)
         SaveProductData()
     }
     
    //新しい商品を追加
     public func AddProduct(index: Int, product: aProduct){
         list[index].products.append(product)
         SaveProductData()
     }
}
///
///
///商品の全データを保持するクラス（listはカテゴリーごとに分けられた商品を全て保持） end
///
///

//カテゴリー別の商品を保持
struct aProductCategoly : Hashable, Identifiable, Codable{
    var id = UUID()
    var name : String
    var index : Int
    var products : [aProduct] = []
    
    init(_name:String, _index:Int){
        name = _name
        index = _index
    }
    
    mutating func ChangeIndex(_index : Int){
        index = _index
    }
}

//商品の情報を保持
struct aProduct : Hashable, Identifiable, Codable{
    var id = UUID()
    var index : Int
    var name : String
    var price : Int
    var cost : Int
    var myMaterials : [aMaterial] = []
    
    init(_name:String, _price:Int, _cost:Int, _index : Int){
        name = _name
        price = _price
        cost = _cost
        index = _index
    }
}






///
///
///材料の全データを保持するクラス（listはカテゴリーごとに分けられた材料を全て保持）
///
///
 class MaterialCategolies : ObservableObject{
     
     private let keyName: String = "MaterialCategolies"
    
    //カテゴリー分けされた全材料のデータ
    @Published var list : [aMaterialCategoly] = []
          
     //listをローカルに保存
     func SaveMaterialData(){
         if let encoded = try? JSONEncoder().encode(list){
             UserDefaults.standard.set(encoded, forKey: keyName)
         }
     }
     
     //listをローカルデータから読み込む
     init(){
         if let data = UserDefaults.standard.data(forKey: keyName){
             if let decoded = try? JSONDecoder().decode([aMaterialCategoly].self, from: data){
                 list = decoded
                 return
             }
         }
         
         list = []
    }

     //新しいカテゴリーを追加
     public func AddCategoly(_categolyName : String, _indexNum : Int){
        let aProduct = aMaterialCategoly(_name: _categolyName, _index: _indexNum)
        list.append(aProduct)
         SaveMaterialData()
     }
     
    //新しい材料を追加
     public func AddMaterial(index: Int, material: aMaterial){
         list[index].materials.append(material)
         SaveMaterialData()
     }

}
///
///
///材料の全データを保持するクラス（listはカテゴリーごとに分けられた材料を全て保持） end
///
///

//カテゴリー別の材料を保持
struct aMaterialCategoly : Hashable, Identifiable, Codable{
    var id = UUID()
    var name : String
    var index : Int
    var materials : [aMaterial] = []
    
    init(_name:String, _index:Int){
        name = _name
        index = _index
    }
    
    mutating func ChangeIndex(_index : Int){
        index = _index
    }
}

//材料の情報を保持
struct aMaterial : Hashable, Identifiable, Codable{
    var id = UUID()
    var name : String
    var cost : Int
    
    init(_name:String, _cost:Int){
        name = _name
        cost = _cost
    }

}







///
///
///
//売れた商品の情報を保持するクラス
///
///
///
class SouldProductAll: ObservableObject{
    
    private let keyName: String = "SouldProductAll"

    //月ごとに分けた売れた商品の全データ
    @Published var list : [aSouldProductMonthly] = []
    
    //listをローカルに保存
    func SaveSoldProductData(){
        if let encoded = try? JSONEncoder().encode(list){
            UserDefaults.standard.set(encoded, forKey: keyName)
        }
    }
    
    //listをローカルデータから読み込む
    init(){
        if let data = UserDefaults.standard.data(forKey: keyName){
            if let decoded = try? JSONDecoder().decode([aSouldProductMonthly].self, from: data){
                list = decoded
                return
            }
        }
        
        list = []
   }

        
    //売れた商品（aSoldProduct）をself.listへ追加
    public func AddSouldProductMonthly(_aSoldProduct: aSoldProduct){
        //初めて商品を追加する場合
        if list.count == 0{
            var newSouldProductMonthly = aSouldProductMonthly(_year: _aSoldProduct.year, _month: _aSoldProduct.month)
            newSouldProductMonthly.souldProducts.append(_aSoldProduct)
            list.append(newSouldProductMonthly)
            SaveSoldProductData()
            return
        }
        
        //既に同じ年月の商品が存在していたら、そこのArrayへ追加
        for i in 0..<list.count{
            let year: Int = list[i].year
            let month: Int = list[i].month
            if year == _aSoldProduct.year && month == _aSoldProduct.month{
                list[i].souldProducts.append(_aSoldProduct)
                SaveSoldProductData()
                return
            }
        }
        
        //同じ年月のArrayが存在していない場合
        var newSouldProductMonthly = aSouldProductMonthly(_year: _aSoldProduct.year, _month: _aSoldProduct.month)
        newSouldProductMonthly.souldProducts.append(_aSoldProduct)
        list.append(newSouldProductMonthly)
        SaveSoldProductData()
    }
    
    //登録した売れた商品をlistから削除
    func RemoveASoldProduct(index : Int, _year : Int, _month : Int){
        for i in 0..<list.count {
            var targetList = list[i]
            let year = targetList.year
            let month = targetList.month
            if year == _year && month == _month{
                targetList.souldProducts.remove(at: index)
                SaveSoldProductData()
            }
        }
    }
    
    //指定した年と月の売れた商品を保持する aSouldProductMonthly は、listの何番目のindexに格納されているかをIntで返す
    func GetIndexNum(_year : Int, _month : Int) -> Int{
        var result : Int = 0
        
        for i in 0..<list.count {
            let targetList = list[i]
            let year = targetList.year
            let month = targetList.month
            if year == _year && month == _month{
                result = i
            }
        }
        return result
        
    }
    
    //指定した年と月の売れた商品を保持するArrayを返す
    func GetMonthlyList (year : Int, month : Int) -> [aSoldProduct]{
        var result : [aSoldProduct] = []
        for i in 0..<list.count {
            if year == list[i].year && month == list[i].month {
                result = list[i].souldProducts
                break
            }
        }
        return result
    }
        
    //売り上げ結果の画面（SalesManagementView）をユーザーが開いたときに、現在の年月の売り上げ結果を表示させるためのメソッド
    func GetProfitForIniti()->Int{
        let nowYear = Calendar.current.dateComponents([.year, .month, .day], from: Date()).year!
        let nowMonth = Calendar.current.dateComponents([.year, .month, .day], from: Date()).month!
        let totalPriceNowMonthly: Int = GetTotalSalesMonthly(year: nowYear, month: nowMonth)
        let totalCostNowMonthly: Int = GetTotalCostMonthly(year: nowYear, month: nowMonth)
        
        return totalPriceNowMonthly - totalCostNowMonthly
    }
    
    //指定した年月の売り上げを返す
    func GetTotalSalesMonthly(year : Int, month : Int) -> Int{
        var totalPrice : Int = 0
        for i in 0..<list.count {
            if year == list[i].year && month == list[i].month {
                for n in 0..<list[i].souldProducts.count {
                    totalPrice += list[i].souldProducts[n].price
                }
                break
            }
        }
        return totalPrice
    }
    
    //指定した年月の売れた商品の全コスト（原価、送料、梱包費）を返す
    func GetTotalCostMonthly(year : Int, month : Int) -> Int{
        var totalCost : Int = 0
        for i in 0..<list.count {
            if year == list[i].year && month == list[i].month {
                for n in 0..<list[i].souldProducts.count {
                    totalCost += list[i].souldProducts[n].shipment + list[i].souldProducts[n].wrappingCost + list[i].souldProducts[n].materialCost
                }
                break
            }
        }
        
        return totalCost
     }
}
///
///
///
//売れた商品の情報を保持するクラス end
///
///
///



//売れた商品を月ごとにまとめて保持
struct aSouldProductMonthly : Hashable, Identifiable, Codable{
    var id = UUID()
    var year : Int
    var month : Int
    var souldProducts : [aSoldProduct] = []
    
    init(_year:Int, _month:Int){
        year = _year
        month = _month
    }
    
    func GetTotalPriceMonthly() -> Int{
        var totalPrice = 0
        for i in 0..<souldProducts.count {
            totalPrice += souldProducts[i].price
        }
        return totalPrice
    }
    
    func GetTotalCostMonthly() -> Int{
        var totalCost : Int = 0
        for i in 0..<souldProducts.count {
            totalCost += souldProducts[i].shipment + souldProducts[i].materialCost + souldProducts[i].wrappingCost
        }
        return totalCost
     }
}



//売れた商品の情報を保持
struct aSoldProduct : Hashable, Identifiable, Codable{
    var id = UUID()
    var year : Int
    var month : Int
    var day : Int
    var name : String
    var shipment : Int
    var wrappingCost : Int
    var materialCost : Int
    var price : Int
    
    init(_name:String, _materialCost:Int, _shipment:Int, _wrappingCost:Int, _price : Int,  _year:Int, _month:Int, _day:Int){
        name = _name
        shipment = _shipment
        wrappingCost = _wrappingCost
        materialCost = _materialCost
        price = _price
        year = _year
        month = _month
        day = _day
    }
    
    func GetTotalCost() -> Int{
        let allAdd : Int = shipment + wrappingCost + materialCost
        return allAdd
    }
}


