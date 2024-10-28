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
    
    @State private var showSelectionBar = false
    @State private var offsetX = 0.0
    @State private var offsetY = 0.0
    
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
                    LineMark(
                        x: .value("Week", issueCount.weekStart),
                        y: .value("Issues", issueCount.count)
                    )
                    .foregroundStyle(.cyan)
                    .foregroundStyle(.pink.opacity(0.7))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 2))
                    .symbol {
                        Circle()
                            .fill(.cyan)
                            .frame(width: 12, height: 12)
                    }
                }
                .chartYAxisLabel("Number of Issues")
                .chartXAxisLabel("Weeks")
                .frame(height: 300)
                .padding()
                .chartYScale(domain: 0...(viewModel.issueCounts.map { Double($0.count) }.max() ?? 1) * yScale) // Scale Y-axis
                .chartXScale(domain: computeXDomain())
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .foregroundStyle(Color.orange.gradient)
                            .frame(width: 2, height: geometry.size.height * 0.95)
                            .opacity(showSelectionBar ? 1.0 : 0.0)
                            .offset(x: offsetX)
                        
                        if let selectedDataPoint {
                            Capsule()
                                .foregroundStyle(.orange.gradient)
                                .frame(width: 100, height: 50)
                                .overlay {
                                    VStack {
                                        Text(selectedDataPoint.formattedWeekStart)
                                            .font(.caption)
                                            .minimumScaleFactor(0.5)
                                        Text("\(selectedDataPoint.count) issues")
                                            .font(.caption)
                                            .minimumScaleFactor(0.5)
                                    }
                                    .foregroundStyle(.white.gradient)
                                    .padding(2)
                                }
                                .opacity(showSelectionBar ? 1.0 : 0.0)
                                .offset(x: offsetX - 50, y: offsetY - 60)
                        }
                        
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        showSelectionBar = true
                                        let location = value.location
                                        
                                        // Convert the location to an X-axis date
                                        if let date: Date = proxy.value(atX: location.x) {
                                            // Find the nearest data point by date
                                            if let nearestPoint = viewModel.issueCounts.min(by: { abs($0.weekStart.timeIntervalSince(date)) < abs($1.weekStart.timeIntervalSince(date)) }) {
                                                selectedDataPoint = nearestPoint
                                                
                                                if let position = proxy.position(for: (nearestPoint.weekStart, nearestPoint.count)),
                                                let plotFrame = proxy.plotFrame {
                                                    offsetX = geometry[plotFrame].origin.x + position.x
                                                    offsetY = geometry[plotFrame].origin.y + position.y
                                                }
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        showSelectionBar = false
                                    }
                            )
                    }
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            yScale = value.magnitude
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation.width
                        }
                        .onEnded { _ in
                            dateScale += offset / 1000 // Adjust factor as needed for smooth scaling
                            offset = 0
                        }
                )
                
                // Display selected data point information
                if let selectedDataPoint = selectedDataPoint {
                    Text("Selected Date: \(selectedDataPoint.weekStart, style: .date), Issues: \(selectedDataPoint.count)")
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(5)
                }
            }
        }
        .navigationTitle(repository.name)
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
    
    func findIssue(on date: Date) -> IssueCount? {
        // Set up the date formatter to ignore the time component
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Format the target date
        let formattedTargetDate = dateFormatter.string(from: date)
        
        // Search for an issue with a matching formatted date
        return viewModel.issueCounts.first { issue in
            let formattedWeekStart = dateFormatter.string(from: issue.weekStart)
            return formattedWeekStart == formattedTargetDate
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
