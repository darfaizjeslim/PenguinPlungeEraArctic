


import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
               GameView()
                    .environmentObject(gameManager)
            }
        }
    }
}

// Enhanced Splash Screen
struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var glow = false
    
    var body: some View {
        ZStack {
            // Aurora Borealis Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.02, green: 0.05, blue: 0.15),
                    Color(red: 0.1, green: 0.2, blue: 0.4),
                    Color(red: 0.15, green: 0.3, blue: 0.6)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Animated Northern Lights
            ForEach(0..<3) { i in
                RoundedRectangle(cornerRadius: 100)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.3),
                                Color.blue.opacity(0.2),
                                Color.purple.opacity(0.1)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 400, height: 40)
                    .rotationEffect(.degrees(Double(i) * 45))
                    .offset(y: isAnimating ? 150 : -150)
                    .blur(radius: 20)
                    .animation(
                        Animation.easeInOut(duration: 4)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.5),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 30) {
                // Animated Penguin Icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.blue.opacity(0.1)]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 90
                            )
                        )
                        .frame(width: 180, height: 180)
                        .scaleEffect(glow ? 1.1 : 0.9)
                    
                    Image("penguin_character")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .shadow(color: .blue.opacity(0.6), radius: glow ? 20 : 10)
                }
                
                Text("PENGUIN\nPLUNGE")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .blue.opacity(0.8), radius: 15, x: 0, y: 5)
                    .scaleEffect(isAnimating ? 1.05 : 0.95)
                
                Text("Arctic Adventure")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                    .italic()
                
                // Custom Progress Indicator
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
            glow = true
        }
    }
}

// Enhanced Game View
struct GameView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showPauseMenu = false
    @State private var showHowToPlay = false
    @State private var showHighScores = false
    
    var body: some View {
        ZStack {
            // Enhanced Arctic Background
            EnhancedArcticBackground()
            
            if gameManager.gameState == .playing {
                VStack(spacing: 0) {
                    // Enhanced Header with Level Info
                    HStack {
                        // Pause Button
                        GameButton(icon: "pause.fill", color: .blue, size: 50) {
                            showPauseMenu = true
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            // Level Display
                            HStack(spacing: 8) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                
                                Text("LEVEL \(gameManager.currentLevel)")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            // Enhanced Score Display
                            ScoreCard(score: gameManager.score)
                        }
                        
                        Spacer()
                        
                        // Restart Button
                        GameButton(icon: "arrow.clockwise", color: .orange, size: 50) {
                            gameManager.resetGame()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // Game Arena with Level-based Design
                    ZStack {
                        // Ice Floes with level-based arrangement
                        ForEach(gameManager.iceFloes) { floe in
                            EnhancedIceFloeView(floe: floe)
                        }
                        
                        // Cracks
                        ForEach(gameManager.cracks) { crack in
                            EnhancedCrackView(crack: crack)
                        }
                        
                        // Enemies
                        ForEach(gameManager.enemies) { enemy in
                            EnhancedEnemyView(enemy: enemy)
                        }
                        
                        // Penguin with shadow
                        EnhancedPenguinView()
                            .position(gameManager.penguinPosition)
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .frame(width: gameManager.arenaWidth, height: 500)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue.opacity(0.3),
                                        Color.blue.opacity(0.1)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            )
                    )
                    
                    Spacer()
                    
                    // Enhanced Controls
                    HStack(spacing: 30) {
                        GameControlButton(icon: "arrow.left", color: .purple) {
                            gameManager.movePenguin(direction: .left)
                        }
                        
                        GameControlButton(icon: "arrow.up", color: .green) {
                            gameManager.movePenguin(direction: .forward)
                        }
                        
                        GameControlButton(icon: "arrow.right", color: .purple) {
                            gameManager.movePenguin(direction: .right)
                        }
                    }
                    .padding(.bottom, 30)
                }
            } else if gameManager.gameState == .gameOver {
                EnhancedGameOverView()
            } else if gameManager.gameState == .menu {
                EnhancedMainMenuView(
                    showHowToPlay: $showHowToPlay,
                    showHighScores: $showHighScores
                )
            } else if gameManager.gameState == .levelComplete {
                LevelCompleteView()
            }
            
            // Enhanced Overlays
            if showPauseMenu {
                EnhancedPauseMenuView(showPauseMenu: $showPauseMenu)
            }
            
            if showHowToPlay {
                HowToPlayView(showHowToPlay: $showHowToPlay)
            }
            
            if showHighScores {
                HighScoresView(showHighScores: $showHighScores)
            }
            
            // Enhanced Toast
            if let toast = gameManager.activeToast {
                VStack {
                    Spacer()
                    EnhancedToastView(message: toast.message, type: toast.type)
                        .transition(.scale.combined(with: .opacity))
                        .padding(.bottom, 100)
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: gameManager.activeToast)
            }
        }
        .onAppear {
            gameManager.startGame()
        }
        
    }
}

// MARK: - Enhanced Game Manager with Level System
class GameManager: ObservableObject {
    @Published var gameState: GameState = .menu
    @Published var score = 0
    @Published var currentLevel = 1
    @Published var penguinPosition = CGPoint(x: 200, y: 450)
    @Published var iceFloes: [IceFloe] = []
    @Published var enemies: [Enemy] = []
    @Published var cracks: [Crack] = []
    @Published var activeToast: Toast?
    @Published var highScores: [Int] = [0, 0, 0, 0, 0]
    @Published var completedLevels: [Int: LevelCompletion] = [:]
    
    // Level configuration
    private var levelConfig: LevelConfiguration {
        LevelConfiguration.getConfig(for: currentLevel)
    }
    
    var arenaWidth: CGFloat {
        UIScreen.main.bounds.width - 40
    }
    
    private var timer: Timer?
    private var crackPatternTimer: Timer?
    private var enemySpawnTimer: Timer?
    
    init() {
        setupIceFloes()
        loadHighScores()
        loadCompletedLevels()
    }
    
    func startGame() {
        gameState = .playing
        score = 0
        setupIceFloes()
        penguinPosition = CGPoint(x: arenaWidth / 2, y: 450)
        
        // Start game timers with level-based intervals
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateGame()
        }
        
        crackPatternTimer = Timer.scheduledTimer(withTimeInterval: levelConfig.crackSpawnInterval, repeats: true) { _ in
            self.generateCrackPattern()
        }
        
