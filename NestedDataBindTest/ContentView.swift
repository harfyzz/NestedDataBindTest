//
//  ContentView.swift
//  NestedDataBindTest
//
//  Created by Afeez Yunus on 27/04/2025.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @StateObject var chartView = ChartView.shared.chartView
    @State var meter1Name = "Meter 1"
    @State var meter1Value:Float = 55
    @State var meter2Name = "Meter 2"
    @State var meter2Value:Float = 75
    @State var meter3Name = "Meter 3"
    @State var meter3Value:Float = 80
    @State var showImage = true
    var body: some View {
        VStack {
            chartView.view()
            VStack{
                if showImage{
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
                Text("Hello, world!")
            }
            .background(Color.gray)
            .onTapGesture {
                meter1Name = "It's changed now"
                meter1Value = 25
                changeBoundObjects()
                print(meter1Name)
            }
        }
        .padding()
        .onAppear{
            changeBoundObjects()
        }
    }
    func changeBoundObjects() {
        //the next syntax can be broken in two, but linking it all on one syntax works just fine if you want to directly name the Viewmodels, which is the approach I'd be taking henceforth
        let chartViewModel = chartView.riveModel!.riveFile.viewModelNamed("Dashboard VM")!
        // now let's call the instance
        // Create and store the instance as a property
        let chartInstance = chartViewModel.createInstance(fromName: "Dash Instance")
        
        // let's bind the instances to the stateMachine
        if let chartInstance = chartInstance {
            chartView.riveModel?.stateMachine?.bind(viewModelInstance: chartInstance)
        }
        
        let speedRawName1 = chartInstance?
            .viewModelInstanceProperty(fromPath: "Speed sub-VM")?.stringProperty(fromPath: "Chart name")
        speedRawName1?.value = meter1Name
       
        
        let speedRawValue1 = chartInstance?
            .viewModelInstanceProperty(fromPath: "Speed sub-VM")?.numberProperty(fromPath: "trim value")
        speedRawValue1?.value = meter1Value
        let listener = speedRawValue1?.addListener({ newValue in
            if newValue == 25 {
                showImage = false
            }
        })
        let speedRawName2 = chartInstance?
            .viewModelInstanceProperty(fromPath: "Fuel sub-VM")?.stringProperty(fromPath: "Chart name")
        speedRawName2?.value = meter2Name
        
        let speedRawValue2 = chartInstance?
            .viewModelInstanceProperty(fromPath: "Fuel sub-VM")?.numberProperty(fromPath: "trim value")
        speedRawValue2?.value = meter2Value
        
        let speedRawName3 = chartInstance?
            .viewModelInstanceProperty(fromPath: "Oil sub-VM")?.stringProperty(fromPath: "Chart name")
        speedRawName3?.value = meter3Name
        
        let speedRawValue3 = chartInstance?
            .viewModelInstanceProperty(fromPath: "Oil sub-VM")?.numberProperty(fromPath: "trim value")
        speedRawValue3?.value = meter3Value
        
        //changes won't reflect without advancing the statemachine
        chartView.triggerInput("advance")
        
        
        // print("the name is \(speedRawName.value)")
        
    }
}

#Preview {
    ContentView()
}

class ChartView: ObservableObject {
    static let shared = ChartView()
    @Published var chartView: RiveViewModel!
    init () {
        chartView = RiveViewModel(fileName: "chart", stateMachineName: "State Machine 1", artboardName: "Dashboard")
    }
}
