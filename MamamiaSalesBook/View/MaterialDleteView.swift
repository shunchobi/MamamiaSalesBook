//
//  MaterialDleteView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/26.
//

import SwiftUI

struct MaterialDleteView: View {
    
    @ObservedObject var materialCategolies : MaterialCategolies
    @State var materialCategory: aMaterialCategoly
    @State var material: aMaterial
    
    var body: some View {
        NavigationView{
            ZStack() {
                    Rectangle()
                    .foregroundColor(.white)
                    VStack {
                        Spacer()
                        Text("「\(material.name)」")
                        Text("この材料を消しますか？")
                        Spacer()
                        HStack {
                            Spacer()
                            Button("OK") {
                                let deleteName: String = material.name
                                for i in 0..<materialCategory.materials.count{
                                    let targetName = materialCategory.materials[i].name
                                    if targetName == deleteName{
                                        materialCategory.materials.remove(at: i)
                                        break
                                    }
                                }
                                materialCategolies.SaveMaterialData()
                            }
                            .frame(width: 100, height: 15)
                            .buttonStyle(.borderedProminent)
                        }
                        Spacer()
                    }.padding()
//                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
//                                AddCategolyButtonAvariable()
//                            }
            }
            .frame(width: 300, height: 180,alignment: .center)
            .cornerRadius(20).shadow(radius: 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