        enemySpawnTimer = Timer.scheduledTimer(withTimeInterval: levelConfig.enemySpawnInterval, repeats: true) { _ in
            self.spawnEnemy()
        }
        
        showToast(message: "Level \(currentLevel) - \(levelConfig.name)", type: .info)
    }
    
    func resetGame() {
        stopTimers()
        iceFloes.removeAll()
        enemies.removeAll()
        cracks.removeAll()
        startGame()
        showToast(message: "Game Restarted!", type: .info)
    }
    
    // GameManager class mein yeh method add karein
    func returnToMainMenu() {
        stopTimers()
        gameState = .menu
        score = 0
        currentLevel = 1
        iceFloes.removeAll()
        enemies.removeAll()
        cracks.removeAll()
        activeToast = nil
    }
    
    func completeLevel() {
        stopTimers()
        
        // Calculate stars based on performance
        let stars = calculateStars()
        completedLevels[currentLevel] = LevelCompletion(level: currentLevel, stars: stars, score: score)
        saveCompletedLevels()
        
        gameState = .levelComplete
        showToast(message: "Level Complete! ★\(stars)", type: .success)
        
        // Auto-save high score
        addHighScore(score)
    }
    
    func nextLevel() {
        if currentLevel < 10 {
            currentLevel += 1
            resetGame()
        } else {
            // All levels completed
            gameState = .menu
            showToast(message: "All levels completed! 🎉", type: .success)
        }
    }
    
    func selectLevel(_ level: Int) {
        guard level >= 1 && level <= 10 else { return }
        currentLevel = level
        resetGame()
    }
    
    private func calculateStars() -> Int {
        let minScore = levelConfig.minScore
        let maxScore = levelConfig.maxScore
        let playerScore = score
        
        if playerScore >= maxScore {
            return 3
        } else if playerScore >= (minScore + maxScore) / 2 {
            return 2
        } else if playerScore >= minScore {
            return 1
        } else {
            return 0
        }
    }
    
    private func stopTimers() {
        timer?.invalidate()
        crackPatternTimer?.invalidate()
        enemySpawnTimer?.invalidate()
    }
    
    func pauseGame() {
        stopTimers()
    }
    
    func resumeGame() {
        startGame()
    }
    
    func gameOver() {
        gameState = .gameOver
        stopTimers()
        addHighScore(score)
        showToast(message: "Game Over! Final Score: \(score)", type: .error)
    }
    
    func movePenguin(direction: MoveDirection) {
        guard gameState == .playing else { return }
        
        var newPosition = penguinPosition
        let moveDistance = levelConfig.moveDistance
        
        switch direction {
        case .left:
            newPosition.x -= moveDistance
        case .right:
            newPosition.x += moveDistance
        case .forward:
            newPosition.y -= moveDistance
        }
        
        // Boundary check
        if newPosition.x >= 50 && newPosition.x <= arenaWidth - 50 {
            penguinPosition = newPosition
            score += levelConfig.movePoints
            
            // Check if penguin reached the top
            if newPosition.y <= 50 {
                completeLevel()
            }
        } else {
            showToast(message: "Can't move there!", type: .warning)
        }
        
        // Check for collisions
        checkCollisions()
    }
    
    private func setupIceFloes() {
        iceFloes.removeAll()
        let config = levelConfig
        
        for row in 0..<config.rows {
            for col in 0..<config.columns {
                let x = CGFloat(col) * config.floeWidth + 70
                let y = CGFloat(row) * config.floeHeight + 50
                
                iceFloes.append(IceFloe(
                    id: UUID(),
                    position: CGPoint(x: x, y: y),
                    size: CGSize(width: config.floeWidth - 10, height: config.floeHeight - 10),
                    isCracked: false
                ))
            }
        }
    }
    
    private func updateGame() {
        // Update enemies
        for i in 0..<enemies.count {
            enemies[i].position.y += enemies[i].speed
            
            // Remove enemies that are off screen
            if enemies[i].position.y > 550 {
                enemies.remove(at: i)
                break
            }
        }
        
        // Update cracks
        for i in 0..<cracks.count {
            cracks[i].progress += levelConfig.crackSpeed
            
            // Remove fully formed cracks
            if cracks[i].progress >= 1.0 {
                cracks.remove(at: i)
                break
            }
        }
        
        // Check collisions
        checkCollisions()
    }
    
    private func generateCrackPattern() {
        let config = levelConfig
        let crackCount = Int.random(in: 1...config.maxCracksPerSpawn)
        
        for _ in 0..<crackCount {
            let randomRow = Int.random(in: 0..<config.rows)
            let randomCol = Int.random(in: 0..<config.columns)
            
            let x = CGFloat(randomCol) * config.floeWidth + 70
            let y = CGFloat(randomRow) * config.floeHeight + 50
            
            cracks.append(Crack(
                id: UUID(),
                position: CGPoint(x: x, y: y),
                progress: 0.0
            ))
            
            // Mark the ice floe as cracked
            if let index = iceFloes.firstIndex(where: {
                abs($0.position.x - x) < 10 && abs($0.position.y - y) < 10
            }) {
                iceFloes[index].isCracked = true
            }
        }
    }
    
    private func spawnEnemy() {
        let config = levelConfig
        let enemyCount = Int.random(in: 1...config.maxEnemiesPerSpawn)
        
        for _ in 0..<enemyCount {
            let randomType: EnemyType = Bool.random() ? .orca : .seal
            let randomX = CGFloat.random(in: 70...(arenaWidth - 70))
            
            enemies.append(Enemy(
                id: UUID(),
                type: randomType,
                position: CGPoint(x: randomX, y: -50),
                speed: CGFloat.random(in: config.enemyMinSpeed...config.enemyMaxSpeed)
            ))
        }
    }
    
    private func checkCollisions() {
        // Check if penguin is on a cracked ice floe
        for crack in cracks {
            if abs(penguinPosition.x - crack.position.x) < 40 &&
               abs(penguinPosition.y - crack.position.y) < 40 &&
               crack.progress > 0.7 {
                gameOver()
                return
            }
        }
        
        // Check if penguin collides with an enemy
        for enemy in enemies {
            if abs(penguinPosition.x - enemy.position.x) < 30 &&
               abs(penguinPosition.y - enemy.position.y) < 30 {
                gameOver()
                return
            }
        }
    }
    
    private func showToast(message: String, type: ToastType) {
        activeToast = Toast(message: message, type: type)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.activeToast = nil
            }
        }
    }
    
    // High Scores functionality
    func addHighScore(_ score: Int) {
        highScores.append(score)
        highScores.sort(by: >)
        highScores = Array(highScores.prefix(5))
        UserDefaults.standard.set(highScores, forKey: "highScores")
    }
    
    func loadHighScores() {
        if let savedScores = UserDefaults.standard.array(forKey: "highScores") as? [Int] {
            highScores = savedScores
        }
    }
    
    func saveCompletedLevels() {
        if let data = try? JSONEncoder().encode(completedLevels) {
            UserDefaults.standard.set(data, forKey: "completedLevels")
        }
    }
    
    func loadCompletedLevels() {
        if let data = UserDefaults.standard.data(forKey: "completedLevels"),
           let levels = try? JSONDecoder().decode([Int: LevelCompletion].self, from: data) {
            completedLevels = levels
        }
    }
}

