

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack{
            VStack {
                VStack(spacing: 40) {
                    Image("BetterHelp_Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    CustomInputField(imageName: "envelope",
                                     placeholderText: "Email",
                                     textCase: .lowercase,
                                     keyboardType: .emailAddress,
                                     textContentType: .emailAddress,
                                     text: $email)
                    
                    
                    CustomInputField(imageName: "lock",
                                     placeholderText: "Password",
                                     textCase: .lowercase,
                                     keyboardType: .default,
                                     textContentType: .password,
                                     isSecureField: true,
                                     text: $password)
                }
                .padding(.horizontal, 32)
                
                Button {
                    print("Sign In")
                    authService.credentialLogin(withEmail: email, password: password)
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color.themeColor)
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                NavigationLink  {
                    RegisterView()
                        .navigationBarHidden(true)
                } label: {
                    HStack {
                        Text("Don't have an account?")
                            .font(.footnote)
                        Text("Sign Up")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(Color.themeColor)
            }
        }
    }
}

#Preview {
    LoginView()
}
