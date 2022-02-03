//
//  WorkoutCircleView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.10.2021.
//

import SwiftUI

struct WorkoutCircleView: View {
    @Binding var workoutCircle: WorkoutCircle
    var workType: WorkType
    @Binding var exercisesCatalogView: AnyView?
    var onDelete: (WorkoutCircle)->()
    
    //@State var showExerciseCatalog = false
    
    @EnvironmentObject var exerciseManager: ExercisesViewModel
    
    @State var showExerciseEdit = false
    @State var selectedExercise: Exercise = StrenghtExercise()
    
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 10){
                //НАЗВАНИЕ ЦИКЛА
                MyTextField(name: nil, text: $workoutCircle.name)
                
                //УДАЛИТЬ ЦИКЛ
                deleteButton
            }
            
            HStack(spacing: 20){
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20){
                        ForEach(workoutCircle.exercises, id:\.id){exercise in
                            //УПРАЖНЕНИЕ
                            ExerciseItem(exercise: exercise.basic)
                                .onTapGesture {
                                    self.selectedExercise = exercise
                                    self.showExerciseEdit = true
                                }
                                //РЕДАКТИРОВАНИЕ УПРАЖНЕНИЙ
                                .sheet(isPresented: $showExerciseEdit) {
                                    //ЕСЛИ СИЛОВОЕ УПРАЖНЕНИЕ
                                    if let exercise = selectedExercise as? StrenghtExercise {
                                        StrenghtExerciseSidePage(viewModel: StrenghtSideViewModel(exercise: exercise)) { changedExercise in
                                            //СОХРАНЯЕМ ИЗМЕННЕНИЯ УПР
                                            if let index = workoutCircle.exercises.firstIndex(where: {$0.id == changedExercise.id}) {
                                                DispatchQueue.main.async {
                                                    workoutCircle.exercises.remove(at: index)
                                                    workoutCircle.exercises.insert(changedExercise, at: index)
                                                    
                                                    showExerciseEdit = false
                                                }
                                            }
                                        } onDelete: { deletedExercise in
                                            //УДАЛЯЕМ УПР
                                            workoutCircle.exercises.removeAll(where: {$0.id == deletedExercise.id})
                                            showExerciseEdit = false
                                        } onClose: {
                                            //ЗАКРЫВАЕМ РЕДАКТИРОВАНИЕ УПР
                                            showExerciseEdit = false
                                        }
                                    //ЕСЛИ ИНТЕРВАЛЬНОЕ УПРАЖНЕНИЕ
                                    } else if let exercise = selectedExercise as? IntervalExercise {
                                        IntervalExerciseSidePage(viewModel: IntervalSideViewModel(exercise: exercise)) { changedExrcise in
                                            if let index = workoutCircle.exercises.firstIndex(where: {$0.id == changedExrcise.id}) {
                                                DispatchQueue.main.async {
                                                    workoutCircle.exercises.remove(at: index)
                                                    workoutCircle.exercises.insert(changedExrcise, at: index)
                                                    showExerciseEdit = false
                                                }
                                            }
                                        } onDelete: { deletedExercise in
                                            //УДАЛЯЕМ УПР
                                            workoutCircle.exercises.removeAll(where: {$0.id == deletedExercise.id})
                                            showExerciseEdit = false
                                        } onClose: {
                                            //ЗАКРЫВАЕМ РЕДАКТИРОВАНИЕ УПР
                                            showExerciseEdit = false
                                        }

                                    }
                                }
                        }
                        
                        //ADD EXERCISE
                        addExerciseButon
//                            .sheet(isPresented: $showExerciseCatalog) {
//                                //КАТАЛОГ УПРЖАНЕНИЙ
//                                ExerciseCatalog(show: $showExerciseCatalog) { basic in
//                                    //ВЫБРАЛИ УПР В КАТАЛОГЕ
//                                    if basic.type == .strenght {
//                                        //ЕСЛИ ЭТО СИЛОВОЕ УПР
//                                        let exercise = StrenghtExercise(basic, order: workoutCircle.exercises.count)
//                                        workoutCircle.exercises.append(exercise)
//                                    } else if basic.type == .hiit {
//                                        //ЕСЛИ ЭТО ИНТЕРВАЛЬНОЕ УПР
//                                        let exercise = IntervalExercise(basic, order: workoutCircle.exercises.count)
//                                        workoutCircle.exercises.append(exercise)
//                                    }
//                                    
//                                    //ЗАКРЫВАЕМ КАТАЛОГ УПР
//                                    self.showExerciseCatalog = false
//                                }
//                            }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .frame(width: 600, height: 220)
        .background(Color.black.opacity(0.4))
        .cornerRadius(10)

    }
    
    private var deleteButton: some View {
        Button {
            onDelete(workoutCircle)
        } label: {
            Image(systemName: "trash.circle")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .padding(4)
                .contentShape(Circle())
        }.buttonStyle(PlainButtonStyle())

    }
    
    private var addExerciseButon: some View {
        Button {
            withAnimation {
                self.exercisesCatalogView = AnyView(AdditionalCatalogItemsView(searchManager: SearchManager(exerciseManager.items
                                                                                                                .filter({$0.type == workType})),
                                                                               title: "Add exercise", subtitle: nil,
                                                                               onSelect: {addExercise($0 as BasicExercise)},
                                                                               onClose: {closeExercisesCatalogView()}))
            }
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white.opacity(0.4))
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.4), lineWidth: 2))
                .contentShape(RoundedRectangle(cornerRadius: 10))
        }.buttonStyle(PlainButtonStyle())

    }

    private func addExercise(_ exercise: BasicExercise){
        withAnimation{self.exercisesCatalogView = nil}
        
        if exercise.type == .hiit {
            workoutCircle.exercises.append(IntervalExercise(exercise, orderAdd: workoutCircle.exercises.count))
        } else {
            workoutCircle.exercises.append(StrenghtExercise(exercise, orderAdd: workoutCircle.exercises.count))
        }
    }
    
    private func closeExercisesCatalogView(){
        withAnimation{self.exercisesCatalogView = nil}
    }
}