// MARK: - Level System
struct LevelConfiguration {
    let level: Int
    let name: String
    let rows: Int
    let columns: Int
    let floeWidth: CGFloat
    let floeHeight: CGFloat
    let crackSpawnInterval: Double
    let enemySpawnInterval: Double
    let crackSpeed: CGFloat
    let enemyMinSpeed: CGFloat
    let enemyMaxSpeed: CGFloat
    let maxCracksPerSpawn: Int
    let maxEnemiesPerSpawn: Int
    let moveDistance: CGFloat
    let movePoints: Int
    let minScore: Int
    let maxScore: Int
    
    static func getConfig(for level: Int) -> LevelConfiguration {
        switch level {
        case 1:
            return LevelConfiguration(
                level: 1, name: "Arctic Training", rows: 4, columns: 3,
                floeWidth: 100, floeHeight: 80, crackSpawnInterval: 4.0, enemySpawnInterval: 5.0,
                crackSpeed: 0.03, enemyMinSpeed: 2.0, enemyMaxSpeed: 3.0,
                maxCracksPerSpawn: 1, maxEnemiesPerSpawn: 1,
                moveDistance: 80, movePoints: 10, minScore: 200, maxScore: 400
            )
        case 2:
            return LevelConfiguration(
                level: 2, name: "Frozen Waters", rows: 5, columns: 3,
                floeWidth: 90, floeHeight: 70, crackSpawnInterval: 3.5, enemySpawnInterval: 4.0,
                crackSpeed: 0.04, enemyMinSpeed: 2.5, enemyMaxSpeed: 3.5,
                maxCracksPerSpawn: 1, maxEnemiesPerSpawn: 1,
                moveDistance: 70, movePoints: 12, minScore: 300, maxScore: 500
            )
        case 3:
            return LevelConfiguration(
                level: 3, name: "Ice Challenge", rows: 5, columns: 4,
                floeWidth: 80, floeHeight: 65, crackSpawnInterval: 3.0, enemySpawnInterval: 3.5,
                crackSpeed: 0.05, enemyMinSpeed: 3.0, enemyMaxSpeed: 4.0,
                maxCracksPerSpawn: 2, maxEnemiesPerSpawn: 1,
                moveDistance: 65, movePoints: 15, minScore: 400, maxScore: 600
            )
        case 4:
            return LevelConfiguration(
                level: 4, name: "Blizzard Zone", rows: 6, columns: 4,
                floeWidth: 75, floeHeight: 60, crackSpawnInterval: 2.5, enemySpawnInterval: 3.0,
                crackSpeed: 0.06, enemyMinSpeed: 3.5, enemyMaxSpeed: 4.5,
                maxCracksPerSpawn: 2, maxEnemiesPerSpawn: 2,
                moveDistance: 60, movePoints: 18, minScore: 500, maxScore: 700
            )
        case 5:
            return LevelConfiguration(
                level: 5, name: "Polar Night", rows: 6, columns: 5,
                floeWidth: 70, floeHeight: 55, crackSpawnInterval: 2.0, enemySpawnInterval: 2.5,
                crackSpeed: 0.07, enemyMinSpeed: 4.0, enemyMaxSpeed: 5.0,
                maxCracksPerSpawn: 2, maxEnemiesPerSpawn: 2,
                moveDistance: 55, movePoints: 20, minScore: 600, maxScore: 800
            )
        case 6:
            return LevelConfiguration(
                level: 6, name: "Frostbite", rows: 7, columns: 5,
                floeWidth: 65, floeHeight: 50, crackSpawnInterval: 1.8, enemySpawnInterval: 2.0,
                crackSpeed: 0.08, enemyMinSpeed: 4.5, enemyMaxSpeed: 5.5,
                maxCracksPerSpawn: 3, maxEnemiesPerSpawn: 2,
                moveDistance: 50, movePoints: 22, minScore: 700, maxScore: 900
            )
        case 7:
            return LevelConfiguration(
                level: 7, name: "Arctic Storm", rows: 7, columns: 6,
                floeWidth: 60, floeHeight: 48, crackSpawnInterval: 1.6, enemySpawnInterval: 1.8,
                crackSpeed: 0.09, enemyMinSpeed: 5.0, enemyMaxSpeed: 6.0,
                maxCracksPerSpawn: 3, maxEnemiesPerSpawn: 3,
                moveDistance: 48, movePoints: 25, minScore: 800, maxScore: 1000
            )
        case 8:
            return LevelConfiguration(
                level: 8, name: "Iceberg Alley", rows: 8, columns: 6,
                floeWidth: 58, floeHeight: 45, crackSpawnInterval: 1.4, enemySpawnInterval: 1.6,
                crackSpeed: 0.10, enemyMinSpeed: 5.5, enemyMaxSpeed: 6.5,
                maxCracksPerSpawn: 3, maxEnemiesPerSpawn: 3,
                moveDistance: 45, movePoints: 28, minScore: 900, maxScore: 1100
            )
        case 9:
            return LevelConfiguration(
                level: 9, name: "Glacial Peak", rows: 8, columns: 7,
                floeWidth: 55, floeHeight: 42, crackSpawnInterval: 1.2, enemySpawnInterval: 1.4,
                crackSpeed: 0.12, enemyMinSpeed: 6.0, enemyMaxSpeed: 7.0,
                maxCracksPerSpawn: 4, maxEnemiesPerSpawn: 3,
                moveDistance: 42, movePoints: 30, minScore: 1000, maxScore: 1200
            )
        case 10:
            return LevelConfiguration(
                level: 10, name: "Final Frontier", rows: 9, columns: 7,
                floeWidth: 52, floeHeight: 40, crackSpawnInterval: 1.0, enemySpawnInterval: 1.2,
                crackSpeed: 0.15, enemyMinSpeed: 6.5, enemyMaxSpeed: 7.5,
                maxCracksPerSpawn: 4, maxEnemiesPerSpawn: 4,
                moveDistance: 40, movePoints: 35, minScore: 1200, maxScore: 1500
            )
        default:
            return getConfig(for: 1)
        }
    }
}

