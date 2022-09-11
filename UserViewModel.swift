import SwiftUI

struct UserModel: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let age: Int
}

class UserViewModel: ObservableObject {
    @Published var userList: [UserModel] = []
    @Published var isLoading: Bool = false
    
    init () {
        getUsers()
    }
    
    func getUsers () {
        let user1 = UserModel(name: "Tim", age: 25)
        let user2 = UserModel(name: "Elena", age: 20)
        let user3 = UserModel(name: "Gabriel", age: 28)
        let user4 = UserModel(name: "Simona", age: 35)
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
            self.userList.append(user1)
            self.userList.append(user2)
            self.userList.append(user3)
            self.userList.append(user4)
            self.isLoading = false
        }
        
    }
    
    func deleteUser (index: IndexSet) {
        userList.remove(atOffsets: index)
    }
}

struct ViewModel: View {
    
    @StateObject var userViewModel: UserViewModel = UserViewModel()
    
    var body: some View {
        
        NavigationView {
            List {
                
                if (userViewModel.isLoading) {
                    ProgressView() } else {
                        
                        ForEach(userViewModel.userList) { user in
                            HStack {
                                Text(user.name).fontWeight(.bold).font(.body)
                                Spacer()
                                Text("Age: \(user.age)").font(.callout).foregroundColor(.red)
                                
                            }
                            
                        }.onDelete(perform: userViewModel.deleteUser)
                    }
                
            }.navigationTitle("User List").navigationBarItems(trailing: NavigationLink(destination: SecondPageView(userViewModel: userViewModel), label: {
                Image(systemName: "arrow.right").font(.body)
            }))
        }
    }
    
    
    
    struct SecondPageView : View {
        
        @ObservedObject var userViewModel: UserViewModel
        
        var body: some View {
            ZStack {
                List {
                    ForEach(userViewModel.userList) { user in
                        HStack {
                            Text(user.name).fontWeight(.bold).font(.body)
                            Spacer()
                            Text("Age: \(user.age)").font(.callout).foregroundColor(.red)
                        }
                    }.onDelete(perform: userViewModel.deleteUser)
                }
            }
        }
    }
    
    struct ViewModel_Previews: PreviewProvider {
        static var previews: some View {
            ViewModel()
        }
    }
}
