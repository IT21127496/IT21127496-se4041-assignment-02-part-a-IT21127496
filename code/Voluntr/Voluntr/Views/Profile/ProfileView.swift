

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack{
            List {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                Text(authService.currentUser?.username ?? "no names")
                    .font(.title)
                }
                
                NavigationLink {
                    JoinedEventsView()
                } label: {
                    Text("Joined events")
                }
                
                NavigationLink {
                    MyEventsView()
                } label: {
                    Text("My Events")
                }
                
                Button("Log out") {
                    print("Log out tapped!")
                    authService.logout()
                }
                
                
            }
            .navigationTitle("Profile")
        }
//    detail: {
//            Text("Profile")
//        }
    }
}

#Preview {
    ProfileView().environmentObject(AuthService())
}
