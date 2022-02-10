
import SwiftUI

struct EditStrenghtExerciseView: View {

    @State var exercise: StrenghtExercise
    var onSave: (Exercise)->()
    var onDelete:(Exercise)->()
    var onClose: ()->()

    var body: some View {
        VStack(alignment: .center, spacing: 30){
            
            CloseButton {
                onClose()
            }
            
            //НАЗВАНИЕ
            VStack(alignment: .center, spacing: 10){
                Text("EDIT")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(exercise.basic.name.uppercased() )
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            
            //СЕТЫ
            VStack(alignment:.center){
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15){
                        
                        //НАИМЕНОВАНИЕ СТОЛБЦОВ(КОЛ_ВО ПОВТОРЕНИЙ И РАЗМИНКА)
                        HStack(spacing: 40){
                            Text("Delete")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("REPS:")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 80)
                            Text("WarmUp")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                       // CЕТЫ
                        ForEach($exercise.sets, id:\.id){$exSet in
                            EditStrenghtExerciseSetView(exSet: $exSet,
                                                        onDelete: {deleteSet($0)})
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                        //ДОБАВИТЬ СЕТ
                        addSet
                            .padding(.top, 20)
                    }
                }
            }
            
            Spacer()
            
            //BUTTONS
            HStack{
                IconButton(icon: "trash") {}
                .opacity(0)
                Spacer()
                // MARK: - КНОПКА СОХРАНИТЬ
                ButtonWithIcon(name: "Save",
                               icon: "square.and.arrow.down.on.square",
                               font: .title2) {
                    onSave(exercise)
                }
                Spacer()
                // MARK: - КНОПКА   УДАЛИТЬ
                IconButton(icon: "trash") {
                    onDelete(exercise)
                }
            }
        }
    }
    
    private var addSet: some View {
        Button {
            withAnimation{
            self.exercise.sets.append(ExerciseSet(order: self.exercise.sets.count))
            }
        } label: {
            Image(systemName: "plus.circle")
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.5))
        }.buttonStyle(PlainButtonStyle())
        
    }
    
    private func deleteSet(_ exSet: ExerciseSet){
        withAnimation{
            exercise.sets.removeAll(where: {$0.id == exSet.id})
        }
    }
    
    
}

struct EditStrenghtExerciseView_Preview: PreviewProvider {
    static var previews: some View {
        EditStrenghtExerciseView(exercise: .sample,
                                 onSave: {_ in},
                                 onDelete: {_ in},
                                 onClose: {})
            .preferredColorScheme(.dark)
    }
}