struct LevelCompletion: Codable {
    let level: Int
    let stars: Int
    let score: Int
}

// MARK: - Game State and Models
enum GameState {
    case menu, playing, gameOver, paused, levelComplete
}

enum MoveDirection {
    case left, right, forward
}

struct IceFloe: Identifiable {
    let id: UUID
    var position: CGPoint
    var size: CGSize
    var isCracked: Bool
}

struct Enemy: Identifiable {
    let id: UUID
    let type: EnemyType
    var position: CGPoint
    let speed: CGFloat
}

enum EnemyType {
    case orca, seal
}

struct Crack: Identifiable {
    let id: UUID
    var position: CGPoint
    var progress: CGFloat
}

struct Toast: Equatable {
    let message: String
    let type: ToastType
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        return lhs.message == rhs.message && lhs.type == rhs.type
    }
}

enum ToastType: Equatable {
    case success, error, warning, info
}

// MARK: - Enhanced UI Components
struct GameButton: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
                    .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 4)
                
                Image(systemName: icon)
                    .font(.system(size: size * 0.4, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .pressEvents {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = false
            }
        }
    }
}

struct GameControlButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 70, height: 70)
                    .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Image(systemName: icon)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .pressEvents {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = false
            }
        }
    }
}

struct ScoreCard: View {
    let score: Int
    @State private var pulse = false
    
    var body: some View {
        VStack(spacing: 4) {
            Text("SCORE")
                .font(.caption)
                .fontWeight(.black)
                .foregroundColor(.white.opacity(0.8))
                .tracking(1)
            
            Text("\(score)")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 0)
                .scaleEffect(pulse ? 1.1 : 1.0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
        )
        .onChange(of: score) { oldValue, newValue in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                pulse = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    pulse = false
                }
            }
        }
    }
}

// MARK: - Enhanced Background
struct EnhancedArcticBackground: View {
    @State private var snowflakes: [Snowflake] = []
    @State private var auroraOpacity: Double = 0.3
    
    init() {
        var flakes: [Snowflake] = []
        for _ in 0..<60 {
            flakes.append(Snowflake())
        }
        _snowflakes = State(initialValue: flakes)
    }
    
    var body: some View {
        ZStack {
            // Deep Sky Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.1, blue: 0.25),
                    Color(red: 0.15, green: 0.3, blue: 0.6),
                    Color(red: 0.3, green: 0.6, blue: 0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Animated Aurora
            ForEach(0..<3) { i in
                RoundedRectangle(cornerRadius: 200)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(auroraOpacity),
                                Color.blue.opacity(auroraOpacity * 0.7),
                                Color.purple.opacity(auroraOpacity * 0.5)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 400, height: 60)
                    .rotationEffect(.degrees(Double(i) * 60))
                    .offset(y: -150)
                    .blur(radius: 25)
                    .opacity(auroraOpacity)
            }
            
            // Snowflakes
            ForEach(snowflakes) { snowflake in
                Circle()
                    .fill(Color.white.opacity(snowflake.opacity))
                    .frame(width: snowflake.size, height: snowflake.size)
                    .position(
                        x: snowflake.x,
                        y: snowflake.y
                    )
                    .onAppear {
                        withAnimation(
                            Animation.linear(duration: snowflake.duration)
                                .repeatForever(autoreverses: false)
                        ) {
                            snowflake.y = UIScreen.main.bounds.height + 50
                        }
                    }
            }
            
            // Icebergs in background
            ForEach(0..<3) { i in
                EnhancedIcebergView()
                    .offset(
                        x: CGFloat(i) * 140 - 210,
                        y: 300
                    )
                    .opacity(0.6 - Double(i) * 0.2)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                auroraOpacity = 0.6
            }
        }
    }
}

// MARK: - Enhanced Game Elements
struct EnhancedIceFloeView: View {
    let floe: IceFloe
    @State private var glow = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    floe.isCracked ?
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.7), Color.black.opacity(0.5)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.white.opacity(0.9)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: floe.size.width, height: floe.size.height)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            floe.isCracked ? Color.red.opacity(0.8) : Color.white.opacity(0.9),
                            lineWidth: floe.isCracked ? 4 : 2
                        )
                )
                .shadow(
                    color: floe.isCracked ? .red.opacity(0.4) : .blue.opacity(0.3),
                    radius: floe.isCracked ? 6 : 3
                )
                .scaleEffect(glow ? 1.05 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: glow
                )
        }
        .position(floe.position)
        .onAppear {
            if floe.isCracked {
                glow = true
            }
        }
    }
}

struct EnhancedPenguinView: View {
    @State private var isWaddling = false
    @State private var isBlinking = false
    
    var body: some View {
        ZStack {
            // Shadow
            Ellipse()
                .fill(Color.black.opacity(0.3))
                .frame(width: 30, height: 10)
                .offset(y: 20)
                .scaleEffect(isWaddling ? 1.1 : 0.9)
            
            // Penguin using asset image
            Image("penguin_character")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .offset(y: isWaddling ? -2 : 2)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
                isWaddling.toggle()
            }
        }
    }
}



struct LevelButton: View {
    @EnvironmentObject var gameManager: GameManager
    let level: Int
    @State private var isPressed = false
    
    private var completion: LevelCompletion? {
        gameManager.completedLevels[level]
    }
    
    private var isUnlocked: Bool {
        level == 1 || gameManager.completedLevels[level - 1] != nil
    }
    
