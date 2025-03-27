//

import SwiftUI

class ConstantUIStrings {
    static let LOGIN_BUTTON_TITLE: String = "Login"
    static let USERNAME_PLACEHOLDER: String = "Username"
    static let PASSWORD_PLACEHOLDER: String = "Password"
}

enum VacayCustomError: Error {
    case invalidURL
    case decodingFailed
    case dataRequestFailed
}

class Network {
    static func getFood() async throws(VacayCustomError) -> Food {
        guard let url = URL(string: "https://random-data-api.com/api/food/random_food") else { throw VacayCustomError.invalidURL }
        guard let (data, _) = try? await URLSession.shared.data(for: URLRequest(url: url)) else { throw VacayCustomError.dataRequestFailed }
        guard let food: Food = try? JSONDecoder().decode(Food.self, from: data) else { throw VacayCustomError.decodingFailed }
        return food
    }
    
    static func login(username: String, password: String) -> Bool {
        let url = URL(string: "my.server.location")
        //var request = URLRequest(url: url!)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        //request.httpMethod = "POST"
        guard let fullUrl = url?.appending(queryItems: queryItems) else { return false }
        print(fullUrl)
        return true
    }
}

struct Food: Identifiable, Decodable {
    var id: Int
    var uid: String
    var dish: String
    var description: String
    var ingredient: String
    var measurement: String
}

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            LoginFieldView(placeholder: ConstantUIStrings.USERNAME_PLACEHOLDER, label: $username)
            LoginFieldView(placeholder: ConstantUIStrings.PASSWORD_PLACEHOLDER, label: $password)

            Button(action: {
                print("Attempt login: username = " + username + ", password = " + password)
                Task {
                    _ = Network.login(username: username, password: password)
                    let food = try await Network.getFood()
                    print(food)
                }
            }) {
                Text(ConstantUIStrings.LOGIN_BUTTON_TITLE)
                    .font(.headline)
                    .frame(width: 80, height: 40)
                    .foregroundColor(.white)
                    .background(Color.purple.opacity(0.8))
                    .cornerRadius(10)
            }
            .padding(30)
        }
        .padding(15)
    }
}

#Preview {
    LoginView()
}
