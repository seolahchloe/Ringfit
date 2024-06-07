import SwiftUI
import Charts
import HealthKit

extension WorkoutIntensity {
    func points(for duration: Double) -> Double {
        let points = (self.rawValue * duration) / 450.0 * 100
        return points
    }
}

struct CardioDonutChartView: View {
    @StateObject private var userViewModel = UserViewModel.shared
    @StateObject private var healthViewModel = HealthViewModel.shared
    @State private var cardioWorkouts: [CardioWorkout] = []
    @State private var chartData: [ChartDataPoint] = []
    @Binding var currentDate: Date
    @Binding var cardioAchievementPercentage: Double
    @State private var selectedSector: String?
    
    var remainingPercentage: Double {
        100 - cardioAchievementPercentage
    }
    

    var body: some View {
        VStack {
            Text("유산소")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            Chart {
                if !cardioWorkouts.isEmpty {
                    ForEach(cardioWorkouts, id: \.self) { cardio in
                        SectorMark(
                            angle: .value("Percentage", cardio.percentage),
                            innerRadius: .ratio(0.5),
                            angularInset: 1.5
                        )
                        .foregroundStyle(by: .value("Name", cardio.name))
//                        .foregroundStyle(cardio.color)
                        .opacity(cardio.name == nil ? 1.0 : (selectedSector == cardio.name ? 1.0 : 0.5))
                        
                        .annotation(position: .overlay) {
                            VStack(alignment: .center) {
//                                Text("\(cardio.name)")
//                                    .font(.headline)
                                Text("\(Int(round(cardio.percentage)))%")
                                    .font(.caption)
                            }
                        }
                    }
                    
                    // 나머지 퍼센티지를 투명색으로 채우기
                    SectorMark(
                        angle: .value("Remaining", remainingPercentage),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .foregroundStyle(Color.LightGray2)
                } else {
                    SectorMark(
                        angle: .value("Remaining", remainingPercentage),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .foregroundStyle(Color.LightGray2)
                }
            }
            .chartLegend(alignment: .center, spacing: 18)
            .frame(height: 230)
            .padding()
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotAreaFrame]
                    VStack {
                        Text("\(Int(self.cardioAchievementPercentage))%")
                                .font(.title)
                                .frame(width: frame.width,
                                       height: frame.height,
                                       alignment: .center)
                                .padding()
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color.LightGray1)
        )
        .padding()
        .onAppear {
            fetchCardioData(for: currentDate)
        }
        .onChange(of: currentDate) { newDate in
            fetchCardioData(for: newDate)
        }
    }
    
    private func fetchCardioData(for date: Date) {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        healthViewModel.fetchCardioWorkoutData(for: startOfWeek, endDate: endOfWeek) { workouts in
            DispatchQueue.main.async {
                let filteredWorkouts = workouts.filter { cardio in
                    cardio.date >= startOfWeek && cardio.date <= endOfWeek
                }
                
                // 동일한 운동 이름을 가진 기록들의 퍼센티지 합산
                let mergedWorkouts = Dictionary(grouping: filteredWorkouts, by: { $0.name })
                    .mapValues { workouts in
                        workouts.reduce(0.0) { $0 + $1.percentage }
                    }
                    .map { name, percentage in
                        let workout = filteredWorkouts.first(where: { $0.name == name })
                        return CardioWorkout(name: name, percentage: percentage, date: workout?.date ?? Date(), color: workout?.color ?? Color.randomWorkoutColor(), activityType: workout?.activityType ?? .other)
                    }
                
                self.cardioWorkouts = mergedWorkouts
                
                let totalDuration = self.cardioWorkouts.reduce(0.0) { $0 + $1.percentage }
                let age = UserViewModel.shared.calculateAge()
                let workoutPurpose = UserViewModel.shared.workoutPurpose
                let targetPoints = HealthViewModel.shared.calculateTargetActivityPoints(age: age, workoutPurpose: workoutPurpose)
                self.cardioAchievementPercentage = min(round(totalDuration / targetPoints * 100), 100.0)
                
                print("Filtered Cardio Workouts:")
                for cardio in self.cardioWorkouts {
                    print("Workout: \(cardio.name), Percentage: \(round(cardio.percentage))%, Date: \(cardio.date), Activity Type: \(cardio.activityType)")
                }
                print("Total Duration: \(totalDuration), Target Points: \(targetPoints), Achievement Percentage: \(self.cardioAchievementPercentage)%")
                
                // 데이터 가져오기 완료 후 차트 업데이트
                self.updateChart()
            }
        }
    }
    
    private func updateChart() {
        // 기존 차트 데이터 초기화
        chartData = []
        
        // 새로운 차트 데이터 추가
        for cardio in cardioWorkouts {
            let dataPoint = ChartDataPoint(
                value: round(cardio.percentage),
                label: cardio.name,
                legend: Legend(color: Color.randomWorkoutColor(), label: cardio.name)
            )
            chartData.append(dataPoint)
        }
    }
}

#Preview {
    HomeView(cardioAchievementPercentage: 50)
}