    var body: some View {
        Button(action: {
            if isUnlocked {
                gameManager.selectLevel(level)
            }
        }) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.blue : Color.gray.opacity(0.5))
                    .frame(width: 55, height: 55)
                    .shadow(color: isUnlocked ? .blue.opacity(0.5) : .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                
                if let completion = completion {
                    // Completed level with stars
                    VStack(spacing: 2) {
                        Text("\(level)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 2) {
                            ForEach(1...3, id: \.self) { star in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(star <= completion.stars ? .yellow : .gray)
                            }
                        }
                    }
                } else if isUnlocked {
                    // Unlocked but not completed
                    Text("\(level)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    // Locked level
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .opacity(isUnlocked ? 1.0 : 0.6)
        }
        .disabled(!isUnlocked)
        .pressEvents {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = false
            }
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(color)
                    .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                    .scaleEffect(isPressed ? 0.98 : 1.0)
            )
        }
        .pressEvents {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = false
            }
        }
    }
}

// MARK: - Level Complete View
struct LevelCompleteView: View {
    @EnvironmentObject var gameManager: GameManager
    
    private var completion: LevelCompletion? {
        gameManager.completedLevels[gameManager.currentLevel]
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("LEVEL COMPLETE!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.5), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 15) {
                    Text("Level \(gameManager.currentLevel)")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                    
                    if let completion = completion {
                        HStack(spacing: 10) {
                            ForEach(1...3, id: \.self) { star in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(star <= completion.stars ? .yellow : .gray.opacity(0.3))
                                    .scaleEffect(star <= completion.stars ? 1.2 : 0.8)
                            }
                        }
                        
                        Text("\(completion.score) Points")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                
                VStack(spacing: 12) {
                    if gameManager.currentLevel < 10 {
                        MenuButton(
                            title: "NEXT LEVEL",
                            icon: "arrow.right",
                            color: .green,
                            action: { gameManager.nextLevel() }
                        )
                    }
                    
                    MenuButton(
                        title: "PLAY AGAIN",
                        icon: "arrow.clockwise",
                        color: .blue,
                        action: { gameManager.resetGame() }
                    )
                    
                    MenuButton(
                        title: "MAIN MENU",
                        icon: "house",
                        color: .orange,
                        action: {
                            gameManager.returnToMainMenu() // Naya method use karein
                            gameManager.gameState = .menu }
                    )
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

// MARK: - Additional Views (HowToPlay, HighScores, PauseMenu, etc.)
struct HowToPlayView: View {
    @Binding var showHowToPlay: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("Learn to Play")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        InstructionRow(icon: "arrow.left", text: "Tap left arrow to move left", color: .purple)
                        InstructionRow(icon: "arrow.up", text: "Tap up arrow to move forward", color: .green)
                        InstructionRow(icon: "arrow.right", text: "Tap right arrow to move right", color: .purple)
                        InstructionRow(icon: "xmark.circle", text: "Avoid cracked ice floes", color: .red)
                        InstructionRow(icon: "eye", text: "Watch out for enemies", color: .orange)
                        InstructionRow(icon: "flag", text: "Reach the top to complete level", color: .blue)
                        InstructionRow(icon: "star", text: "Earn stars based on your score", color: .yellow)
                        InstructionRow(icon: "lock.open", text: "Complete levels to unlock next ones", color: .green)
                    }
                    .padding(.horizontal, 20)
                }
                
                GameButton(icon: "xmark", color: .red, size: 50) {
                    showHowToPlay = false
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 20)
            )
            .padding(40)
        }
    }
}

struct HighScoresView: View {
    @EnvironmentObject var gameManager: GameManager
    @Binding var showHighScores: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("HIGHEST")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    ForEach(0..<gameManager.highScores.count, id: \.self) { index in
                        HStack {
                            Text("\(index + 1).")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 40)
                            
                            Text("\(gameManager.highScores[index])")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if index == 0 && gameManager.highScores[index] > 0 {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.3))
                        )
                    }
                }
                
                GameButton(icon: "xmark", color: .red, size: 50) {
                    showHighScores = false
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 20)
            )
            .padding(40)
            .onAppear {
                gameManager.loadHighScores()
            }
        }
    }
}

struct EnhancedPauseMenuView: View {
    @EnvironmentObject var gameManager: GameManager
    @Binding var showPauseMenu: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("GAME PAUSED")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                ScoreCard(score: gameManager.score)
                    .scaleEffect(1.1)
                
                VStack(spacing: 15) {
                    MenuButton(
                        title: "RESUME GAME",
                        icon: "play",
                        color: .green,
                        action: {
                            showPauseMenu = false
                            gameManager.resumeGame()
                        }
                    )
                    
                    MenuButton(
                        title: "RESTART LEVEL",
                        icon: "arrow.clockwise",
                        color: .orange,
                        action: {
                            gameManager.resetGame()
                            showPauseMenu = false
                        }
                    )
                    
                    MenuButton(
                        title: "MAIN MENU",
                        icon: "house",
                        color: .blue,
                        action: {
                            gameManager.gameState = .menu
                            showPauseMenu = false
                        }
                    )
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

struct InstructionRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

// MARK: - Enhanced Toast
struct EnhancedToastView: View {
    let message: String
    let type: ToastType
    
    var backgroundColor: Color {
        switch type {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
    
    var icon: String {
        switch type {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            
            Text(message)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .shadow(color: backgroundColor.opacity(0.5), radius: 10, x: 0, y: 5)
        )
    }
}

// MARK: - Enhanced Enemy View
struct EnhancedEnemyView: View {
    let enemy: Enemy
    @State private var isMoving = false
    
    var body: some View {
        ZStack {
            if enemy.type == .orca {
                // Orca using asset image
                Image("orca_enemy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 35)
            } else {
                // Seal using asset image
                Image("seal_enemy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45, height: 30)
            }
        }
        .position(enemy.position)
        .scaleEffect(isMoving ? 1.05 : 0.95)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isMoving.toggle()
            }
        }
    }
}

// MARK: - Enhanced Crack View
struct EnhancedCrackView: View {
    let crack: Crack
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Path { path in
                    let offset = CGFloat(i) * 3
                    path.move(to: CGPoint(x: -20 + offset, y: -8))
                    path.addLine(to: CGPoint(x: -4 + offset, y: 4))
                    path.addLine(to: CGPoint(x: 12 + offset, y: -6))
                    path.addLine(to: CGPoint(x: 20 + offset, y: 10))
                }
                .stroke(
                    Color.red,
                    style: StrokeStyle(
                        lineWidth: 2 * crack.progress,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .opacity(pulse ? 0.7 : 1.0)
            }
        }
        .position(crack.position)
        .scaleEffect(crack.progress)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                pulse.toggle()
            }
        }
    }
}

// MARK: - Enhanced Game Over View
struct EnhancedGameOverView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("GAME OVER")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundColor(.red)
                    .shadow(color: .red.opacity(0.5), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 10) {
                    Text("Final Score")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(gameManager.score)")
                        .font(.system(size: 50, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                
                VStack(spacing: 12) {
                    MenuButton(
                        title: "PLAY AGAIN",
                        icon: "arrow.clockwise",
                        color: .green,
                        action: { gameManager.resetGame() }
                    )
                    
                    MenuButton(
                        title: "MAIN MENU",
                        icon: "house",
                        color: .blue,
                        action: {
                            gameManager.returnToMainMenu() // Naya method use karein
                            gameManager.gameState = .menu }
                    )
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

// MARK: - Iceberg View
struct EnhancedIcebergView: View {
    @State private var float = false
    
    var body: some View {
        ZStack {
            // Main iceberg
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 80)
                .offset(y: float ? -2 : 2)
            
            // Snow cap
            Circle()
                .fill(Color.white)
                .frame(width: 60, height: 50)
                .offset(x: -20, y: -15)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                float.toggle()
            }
        }
    }
}

// MARK: - Missing Components
class Snowflake: Identifiable, ObservableObject {
    let id = UUID()
    let size = CGFloat.random(in: 2...5)
    let x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
    @Published var y = CGFloat.random(in: -100...0)
    let duration = Double.random(in: 8...15)
    let opacity = Double.random(in: 0.3...0.8)
}

// MARK: - Button Press Extension
extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressEventModifier(onPress: onPress, onRelease: onRelease))
    }
}

