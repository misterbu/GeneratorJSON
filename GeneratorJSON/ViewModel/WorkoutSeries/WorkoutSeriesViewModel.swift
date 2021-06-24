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
    
    func generateJSON(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .seriaJSON, create: true) else {return}
        
        url.appendPathComponent("ProgramJSON")
        url.appendPathExtension("json")
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["programs"] = series.map({$0.seria.getForJSON()})
        
        // 3 Конвектируем в JSON и записываем
        do{
            let data = try JSONSerialization.data(withJSONObject: dics)
            try data.write(to: url)
        }
        catch {
            print("We have error while write a new program ")
        }
    }
}
