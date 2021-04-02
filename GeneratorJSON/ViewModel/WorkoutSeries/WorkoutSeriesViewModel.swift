//
//  WorkoutSeriesViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.04.2021.
//

import SwiftUI
import Combine
class WorkoutSeriesViewModel: ObservableObject {
    @Published var series: [WorkoutSeriaViewModel] = []
    @Published var seria: WorkoutSeriaViewModel?
    
    /// - TAG: Combine
    private lazy var cancellables: [AnyCancellable] = []
    
    init(){
        
        //подписываемся на уведомление о добавлении новых серий
        NotificationCenter.default.publisher(for: .saveNewSeria)
            .sink(receiveValue: {[weak self] _ in
                guard let self = self else {return}
                
                //Обновляем каталог серий
                self.getAllSeries()
                
                //Закрываем окно редактированя серии
                self.close()
            }).store(in: &cancellables)
        
        //получаем все серии
        getAllSeries()
    }
    
    func getAllSeries(){
        self.series = CoreDataFuncs.shared.getAll(entity: WorkoutsSeriaEntity.self, model: WorkoutSeria.self)
            .map({WorkoutSeriaViewModel($0)})
    }
    
    func createNewSeria(){
        self.seria = WorkoutSeriaViewModel(WorkoutSeria())
    }
    
    func choseSeria(_ index: Int){
        self.seria = series[index]
    }
    
    func close(){
        seria = nil
    }
}
