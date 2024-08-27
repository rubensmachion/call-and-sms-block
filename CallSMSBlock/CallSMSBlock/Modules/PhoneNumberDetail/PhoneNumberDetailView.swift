import SwiftUI

struct PhoneNumberDetailView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var viewModel: PhoneNumberViewModel

    @State private var phoneName = ""
    @State private var phoneDDI = "55"
    @State private var fromPhoneNumber = ""
    @State private var toPhoneNumber = ""

    init(appCoordinator: AppCoordinator) {
        self.viewModel = .init(appCoordinator: appCoordinator)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            buildTextFieldName()
            
            Text("Block numbers")
            buildTextFieldPhoneNumber()

            buildLabelHint()

            Spacer()
        }
        .padding()
        .navigationTitle("Add new block")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Salvo com sucesso",
               isPresented: $viewModel.isPresent,
               actions: {
            Button {
                viewModel.back()
            } label: {
                Text("OK")
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let result = viewModel.save(name: phoneName,
                                                ddi: phoneDDI,
                                                fromNumber: fromPhoneNumber,
                                                toNumber: toPhoneNumber)
                    if result {
                        viewModel.isPresent = true
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func buildTextFieldName() -> some View {
        TextField(text: $phoneName) {
            Text("Digite um nome(opcional)")
        }
        .textFieldStyle(.roundedBorder)
        .keyboardType(.namePhonePad)
        .textInputAutocapitalization(.words)
    }

    @ViewBuilder
    private func buildTextFieldPhoneNumber() -> some View {
        Group {
            HStack {
                TextField(text: $phoneDDI) {
                    Text("55")
                }
                .frame(width: 60)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)

                TextField(text: $fromPhoneNumber) {
                    Text("Digite o telefone")
                }
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
                .onChange(of: fromPhoneNumber) { newValue in
                    if let formatted = viewModel.formatNumber(newValue, ddi: phoneDDI)  {
                        fromPhoneNumber = formatted
                    }
                }

                Text("to")

                TextField(text: $toPhoneNumber) {
                    Text("Digite o telefone")
                }
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
                .onChange(of: toPhoneNumber) { newValue in
                    if let formatted = viewModel.formatNumber(newValue, ddi: phoneDDI)  {
                        toPhoneNumber = formatted
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func buildLabelHint() -> some View {
        let text = """
        Esta ação bloqueará ligações e SMSs deste número

        Dica:
        Você também pode bloquear sequências de números, por exemplo:

        11 5036-4900 … 11 5036-4999

        Isto significa que serão bloqueados os 99 números que comecem com “11 5036-49XX”
        """

        Text(text)
            .font(.footnote)
            .foregroundStyle(.gray)
    }
}

//#Preview {
//    PhoneNumberDetail(phoneNumber: nil)
//}
