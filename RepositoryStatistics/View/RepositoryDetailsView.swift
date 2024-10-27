//
//  RepositoryDetailsView.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import SwiftUI
import Charts

struct RepositoryDetailsView: View {
    let repository: Repository
    @StateObject private var viewModel = RepositoryDetailViewModel(githubService: GithubServiceIssues(networkProvider: NetworkingService(baseURL: URL(string: "https://api.github.com")!)))
    
    @State private var selectedDataPoint: IssueCount? = nil
    @State private var yScale: CGFloat = 1.0
    @State private var dateScale: CGFloat = 1.0
    @State private var offset: CGFloat = 0.0
    @State private var showDataPointInfo = false
    
    var body: some View {
        VStack {
            // Display key repository statistics
            VStack(alignment: .leading, spacing: 10) {
                Text("⭐️ Stars: \(repository.stargazersCount ?? 0)")
                Text("🍴 Forks: \(repository.forksCount ?? 0)")
                Text("🐞 Open Issues: \(viewModel.issues.count)")
            }
            .padding()
            
            // Chart for issue history
            if viewModel.issueCounts.isEmpty {
                Text("Loading issue data...")
                    .onAppear {
                        Task {
                            await viewModel.fetchRepositoryIssues(for: repository)
                        }
                    }
            } else {
                Chart(viewModel.issueCounts) { issueCount in
                    createLineMark(for: issueCount)
                    // Adding PointMark for tap detection
                    createPointMark(for: issueCount)
                    
                }
                .chartYAxisLabel("Number of Issues")
                .chartXAxisLabel("Weeks")
                .frame(height: 300)
                .padding()
                .chartYScale(domain: 0...(viewModel.issueCounts.map { $0.count }.max() ?? 1) * yScale) // Scale Y-axis
                .chartXScale(domain: computeXDomain())
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            yScale = value.magnitude
                        }
                )
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            offset = value.translation.width
//                        }
//                        .onEnded { _ in
//                            dateScale += offset / 1000 // Adjust factor as needed for smooth scaling
//                            offset = 0
//                        }
//                )
            }
        }
        .navigationTitle(repository.name)
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
        .overlay(
            // Overlay to display additional information
            Group {
                if showDataPointInfo, let dataPoint = selectedDataPoint {
                    dataPointOverlay(for: dataPoint)
                }
            }
                .animation(.easeInOut, value: showDataPointInfo)
        )
    }
    
    // Function to create the line mark
    private func createLineMark(for issueCount: IssueCount) -> some ChartContent {
        LineMark(
            x: .value("Date", issueCount.weekStart),
            y: .value("Issues", issueCount.count)
        )
        .interpolationMethod(.catmullRom)
        .foregroundStyle(.blue)
        .lineStyle(.init(lineWidth: 2))
        .symbol {
            Circle()
                .fill(.cyan)
                .frame(width: 12, height: 12)
        }
    }
    
    // Function to create the point mark with tap gesture
    private func createPointMark(for issueCount: IssueCount) -> some ChartContent {
        PointMark(
            x: .value("Date", issueCount.weekStart),
            y: .value("Issues", issueCount.count)
        )
        .foregroundStyle(.red) // Make it invisible
        .annotation(position: .overlay) {
            Rectangle()
                .foregroundStyle(.yellow) // Make the rectangle clear
                .frame(width: 20, height: 20)
//                .contentShape(Rectangle()) // Define the tappable area
                .onTapGesture {
                    selectedDataPoint = issueCount
                    showDataPointInfo = true
                }
        }
    }
    
    // Overlay view to display data point information
    @ViewBuilder
    private func dataPointOverlay(for dataPoint: IssueCount) -> some View {
        VStack {
            Text("Details for Selected Data Point")
                .font(.headline)
                .padding(.bottom, 2)
            Text("Date: \(dataPoint.weekStart.formatted(date: .abbreviated, time: .omitted))")
            Text("Issues: \(dataPoint.count)")
        }
        .padding()
        .background(Color.gray.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 5)
        .onTapGesture {
            showDataPointInfo = false // Dismiss overlay on tap
        }
    }
    
    // Compute dynamic X-axis domain based on dateScale
    private func computeXDomain() -> ClosedRange<Date> {
        guard let minDate = viewModel.issueCounts.map({ $0.weekStart }).min(),
              let maxDate = viewModel.issueCounts.map({ $0.weekStart }).max() else {
            return Date()...Date()
        }
        
        let interval = maxDate.timeIntervalSince(minDate) * Double(dateScale)
        let adjustedMinDate = minDate.addingTimeInterval(-interval / 2)
        let adjustedMaxDate = maxDate.addingTimeInterval(interval / 2)
        
        return adjustedMinDate...adjustedMaxDate
    }
    
//    /// Chart Popover View
//    @ViewBuilder
//    func ChartPopOverView(_ downloads: Double, _ month: String, _ isTitleView: Bool = false, _ isSelection: Bool = false) -> some View {
//        VStack(alignment: .leading, spacing: 6) {
//            Text("\(isTitleView && !isSelection ? "Highest" : "App") Downloads")
//                .font(.title3)
//                .foregroundStyle(.gray)
//            
//            HStack(spacing: 4) {
//                Text(String(format: "%.0f", downloads))
//                    .font(.title3)
//                    .fontWeight(.semibold)
//                
//                Text(month)
//                    .font(.title3)
//                    .textScale(.secondary)
//            }
//        }
//        .padding(isTitleView ? [.horizontal] : [.all] )
//        .background(Color("PopupColor").opacity(isTitleView ? 0 : 1), in: .rect(cornerRadius: 8))
//        .frame(maxWidth: .infinity, alignment: isTitleView ? .leading : .center)
//    }
//    
//    func findIssue(_ rangeValue: Double) {
//        /// Converting Download Model into Array of Tuples
//        var initalValue: Double = 0.0
//        let convertedArray = viewModel.issueCounts
//            .compactMap { issue -> (String, Range<Double>) in
//                let rangeEnd = initalValue + issue.count
//            let tuple = ("\(issue.weekStart)", initalValue..<rangeEnd)
//            /// Updating Initial Value for next Iteration
//            initalValue = rangeEnd
//            return tuple
//        }
//        
//        /// Now Finding the Value lies in the Range
//        if let issue = convertedArray.first(where: {
//            $0.1.contains(rangeValue)
//        }) {
//            /// Updating Selection
//            selectedPoint = issue.0
//        }
//    }
}

#Preview {
    RepositoryDetailsView(repository: Repository(id: 1, name: "Test Name", owner: Owner(id: 1, name: "Test Name"), description: "Test Description", stargazersCount: 2, forksCount: 3, url: ""))
}