struct PressEventModifier: ViewModifier {
    let onPress: () -> Void
    let onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in onRelease() }
            )
    }
}




// MARK: - Update your EnhancedMainMenuView to use the fixed version
struct EnhancedMainMenuView: View {
    @EnvironmentObject var gameManager: GameManager
    @Binding var showHowToPlay: Bool
    @Binding var showHighScores: Bool
    @State private var showPenguinCatch = false
    
    var body: some View {
        ZStack {
            // Frosted glass effect
            Rectangle()
                .fill(Color.black.opacity(0.7))
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Title
                    VStack(spacing: 8) {
                        Text("PENGUIN")
                            .font(.system(size: 44, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("PLUNGE")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.blue)
                            .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        Text("Arctic Survival Adventure")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .italic()
                    }
                    
                    // Level Selection Grid
                    VStack(alignment: .leading, spacing: 15) {
                        Text("SELECT LEVEL")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 15) {
                            ForEach(1...10, id: \.self) { level in
                                LevelButton(level: level)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Menu Buttons
                    VStack(spacing: 15) {
                        MenuButton(
                            title: "START GAME",
                            icon: "play.fill",
                            color: .blue,
                            action: {
                                gameManager.returnToMainMenu() // Pehle reset phir start
                                gameManager.startGame() }
                        )
                        
                        MenuButton(
                            title: "PENGUIN CATCH",
                            icon: "figure.fishing",
                            color: .purple,
                            action: { showPenguinCatch = true }
                        )
                        
                        MenuButton(
                            title: "Learn to Play",
                            icon: "questionmark.circle",
                            color: .green,
                            action: { showHowToPlay = true }
                        )
                        
                        MenuButton(
                            title: "HIGHEST",
                            icon: "trophy",
                            color: .orange,
                            action: { showHighScores = true }
                        )
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.vertical, 40)
            }
        }
        .onAppear {
            // Jab main menu show ho tab game ko reset karein
            gameManager.returnToMainMenu()
        }
        .fullScreenCover(isPresented: $showPenguinCatch) {
           PenguinCatchView()
        }
    }
}


import SwiftUI
import AVFoundation



struct PenguinCatchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var gameManager = PenguinCatchGameManager()
    @State private var selectedTime: TimeOption = .thirtySeconds
    
    var body: some View {
        ZStack {
            // Ocean Background
            OceanBackgroundView()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    GameButton(icon: "xmark", color: .red, size: 50) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("TIME")
                            .font(.caption)
                            .fontWeight(.black)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(gameManager.formattedTime)
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .monospacedDigit()
                    }
                    
                    Spacer()
                    
                    ScoreCard(score: gameManager.score)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                Spacer()
                
                if gameManager.gameState == .playing {
                    // Game Area - FIXED: Proper layout with boat at bottom
                    GeometryReader { geometry in
                        ZStack {
                            // Penguins first (behind boat)
                            ForEach(gameManager.penguins) { penguin in
                                DraggablePenguinView(
                                    penguin: penguin,
                                    gameArea: geometry.size,
                                    onDrop: { position in
                                        gameManager.checkPenguinInBoat(
                                            penguin: penguin,
                                            dropPosition: position,
                                            gameSize: geometry.size
                                        )
                                    }
                                )
                            }
                            
                            // Boat positioned at bottom center
                            VStack {
                                Spacer()
                                BoatView()
                                    .frame(width: 150, height: 100)
                                    .padding(.bottom, 20) // Small padding from bottom
                            }
                            
                            // Score popups on top
                            ForEach(gameManager.scorePopups) { popup in
                                ScorePopupView(popup: popup)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else if gameManager.gameState == .menu {
                    // Start Menu (unchanged)
                    VStack(spacing: 30) {
                        Text("PENGUIN CATCH")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        VStack(spacing: 20) {
                            Text("Select Time")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 20) {
                                ForEach(TimeOption.allCases, id: \.self) { option in
                                    TimeOptionButton(
                                        option: option,
                                        isSelected: selectedTime == option
                                    ) {
                                        selectedTime = option
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 15) {
                            MenuButton(
                                title: "START GAME",
                                icon: "play.fill",
                                color: .green,
                                action: {
                                    gameManager.startGame(timeLimit: selectedTime.duration)
                                }
                            )
                            
                            MenuButton(
                                title: "BACK TO MENU",
                                icon: "arrow.left",
                                color: .blue,
                                action: {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            )
                        }
                        .padding(.horizontal, 40)
                    }
                } else if gameManager.gameState == .gameOver {
                    // Results Screen (unchanged)
                    GameResultsView(gameManager: gameManager) {
                        gameManager.gameState = .menu
                    } onPlayAgain: {
                        gameManager.startGame(timeLimit: selectedTime.duration)
                    }
                }
                
                Spacer()
                
                // Instructions
                if gameManager.gameState == .playing {
                    VStack(spacing: 8) {
                        Text("Drag penguins to the boat!")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Drop them in the boat at the bottom")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            gameManager.setupGame()
        }
    }
}

// FIXED Game Manager
class PenguinCatchGameManager: ObservableObject {
    @Published var gameState: PenguinCatchGameState = .menu
    @Published var score = 0
    @Published var penguins: [DraggablePenguin] = []
    @Published var scorePopups: [ScorePopup] = []
    @Published var timeRemaining: TimeInterval = 0
    
    private var timer: Timer?
    private let penguinTypes = ["penguin_1", "penguin_2", "penguin_3", "penguin_4", "penguin_5", "penguin_6"]
    
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setupGame() {
        gameState = .menu
        score = 0
        penguins.removeAll()
        scorePopups.removeAll()
    }
    
    func startGame(timeLimit: TimeInterval) {
        gameState = .playing
        score = 0
        timeRemaining = timeLimit
        penguins.removeAll()
        scorePopups.removeAll()
        
        spawnPenguins(count: 8)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateGame()
        }
    }
    
    private func updateGame() {
        timeRemaining -= 1
        
        if timeRemaining <= 0 {
            endGame()
            return
        }
        
        // Remove expired score popups
        scorePopups.removeAll { $0.isExpired }
        
        // Spawn new penguins occasionally
        if penguins.count < 12 && Int.random(in: 0...100) < 20 {
            spawnPenguins(count: 1)
        }
        
        // Update penguin floating animations
        for index in penguins.indices {
            penguins[index].updatePosition()
        }
    }
    
    private func spawnPenguins(count: Int) {
        for _ in 0..<count {
            let penguinType = penguinTypes.randomElement() ?? "penguin_1"
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            // Spawn penguins in the upper part of the screen (above boat area)
            let startX = CGFloat.random(in: 50...(screenWidth - 50))
            let startY = CGFloat.random(in: 100...(screenHeight - 300)) // Leave space for boat
            
            let penguin = DraggablePenguin(
                id: UUID(),
                type: penguinType,
                position: CGPoint(x: startX, y: startY),
                initialPosition: CGPoint(x: startX, y: startY)
            )
            
            penguins.append(penguin)
        }
    }

    // FIXED: Improved collision detection
    func checkPenguinInBoat(penguin: DraggablePenguin, dropPosition: CGPoint, gameSize: CGSize) {
        let screenHeight = gameSize.height
        let boatCenterY = screenHeight - 70 // Boat positioned near bottom
        
        // Boat area detection - generous hit area around the bottom center
        let boatRect = CGRect(
            x: (gameSize.width / 2) - 100, // Wider hit area
            y: boatCenterY - 50,           // Higher hit area
            width: 200,                    // Wider detection
            height: 120                    // Taller detection
        )
        
        // Penguin drop area
        let penguinRect = CGRect(
            x: dropPosition.x - 25,  // Smaller penguin size
            y: dropPosition.y - 25,
            width: 50,
            height: 50
        )
        
        // Check if penguin was dropped in boat area
        if boatRect.intersects(penguinRect) {
            DispatchQueue.main.async {
                self.score += 10
                
                let popup = ScorePopup(
                    id: UUID(),
                    position: dropPosition,
                    score: 10,
                    creationDate: Date()
                )
                self.scorePopups.append(popup)
                
                // Remove the caught penguin
                if let index = self.penguins.firstIndex(where: { $0.id == penguin.id }) {
                    self.penguins.remove(at: index)
                }
                
                self.playSuccessSound()
            }
        } else {
            // Penguin missed - return to original position with animation
            DispatchQueue.main.async {
                self.playMissSound()
            }
        }
    }
    
    private func playSuccessSound() {
        AudioServicesPlaySystemSound(1026)
    }
    
    private func playMissSound() {
        AudioServicesPlaySystemSound(1053)
    }
    
    private func endGame() {
        timer?.invalidate()
        timer = nil
        gameState = .gameOver
    }
    
    func resetGame() {
        timer?.invalidate()
        timer = nil
        setupGame()
    }
}

// FIXED DraggablePenguinView with improved drag handling
struct DraggablePenguinView: View {
    let penguin: DraggablePenguin
    let gameArea: CGSize
    let onDrop: (CGPoint) -> Void
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @State private var currentPosition: CGPoint
    
    init(penguin: DraggablePenguin, gameArea: CGSize, onDrop: @escaping (CGPoint) -> Void) {
        self.penguin = penguin
        self.gameArea = gameArea
        self.onDrop = onDrop
        self._currentPosition = State(initialValue: penguin.position)
    }
    
    var body: some View {
        Image(penguin.type)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .position(currentPosition)
            .offset(offset)
            .scaleEffect(isDragging ? 1.2 : 1.0)
            .shadow(color: .black.opacity(isDragging ? 0.5 : 0.2), radius: isDragging ? 10 : 5)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation
                    }
                    .onEnded { value in
                        let dropPosition = CGPoint(
                            x: currentPosition.x + value.translation.width,
                            y: currentPosition.y + value.translation.height
                        )
                        
                        // Call the drop handler with final position
                        onDrop(dropPosition)
                        
                        // Reset position with animation
                        withAnimation(.spring()) {
                            offset = .zero
                            isDragging = false
                        }
                    }
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
            .onChange(of: penguin.position) { oldValue ,newPosition in
                // Update position when penguin moves (for floating animation)
                if !isDragging {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentPosition = newPosition
                    }
                }
            }
    }
}



// MARK: - Game Models
enum PenguinCatchGameState {
    case menu, playing, gameOver
}

struct DraggablePenguin: Identifiable {
    let id: UUID
    let type: String
    var position: CGPoint
    let initialPosition: CGPoint
    var floatOffset: CGFloat = 0
    var floatDirection: CGFloat = 1
    
    mutating func updatePosition() {
        // Gentle floating animation
        floatOffset += 0.1 * floatDirection
        if abs(floatOffset) > 3 {
            floatDirection *= -1
        }
        
        // Slight horizontal drift
        position.x += CGFloat.random(in: -0.5...0.5)
        position.y = initialPosition.y + floatOffset
        
        // Keep within bounds
        position.x = max(50, min(position.x, UIScreen.main.bounds.width - 50))
    }
}

struct ScorePopup: Identifiable {
    let id: UUID
    var position: CGPoint
    let score: Int
    let creationDate: Date
    
    var isExpired: Bool {
        Date().timeIntervalSince(creationDate) > 2.0
    }
    
    var opacity: Double {
        let elapsed = Date().timeIntervalSince(creationDate)
        return 1.0 - (elapsed / 2.0)
    }
    
    var offset: CGFloat {
        let elapsed = Date().timeIntervalSince(creationDate)
        return -elapsed * 50
    }
}

enum TimeOption: CaseIterable {
    case thirtySeconds, oneMinute
    
    var duration: TimeInterval {
        switch self {
        case .thirtySeconds: return 30
        case .oneMinute: return 60
        }
    }
    
    var displayName: String {
        switch self {
        case .thirtySeconds: return "30s"
        case .oneMinute: return "1m"
        }
    }
}

// MARK: - UI Components
struct OceanBackgroundView: View {
    @State private var waveOffset = 0.0
    
    var body: some View {
        ZStack {
            // Sky Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.3, green: 0.5, blue: 0.9),
                    Color(red: 0.4, green: 0.6, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Sun
            Circle()
                .fill(Color.yellow)
                .frame(width: 80, height: 80)
                .offset(x: -UIScreen.main.bounds.width / 3, y: -UIScreen.main.bounds.height / 4)
                .blur(radius: 10)
            
            // Waves
            ForEach(0..<3) { i in
                WaveView(offset: waveOffset + Double(i) * 0.3)
                    .fill(Color.blue.opacity(0.3 - Double(i) * 0.1))
                    .frame(height: 100)
                    .offset(y: UIScreen.main.bounds.height / 2 + CGFloat(i) * 30)
            }
            
            // Ocean
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.8),
                            Color(red: 0.1, green: 0.3, blue: 0.8)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: UIScreen.main.bounds.height / 2)
                .offset(y: UIScreen.main.bounds.height / 4)
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                waveOffset = .pi * 2
            }
        }
    }
}

struct WaveView: Shape {
    var offset: Double
    
    var animatableData: Double {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let waveHeight = 20.0
        let wavelength = rect.width / 2
        
        path.move(to: CGPoint(x: 0, y: rect.midY))
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / wavelength
            let sine = sin(relativeX + offset)
            let y = rect.midY + sine * waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct BoatView: View {
    @State private var bounce = false
    
    var body: some View {
        Image("boat")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 100)
            .offset(y: bounce ? -2 : 2)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    bounce.toggle()
                }
            }
    }
}



struct ScorePopupView: View {
    let popup: ScorePopup
    
    var body: some View {
        Text("+\(popup.score)")
            .font(.system(size: 20, weight: .black, design: .rounded))
            .foregroundColor(.green)
            .shadow(color: .black, radius: 2)
            .position(
                x: popup.position.x,
                y: popup.position.y + popup.offset
            )
            .opacity(popup.opacity)
            .scaleEffect(1.0 + (1.0 - popup.opacity) * 0.5)
    }
}

struct TimeOptionButton: View {
    let option: TimeOption
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(option.displayName)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? Color.green : Color.blue.opacity(0.6))
                        .shadow(color: isSelected ? .green.opacity(0.5) : .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
        }
        .pressEvents {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = false
            }
        }
    }
}


