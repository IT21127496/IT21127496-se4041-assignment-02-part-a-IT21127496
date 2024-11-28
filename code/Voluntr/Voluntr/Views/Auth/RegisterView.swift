

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var error = ""
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
//            NavigationLink(destination: ProfilePhotoSelectorView(),
//                           isActive: $viewModel.didAuthenticateUser,
//                           label: { })
            
//            AuthHeaderView(title1: "Get started,", title2: "Create your account")
            
            VStack(spacing: 40) {
                CustomInputField(imageName: "envelope",
                                 placeholderText: "Email",
                                 textCase: .lowercase,
                                 keyboardType: .emailAddress,
                                 textContentType: .emailAddress,
                                 text: $email)
                
                CustomInputField(imageName: "person",
                                 placeholderText: "Username",
                                 textCase: .lowercase,
                                 keyboardType: .default,
                                 textContentType: .username,
                                 text: $username)
             
                
                CustomInputField(imageName: "lock",
                                 placeholderText: "Password",
                                 textContentType: .newPassword,
                                 isSecureField: true,
                                 text: $password)
                
                CustomInputField(imageName: "lock",
                                 placeholderText: "Confirm Password",
                                 textContentType: .newPassword,
                                 isSecureField: true,
                                 text: $confirmPassword)
                if !error.isEmpty {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.gray)
                }
                    
            }
            .padding(32)
            
            Button {
                guard password == confirmPassword else{
                    print("Password does not match")
                    error = "Password does not match"
                    return
                }
                error = ""
                print("Sign Up")
                authService.register(withEmail: email,
                                   password: password,
                                   username: username)
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color.themeColor)
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)
                    
                    Text("Sign In")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }.foregroundColor(Color.themeColor)

        }

    }
}


#Preview {
    RegisterView()
}
