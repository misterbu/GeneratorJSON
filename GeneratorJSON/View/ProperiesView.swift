//
//  ProperiesView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI

struct ProperiesView: View {
    
    @Binding var properties: [Property]
    @State var types: [Property.Type] = []
    
    init(properties: Binding<[Property]>){
        self._properties = properties
        self._types = .init(initialValue: getTypesOfProperty(for: properties.wrappedValue))
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 30){
            ForEach(types.indices, id: \.self){index in
                PropertySelectView(selected: $properties,
                                   propertyType: types[index])
            }
            
            Spacer()
        }
        
    }
    
    private func getTypesOfProperty(for properties: [Property])->[Property.Type]{
        var result = [Property.Type]()
        properties
            .map({type(of: $0)})
            .forEach({value in
                if !result.contains(where: {$0 == value}) {
                    result.append(value)
                }
            })
        return result
    }
    
    private func getProperties(for selectType: Property.Type)->[Property]{
        self.properties.filter({type(of: $0) == selectType})
    }
}

struct PropertySelectView: View {
    @Binding var selected: [Property]
    var propertyType: Property.Type
    
    var body: some View{
        VStack(spacing: 8){
            Text(propertyType.typeName)
                .foregroundColor(.white)
                .textCase(.uppercase)
            Divider()
                .padding(.horizontal)
                .frame(width: 100)
            
            ForEach(propertyType.allCases, id: \.id){property in
                Text(property.str)
                    .font(.body)
                    .fontWeight(isSelected(property.id) ? .semibold : .regular)
                    .foregroundColor(isSelected(property.id) ? .white : .white.opacity(0.6))
                    .textCase(.uppercase)
                    .onTapGesture {
                        withAnimation{tapTo(property)}
                    }
            }
        }
    }
    
    private func tapTo(_ property: Property){
        //Множественный выбор
        if propertyType.multiSelect {
            //Удаляем элемент из выбранных
            if isSelected(property.id){
                print("Multisell - Remove property \(property.str)")
                selected.removeAll(where: {$0.id == property.id})
            //Добавляем элемен в выбранные
            } else {
                print(" Multisell - Add property \(property.str)")
                selected.append(property)
            }
        //Можно выбрать 1 элемент
        } else {
            //ПОНЯТЬ ПОЧЕМУ Добавляются или удаляются сразу оба элемента
            
//            if !isSelected(property.id) {
//                self.selected.append(property)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.selected.removeAll(where: {type(of: $0) == propertyType && $0.id != property.id})
//                }
//
//            }
        }
        
    }
    
    private func isSelected(_ id: String)->Bool {
         selected.contains(where: {$0.id == id})
    }
}
