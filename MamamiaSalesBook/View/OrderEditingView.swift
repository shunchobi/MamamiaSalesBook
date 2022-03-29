//
//  OrderEditingView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/23.
//

import SwiftUI



struct OrderEditingView: View {
    
    @ObservedObject var souldProductAll : SouldProductAll //? remove    arrayを使ってForeach回す

    @State private var selectedDate = Date()
    @State private var selectedYear : Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).year!
    @State private var selectedMonth : Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).month!
    private let yearRange = [Int](2022...2053)
    private let monthRange = [Int](1...12)
    
    @State private var onAlertForYear : Bool = false
    @State private var onAlertForMonth : Bool = false

    
    private let f = NumberFormatter()
        

//    init(){
//        let data = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
//        _selectedYear = State(initialValue: data.year!)
//        _selectedMonth = State(initialValue: data.month!)
//        f.numberStyle = .none
//
//        _array = State(initialValue: self.souldProductAll.GetMonthlyList(year: self.selectedYear, month: self.selectedMonth))
//    }

    
    
    
    var body: some View {
        ZStack{
            VStack{
                Text("編集画面")
                    .font(.largeTitle)
                    .kerning(6)
                
                
                Spacer().frame(height: 50)
                HStack{
                    Spacer()
                    Button(action:{ self.onAlertForYear.toggle()}){
                        Text("\(f.string(from: NSNumber(integerLiteral: self.selectedYear)) ?? "\(self.selectedYear)")年")
                            .font(.system(size:30))
                    }
                    Text(".")
                        .font(.system(size:25))
                    Button(action:{ self.onAlertForMonth.toggle()}){
                        Text("\(f.string(from: NSNumber(integerLiteral: self.selectedMonth)) ?? "\(self.selectedMonth)")月")
                        .font(.system(size:30))
                    }
                    Spacer()
                }
                
                
                
                Spacer()
                List{
                    Section (header: HStack{
                        Spacer()
                        Text("追加した商品をスライドで削除")
                            .font(.system(size:18))
                        Spacer()
                    }){
                        ForEach(GetArray(), id: \.self){ soldProduct in
                            HStack{
                                Text(String(soldProduct.month)+"/"+String(soldProduct.day))
                                Text(soldProduct.name)
                                Spacer()
                                Text(String(soldProduct.GetTotalCost())+"円/")
                                Text(String(soldProduct.price)+"円")
                            }
                        }
                        .onDelete { indexSet in
                            souldProductAll.list[GetIndeNum()].souldProducts.remove(atOffsets: indexSet)
                            souldProductAll.SaveSoldProductData()
                        }
                    }
                }
                .frame(height: 480)
            }
            
            
            
            if onAlertForYear{
                NavigationView{
                    VStack{
                        Picker("yearRange", selection: $selectedYear){
                            ForEach(yearRange, id: \.self){year in
                                Text(String(year)+"年")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                        
                        Button("閉じる", action:{
                            onAlertForYear.toggle()
                        })
                    }
                }
            }
        
        
        
            if onAlertForMonth{
                NavigationView{
                    VStack{

                    Picker("yearRange", selection: $selectedMonth){
                        ForEach(monthRange, id: \.self){month in
                            Text(String(month)+"月")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                    
                    Button("閉じる", action:{
                        onAlertForMonth.toggle()})
                    }
                }
            }
        }
    }
    
    
//    func removeRows(at offsets: IndexSet) {
////        GetArray().remove(atOffsets: offsets)
//        let i : Int = Int(offsets)
//        souldProductAll.RemoveASoldProduct(index: offsets, _year: selectedYear, _month: selectedMonth)
//    }
    
    
    func GetArray() ->[aSoldProduct]{
        return souldProductAll.GetMonthlyList(year: selectedYear, month: selectedMonth)
    }
    
    
    func GetIndeNum() -> Int{
        return souldProductAll.GetIndexNum(_year: selectedYear, _month: selectedMonth)
    }
}




//
//
//struct OrderEditingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderEditingView()
//    }
//}
