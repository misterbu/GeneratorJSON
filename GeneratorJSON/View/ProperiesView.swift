//
//  ProperiesView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI

struct ProperiesView<Item: HasProperties>: View {
    
    @Binding var item: Item
    @State var propertiesTypes: [Property.Type] = []
    
    init(item: Binding<Item>){
        self._item = item
        
        //Different array of Properties Types for Programs, Workouts, Exercises
        switch item.wrappedValue.self{
        case is WorkoutProgmar:
            self._propertiesTypes = .init(initialValue: [WorkType.self, LevelType.self, TargetType.self, PlaceType.self])
            break
        case is Workout:
            self._propertiesTypes = .init(initialValue: [WorkType.self, LevelType.self, EquipmentType.self, PlaceType.self, MuscleType.self])
            break
        case is BasicExercise:
            self._propertiesTypes = .init(initialValue: [WorkType.self, EquipmentType.self, PlaceType.self, MuscleType.self])
        default:
            break
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 30){
            ForEach(propertiesTypes.indices, id: \.self){index in
                PropertySelectView(selected: $item.properties,
                                   propertyType: propertiesTypes[index])
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
        self.item.properties.filter({type(of: $0) == selectType})
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
                        tapTo(property: property)
                    }
            }
        }
    }
    
    private func tapTo(property: Property){
        //Множественный выбор
        if propertyType.multiSelect {

            //Удаляем элемент из выбранных
            if isSelected(property.id){
                selected.removeAll(where: {$0.id == property.id})
            //Добавляем элемен в выбранные
            } else {
                selected.append(property)
            }
            //Можно выбрать 1 элемент
        } else {
            selected
                selected.removeAll(where: {type(of: $0) == propertyType})
                selected.append(property)
        }
    }
    
    private func isSelected(_ id: String)->Bool {
         selected.contains(where: {$0.id == id})
    }
}
