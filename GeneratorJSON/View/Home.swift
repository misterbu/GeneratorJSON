
import SwiftUI

struct Home: View {
    
    @State var activeTab: MainPageType = .programs
    
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var programsManager: ProgramsManager
    @EnvironmentObject var exercisesViewModel: ExercisesViewModel
    
    @State var generatingJSON: Bool = false
    
    var body: some View {
        ZStack{
            HStack(spacing: 0){
                // MARK: - ЛЕВЫЙ СТОЛБ ВЫБОРА: Программы, тренировки, упр
                VStack(spacing: 30){
                    TabButton(pageType: .programs, activeTab: $activeTab)
                    TabButton(pageType: .workouts, activeTab: $activeTab)
                    TabButton(pageType: .exercises, activeTab: $activeTab)
                    
                    Spacer()
                    
                    generateJSONButton
                }
                .padding(.vertical, 35)
                .padding(.horizontal, 10)
                .background(BlurWindow())
                
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
                
                // MARK: - ОСНОВНОЙ КОНТЕНТ
                ZStack{
                    switch activeTab {
                    case .programs:
                        CatalogContainer(manager: programsManager)
                    case .workouts:
                        CatalogContainer(manager: workoutsManager)
                    case .exercises:
                        CatalogContainer(manager: exercisesViewModel)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if generatingJSON {
                Color.black.opacity(0.8)
                
                Text("GENERATING JSON ... ")
                    .font(.largeTitle)
                    .foregroundColor(.white.opacity(0.3))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: NSScreen.width/1.2, height: NSScreen.height/1.2)
    }
    
    
    var generateJSONButton: some View {
        Button {
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    withAnimation{generatingJSON = true}
                }
                
                workoutsManager.generateJSON()
                programsManager.generateJSON()
                exercisesViewModel.generateJSON()
                
                DispatchQueue.main.async {
                    withAnimation{generatingJSON = false}
                }
            }
           
            
            
        } label: {
            VStack{
                Image(systemName: "square.and.arrow.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                Text("JSON")
                    .font(.body)
            }
            .foregroundColor(.gray)
            .padding()
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct Home_Preview: PreviewProvider {
    static var previews: some View{
        Home()
            .preferredColorScheme(.dark)
            .environmentObject(WorkoutsManager())
            .environmentObject(ProgramsManager())
            .environmentObject(ExercisesViewModel())
    }
}
