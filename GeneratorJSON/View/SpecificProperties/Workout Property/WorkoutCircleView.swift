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
    @Binding var additionalView: AnyView?
    var onDelete: (WorkoutCircle)->()

    @EnvironmentObject var exerciseManager: ExercisesViewModel
    
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 10){
                //НАЗВАНИЕ ЦИКЛА
                MyTextField(name: nil, text: $workoutCircle.name)
                
                //УДАЛИТЬ ЦИКЛ
                deleteCircleButton
            }
            
            HStack(spacing: 20){
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20){
                        ForEach(workoutCircle.exercises, id:\.id){exercise in
                            //УПРАЖНЕНИЕ
                            ExerciseItem(exercise: exercise.basic)
                                .onTapGesture {
                                    showEditExerciseView(for: exercise)
                                }
                        }
                        
                        showAddNewExerciseButton
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
    
    // MARK: - DELETE EXERCISE
    private var deleteCircleButton: some View {
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
    
    
    // MARK: EDIT EXERCISE
    private func showEditExerciseView(for exercise: Exercise){
        //FOR STRENGHT
        if let exercise = exercise as? StrenghtExercise {
            withAnimation {
                self.additionalView = AnyView (
                    EditStrenghtExerciseView(viewModel: StrenghtSideViewModel(exercise: exercise)) { changedExercise in
                        self.saveExercise(as: changedExercise)
                    } onDelete: { deletedExercise in
                        self.deleteExercise(deletedExercise)
                    } onClose: {
                        self.closeAdditionalViewView()
                    }
                )
            }
        //FOR HIIT
        } else if let exercise = exercise as? IntervalExercise {
            withAnimation {
                self.additionalView = AnyView (
                    EditHiitExerciseView(viewModel: IntervalSideViewModel(exercise: exercise)) { changedExrcise in
                        self.saveExercise(as: changedExrcise)
                    } onDelete: { deletedExercise in
                        self.deleteExercise(deletedExercise)
                    } onClose: {
                        self.closeAdditionalViewView()
                    }
                )
            }
        }
    }
    
    private func saveExercise(as exercise: Exercise){
        closeAdditionalViewView()
        
        if let index = workoutCircle.exercises.firstIndex(where: {$0.id == exercise.id}) {
            DispatchQueue.main.async {
                workoutCircle.exercises.remove(at: index)
                workoutCircle.exercises.insert(exercise, at: index)
            }
        }
    }

    private func deleteExercise(_ exercise: Exercise){
        closeAdditionalViewView()
        workoutCircle.exercises.removeAll(where: {$0.id == exercise.id})
    }
    
    
    //MARK: ADD EXERCISE
    private var showAddNewExerciseButton: some View {
        Button {
            withAnimation {
                self.additionalView = AnyView(
                    AdditionalItemsCatalog(searchManager: SearchManager(exerciseManager.items
                                                                                .filter({$0.type == workType})),
                                               title: "Add exercise", subtitle: nil,
                                               onSelect: {addExercise($0 as BasicExercise)},
                                               onClose: {closeAdditionalViewView()}))
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
        closeAdditionalViewView()
        
        if exercise.type == .hiit {
            workoutCircle.exercises.append(IntervalExercise(exercise, orderAdd: workoutCircle.exercises.count))
        } else {
            workoutCircle.exercises.append(StrenghtExercise(exercise, orderAdd: workoutCircle.exercises.count))
        }
    }
    
    // MARK: CLOSE ADDITIONAL VIEW
    private func closeAdditionalViewView(){
        withAnimation{self.additionalView = nil}
    }
}