struct GameResultsView: View {
    @ObservedObject var gameManager: PenguinCatchGameManager
    let onBackToMenu: () -> Void
    let onPlayAgain: () -> Void
    
    private var totalPenguins: Int {
        gameManager.score / 10
    }
    
    private var performanceMessage: String {
        switch totalPenguins {
        case 0...5:
            return "Keep practicing!"
        case 6...12:
            return "Good job!"
        case 13...20:
            return "Excellent work!"
        case 21...30:
            return "Penguin Master!"
        default:
            return "Legendary!"
        }
    }
    
    private var performanceColor: Color {
        switch totalPenguins {
        case 0...5:
            return .orange
        case 6...12:
            return .green
        case 13...20:
            return .blue
        case 21...30:
            return .purple
        default:
            return .yellow
        }
    }
    
    var body: some View {
        ZStack {
            // Enhanced background
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.9), Color.blue.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Confetti effect
            ConfettiView()
            
            VStack(spacing: 30) {
                Text("GAME OVER")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .red.opacity(0.5), radius: 10, x: 0, y: 5)
                
                // Results Card
                VStack(spacing: 25) {
                    // Final Score - Highlighted
                    VStack(spacing: 8) {
                        Text("FINAL SCORE")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .tracking(1)
                        
                        Text("\(gameManager.score)")
                            .font(.system(size: 72, weight: .black, design: .rounded))
                            .foregroundColor(.green)
                            .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.green, lineWidth: 3)
                            )
                    )
                    
