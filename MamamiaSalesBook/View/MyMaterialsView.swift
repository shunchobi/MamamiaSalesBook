//
//  MyMaterialsView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/24.
//

import SwiftUI


///
///
//選択した商品に登録されている材料を表示するView
///
///
struct MyMaterialsView: View {
    
    //選択されている商品
    let product : aProduct
    
    var body: some View {
        List{
            Section (header: HStack{
                Spacer()
                VStack{
                    Text("「\(product.name)」")
                        .font(.system(size:25))
                    Spacer().frame(height: 10)
                    Text("使用されている材料リスト")
                        .font(.system(size:18))
                }
                Spacer()
            }){
                //材料を表示
                ForEach(product.myMaterials){material in
                    HStack{
                        Text(material.name)
                        Spacer()
                        Text("\(material.cost)円")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(true)
    }

}
