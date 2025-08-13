import SwiftUI
import AudioToolbox

struct WorkView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var workTime: Double = 25 * 60 // 秒数で保持（25分）
    @State private var isStart: Bool = false
    // タイマー保持用
    @State private var timer: Timer? = nil
    // 警告状態の管理
    @State private var alertActive: Bool = false
    // 振動繰り返し用タイマー
    @State private var vibrationTimer: Timer? = nil
    var body: some View {
        ZStack {
            Color(hex: "FBDFB8")?.ignoresSafeArea()
            VStack {
                if let device = bleManager.connectedPeripheral {
                    if !bleManager.m5StickBoolValue && isStart {
                        HStack {
                            Text("!")
                                .foregroundColor(.red)
                                .padding(8)
                                .overlay(
                                    Circle()
                                        .stroke(Color.red, lineWidth: 2)
                                )
                            Text("集中してください")
                                .foregroundColor(.red)
                        }
                        .padding(.vertical,4)
                        .padding(.horizontal,18)
                        .background(Color.black)
                        .cornerRadius(24)
                    }
                } else {
                    HStack {
                        Text("!")
                            .foregroundColor(.red)
                            .padding(8)
                            .overlay(
                                Circle()
                                    .stroke(Color.red, lineWidth: 2)
                            )
                        Text("まだデバイスが接続されていません")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical,4)
                    .padding(.horizontal,18)
                    .background(Color.black)
                    .cornerRadius(24)
                }
                Spacer()
                
                ZStack {
                    Image("tomato")
                    Text(formattedTime)
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                }
                Spacer()
                HStack {
                    if !isStart {
                        Button(action: {
                            
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex:"2C3E50")!)
                                    .frame(width:40)
                                Image(systemName: "music.note.list")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    Spacer()
                    if isStart {
                        Button(action: {
                            stopTimer()
                            isStart.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex:"ED5032")!)
                                    .frame(width:50)
                                Image(systemName: "stop.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                    } else {
                        Button(action: {
                            startTimer()
                            isStart.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex:"2C3E50")!)
                                    .frame(width:50)
                                Image(systemName: "arrowtriangle.right")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    Spacer()
                    if !isStart {
                        Button(action: {
                            resetTimer()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex:"2C3E50")!)
                                    .frame(width:40)
                                Image(systemName: "gearshape")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width/2)
                Spacer()
            }
            .onChange(of: bleManager.m5StickBoolValue) { newValue in
                if newValue == false && !alertActive {
                    alertActive = true
                    startEndlessVibration()
                    playAlertSound() // 単発再生。繰り返したい場合はAVAudioPlayer等が必要
                } else if newValue == true && alertActive {
                    alertActive = false
                    stopVibration()
                    // 警告音は停止なし（短いシステム音のため）
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // mm:ss 形式で表示する
    private var formattedTime: String {
        let minutes = Int(workTime) / 60
        let seconds = Int(workTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // タイマー開始
    private func startTimer() {
        stopTimer() // 二重起動防止
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if workTime > 0 {
                workTime -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    // タイマー停止
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // タイマーリセット
    private func resetTimer() {
        stopTimer()
        workTime = 25 * 60
    }
    // 振動を繰り返すためのタイマー開始
    func startEndlessVibration() {
        stopVibration() // 重複開始防止
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }

    // 振動タイマー停止
    func stopVibration() {
        vibrationTimer?.invalidate()
        vibrationTimer = nil
    }

    // 警告音（システム音）の再生（音量調整不可）
    func playAlertSound() {
        AudioServicesPlaySystemSound(1007)
    }
}

#Preview {
    WorkView()
}
