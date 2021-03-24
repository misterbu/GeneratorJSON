//
//  CoreData.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation
import CoreData

class CoreDataFuncs {
    
    
    /// Default instance
    static var shared = CoreDataFuncs()
    var context = PersistenceController.shared.container.viewContext
    
    private init() {
        
    }
    
    //MARK: -SAVE NEW MODEL
    func add<T: NSManagedObject, S: CoreDatable>(model: S, entity: T.Type) {
        print("CD: Save model with id \(model.id)")
        var entity = entity.init(context: context)
        entity = model.setEntity(entity: entity)
        
        do {
            try context.save()
        } catch  {
            print(error)
        }
    }
    
    //MARK: -GET ALL MODELS
    func getAll<T: NSManagedObject, S: CoreDatable>(entity: T.Type, model: S.Type) -> [S] {
        let entityName = String(describing: entity)
        print("CD: Get all models \(entityName)")
        
        let request = NSFetchRequest<T>(entityName: entityName)
        
        guard let entities = try? context.fetch(request) else {return [S]()}
        return entities.compactMap {model.init(entity: $0)}
    }
    
    func getAll<T: NSManagedObject, S: CoreDatable>(entity: T.Type, model: S.Type, before createAt: Date?) -> [S] {
        let entityName = String(describing: entity)
        print("CD: Get all models \(entityName)")
        
        let request = NSFetchRequest<T>(entityName: entityName)
        
        //Если задали дату, то получаем только результаты до этой даты
        if let date = createAt {
            let predicate = NSPredicate(format: "createAt >= %@", date as NSDate)
            request.predicate = predicate
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]
        
        guard let entities = try? context.fetch(request) else {return [S]()}
        return entities.compactMap {model.init(entity: $0)}
    }
    
    
    
    // MARK: - GET MODEL WITH ID
    func get<T: NSManagedObject, S: CoreDatable>(entity: T.Type, model : S) -> S? {
        let entityName = String(describing: entity)
        print("CD : Get model with id \(model.id)")
        
        let predicate = NSPredicate(format: "id == %@", model.id)
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        
        guard let entities = try? context.fetch(request),
              let newEntity = entities.first else {return nil}
        
        return S.init(entity: newEntity)
        
    }
    
    func get<T: NSManagedObject, S: CoreDatable >(entity: T.Type, model type: S.Type,  id : String) -> S? {
        let entityName = String(describing: entity)
        print("CD : Get model with id \(id)")
        
        let predicate = NSPredicate(format: "id == %@", id)
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        
        guard let entities = try? context.fetch(request),
              let newEntity = entities.first else {return nil}
        
        return S(entity: newEntity)
        
    }
    
    // MARK: - GET ENTITY
    func getEntity<T: NSManagedObject, S: CoreDatable>(entity: T.Type, model : S) -> T{
        let entityName = String(describing: entity)
        print("CD: Get entity \(entityName) with id \(model.id)")
        
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", model.id)
        
        //Создаем модель данных
        var entity: T!
        
        if let entities = try? context.fetch(request), var entity = entities.first  {
            //Если эта модель данных уже существует в БД, скачиваем ее и изменяем
            entity = model.setEntity(entity: entity)
        } else {
            //Если модели данных еще нет в БД, создаем новую
            entity = T.init(context: context)
            entity = model.setEntity(entity: entity)
        }
        
        //Возвращаем модель данных
        return entity
    }
    
    
    
    //MARK: SAVE CHANGED MODEL
    func save<T: NSManagedObject, S: CoreDatable>(entity: T.Type, model: S) {
        let entityName = String(describing: entity)
        print("CD: Save model \(entityName) with id \(model.id)")
        
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", model.id)
        
        //Проверяем есть ли такая запись в CD, если да, то меняем ее и сохраняем. Если нет, создаем новую и записываем
        if let entities = try? context.fetch(request), var entity = entities.first  {
            entity = model.setEntity(entity: entity)
        } else {
            var entity = T.init(context: context)
            entity = model.setEntity(entity: entity)
        }

        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    //MARK: DELETE MODEL
    func delete<T: NSManagedObject, S: CoreDatable>(entity: T.Type, model: S){
        let entityName = String(describing: entity)
        print("CD: Save model \(entityName) with id \(model.id)")
        
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", model.id)
        
        guard let entities = try? context.fetch(request), let entity = entities.first else {return}
        
        context.delete(entity)
        
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
}



import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "fitnessAppGenerator")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
