//
//  SearchManager.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI
import Combine

class SearchManager<SearchItem: CatalogTitle & HasProperties>: ObservableObject {
    
    private(set) var allItems: [SearchItem]
    @Published private(set) var visibleItems: [SearchItem] = []
    
    private var searchedItems: CurrentValueSubject<[SearchItem], Never>
    @Published var search: String = ""
    
    private var filtredItems: CurrentValueSubject<[SearchItem], Never>
    @Published private(set) var selectedFilters: [Property] = [] {
        didSet{
            self.selectedFieltersIsEmpty = selectedFilters.isEmpty
        }
    }
    @Published private(set) var selectedFieltersIsEmpty: Bool = true //Нужно чтобы не реализовывать соответствие протокола Filter to Equatable (Нужно при .onChange в View)
    
    @Published var isActive: Bool = false //Указывает когда активирован поиск или фильтрация
    
    private var cancellables: [AnyCancellable] = []
    
    init(_ items: [SearchItem]){
        self.allItems = items
        self.searchedItems = .init(items)
        self.filtredItems = .init(items)
        
        setVisible()
        activeObserve()
        searchObserve()
        filterObserve()
    }
    
    
    // MARK: - REMOVE ITEM
    func remove(for item: SearchItem){
        self.allItems.removeAll(where: {$0.id == item.id})
        
        withAnimation(.easeIn(duration: 0.15)){
            self.visibleItems.removeAll(where: {$0.id == item.id})
        }
    }
    
    // MARK: - SET VISIBLE
    private func setVisible(){
        searchedItems
            .combineLatest(filtredItems)
            .sink(receiveValue: {[weak self] searchValues, filteredValues in
                guard let self = self else {return}
                
                self.visibleItems = searchValues.compactMap({ item in
                    if filteredValues.contains(where: {$0.id == item.id}) {
                        return item
                    } else {
                        return nil
                    }
                })
            }).store(in: &cancellables)
    }
    
    // MARK: - SEARCH
    private func searchObserve(){
        $search
            //Remove duplicates
            .removeDuplicates()
            //Make a pause of 0.5sec for wait when user finished to input text
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: {[weak self]  value in
                guard let self = self else {return}
                
                //Reset search
                if value == "" {
                    self.searchedItems.send(self.allItems)
                }
                
                if value.count >= 2 {
                    self.search(value.lowercased())
                }
            }).store(in: &cancellables)
    }
    
    private func search(_ value: String){
        
        guard value != "" else {return}
        
        self.searchedItems.send(
            allItems.filter({item in
                //Search in Name
                //Делим название на отдельные слова. И сравниваем введенное значение с началом каждого слова
                if item.name.isContainEqual(value) != nil {return true}
                //Search in Properties
                if item.properties.contains(where: { $0.str.isContainEqual(value) != nil }) {return true}
                 
                return false
            })
        )
    }
    
    func searchReset(){
    self.search = ""
}
    
    // MARK: - FILTER
    private func filterObserve(){
        $selectedFilters
            .sink(receiveValue: {[weak self] filters in
                guard let self = self else {return}
                
                //1. Делим все фильтны на группы фильтров (по типу фильтров)
                let groupedFilters = Dictionary(grouping: filters, by: {$0.type})
                
                //2. Заменяем группы фильтнов на Массивы элементов для каждой группы
                var groupedItems = groupedFilters
                    .mapValues { values  in
                        self.allItems.filter { item in
                            item.properties.contains(where: {itemFilter in
                                values.contains(where: {$0.id == itemFilter.id})
                            })
                        }
                    }
                    .map({$0.value})
                
                //3. Отфильтровываем пустые массивы
                groupedItems = groupedItems.filter({!$0.isEmpty})

                //4. Берем первый массив элементов
                guard var firstGroup = groupedItems.first else {
                    self.filtredItems.send(self.allItems)
                    return
                }
                
                //5. Отфильтровываем элементы, которые не содержатся в остальных массивах
                //т.е. выбираем только элементы, которые есть во всех массивах
                groupedItems.forEach({secondItems in
                    firstGroup = firstGroup.filter({item in
                        secondItems.contains(where: {$0.id == item.id})
                    })
                })
                
                self.filtredItems.send(firstGroup)

                
            }).store(in: &cancellables)
    }
    
    
    func selectFilter(_ filter: Property){
        if selectedFilters.contains(where: {$0.id == filter.id}) {
            selectedFilters.removeAll(where: {$0.id == filter.id})
        } else {
            selectedFilters.append(filter)
        }
    }
    
    func resetFilters(){
        self.selectedFilters = []
    }
    
    func removeFilter(_ filter: Property){
        self.selectedFilters.removeAll(where: {$0.id == filter.id})
    }
    
    // MARK: - ACTIVE
    private func activeObserve(){
        $search
            .combineLatest($selectedFilters)
            .sink(receiveValue: {[weak self] (searchValue, filtersValue) in
                guard let self = self else {return}
                
                if searchValue != "" || !filtersValue.isEmpty {
                    self.isActive = true
                } else {
                    self.isActive = false
                }
            }).store(in: &cancellables)
    }

}
