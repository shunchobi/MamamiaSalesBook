//
//  OrderEditingView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/23.
//

import SwiftUI


///
///
//登録した注文情報の表示と削除を行うView
///
///
struct OrderEditingView: View {
    
    @ObservedObject var souldProductAll : SouldProductAll

    //カレンダー
    @State private var selectedDate = Date()
    @State private var selectedYear: Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).year!
    @State private var selectedMonth: Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).month!
    
    //選択可能な年月のInt値
    private let yearRange: [Int] = [Int](2022...2053)
    private let monthRange: [Int] = [Int](1...12)
    
    //各アラートの表示非表示をBoolで管理
    @State private var onAlertForYear: Bool = false
    @State private var onAlertForMonth: Bool = false

    //年月の値をNumberFormatterで変換するためのもの
    private let numberFormatter = NumberFormatter()
    
    
    var body: some View {
        ZStack{
            VStack{
                //タイトル
                Text("編集画面")
                    .font(.largeTitle)
                    .kerning(6)
                
                //表示と削除を行いたい年月を指定するButton
                Spacer().frame(height: 50)
                HStack{
                    Spacer()
                    Button(action:{ self.onAlertForYear.toggle()}){
                        Text("\(numberFormatter.string(from: NSNumber(integerLiteral: self.selectedYear)) ?? "\(self.selectedYear)")年")
                            .font(.system(size:30))
                    }
                    Text(".")
                        .font(.system(size:25))
                    Button(action:{ self.onAlertForMonth.toggle()}){
                        Text("\(numberFormatter.string(from: NSNumber(integerLiteral: self.selectedMonth)) ?? "\(self.selectedMonth)")月")
                        .font(.system(size:30))
                    }
                    Spacer()
                }
                
                //指定した年月に登録されている注文商品を表示
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
                        //スライドで削除
                        .onDelete { indexSet in
                            souldProductAll.list[GetIndeNum()].souldProducts.remove(atOffsets: indexSet)
                            souldProductAll.SaveSoldProductData()
                        }
                    }
                }
                .frame(height: 480)
            }
            
            //表示と削除を行いたい年を指定するためのアラート
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
        
        
            //表示と削除を行いたい月を指定するためのアラート
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
    
        
    //指定した年月の注文商品を保持する配列データを返すメソッド
    func GetArray() ->[aSoldProduct]{
        return souldProductAll.GetMonthlyList(year: selectedYear, month: selectedMonth)
    }
    
    //指定した年月の注文商品を保持する配列データの自身のIndex数値を返すメソッド
    func GetIndeNum() -> Int{
        return souldProductAll.GetIndexNum(_year: selectedYear, _month: selectedMonth)
    }
}