                    // Stats
                    HStack(spacing: 30) {
                        StatCard(
                            title: "PENGUINS",
                            value: "\(totalPenguins)",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "TIME",
                            value: gameManager.formattedTime,
                            color: .orange
                        )
                    }
                    
                    // Performance Rating
                    VStack(spacing: 8) {
                        Text("RATING")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.7))
                            .tracking(1)
                        
                        Text(performanceMessage)
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundColor(performanceColor)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, 20)
                
                // Action Buttons
                VStack(spacing: 15) {
                    MenuButton(
                        title: "PLAY AGAIN",
                        icon: "arrow.clockwise",
                        color: .green,
                        action: onPlayAgain
                    )
                    
                    MenuButton(
                        title: "MAIN MENU",
                        icon: "house.fill",
                        color: .blue,
                        action: onBackToMenu
                    )
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 40)
        }
    }
}

// Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.7))
                .tracking(1)
            
            Text(value)
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color.opacity(0.5), lineWidth: 2)
                )
        )
    }
}

// Simple Confetti Effect
struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .offset(x: particle.offsetX, y: particle.offsetY)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createConfetti()
        }
    }
    
    private func createConfetti() {
        particles = (0..<50).map { _ in
            ConfettiParticle(
                id: UUID(),
                color: [Color.red, .green, .blue, .yellow, .purple, .orange].randomElement()!,
                size: CGFloat.random(in: 4...8),
                offsetX: CGFloat.random(in: -200...200),
                offsetY: CGFloat.random(in: -300...300),
                opacity: Double.random(in: 0.7...1.0)
            )
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id: UUID
    let color: Color
    let size: CGFloat
    let offsetX: CGFloat
    let offsetY: CGFloat
    let opacity: Double
}











