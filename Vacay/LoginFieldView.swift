//
import SwiftUI


struct LoginFieldView: View {
    let placeholder: String
    @Binding var label: String
    
    var body: some View {
        TextField(placeholder, text: $label)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .onSubmit {
                print(placeholder + " submitted: " + label )
                
            }
            .frame(width: 250, height: 50)
            .background(Color.purple.opacity(0.15))
            .cornerRadius(10)
    }
}

#Preview {
    @Previewable @State var previewLabel: String = ""
    LoginFieldView(placeholder: "Username", label: $previewLabel)
}
