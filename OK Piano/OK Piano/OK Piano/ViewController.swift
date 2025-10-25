//
//  ViewController.swift
//  OK Piano
//
//  Created by Jayson Chen on 16/11/2024.
//

import UIKit
import AudioKit
import SoundpipeAudioKit
import AVFoundation

// Enumeration for different menu states
enum MenuState{
    case mainMenu
    case settingsMenu
    case authorMenu
}

class ViewController: UIViewController {
    
    
    // Restrict the application to portrait orientation.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    override var shouldAutorotate: Bool{
        return false
    }
    //Initialize data
    let keybuttonsTag = [60,61,62,63,64,65,66,67,68,69,70,71]
    let noteIndices: [String: Int] =
        ["C": 0, "C#": 1, "D": 2, "D#": 3, "E": 4, "F": 5, "F#": 6,
        "G": 7, "G#": 8, "A": 9, "A#": 10, "B": 11]
    let keys = ["C1","D1","E1","F1","G1","A1","B1","C2","D2","E2","F2","G2","A2","B2","C3","D3","E3","F3","G3","A3","B3","C4","D4","E4","F4","G4","A4","B4","C5","D5","E5","F5","G5","A5","B5","C6","D6","E6","F6","G6","A6","B6","C7","D7","E7","F7","G7","A7","B7","C#1","D#1","F#1","G#1","A#1","C#2","D#2","F#2","G#2","A#2","C#3","D#3","F#3","G#3","A#3","C#4","D#4","F#4","G#4","A#4","C#5","D#5","F#5","G#5","A#5","C#6","D#6","F#6","G#6","A#6","C7#","D#7","F#7","G#7","A#7"]
    
    
    // AudioKit engine and components
    var engine: AudioEngine!      // This is the main AudioKit engine
    
    var osc: Oscillator!          // Create an instance of an AudioKit Oscillator
    
    var sampler: MIDISampler!       // Create an instance of a MIDI sampler
    
    var audioPlayer: AVAudioPlayer?// Create an instance of an audio player
    
    var delay: Delay!
    
    var reverb: Reverb!
    
    var tremolo: Tremolo!
    
    //Initialize all variables
    var tremoloDepth = 0.0
    var delayTime = 0.0
    var delayMix = 0.0
    var reverbMix = 0.0
    
    var timbre = 0
    var octave = 0
    
    var helpFlag = 0
    var colorFlag = 0
    var enterQuizFlag = 0
    var soundonoffFlag = 0
    
    var currentState: MenuState = .mainMenu
    let mainMenuItems = ["START","SETTINGS","AUTHOR"]
    let settingsMenuItems = ["BACKGROUND", "HELP","BUTTON SOUND"]
    let authorItems = ["Inspired by Nintendo DS","JAYSON CHEN","pwm516@york.ac.uk"]
    
    var currentIndex = 0
    
    var questionType = 0
    var questionTypeNumber = 0
    var correctAnswer: String = ""
 
    var currentScore: Int = 0
    var highestScore: Int = 0
    
    //Initialize color
    let skyBlue = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0)
    let bubbleGum = UIColor(red: 1.0157521963119507, green: 0.823032557964325, blue: 0.8422972559928894, alpha: 1.0)
    let milkyWhite = UIColor(red: 1.0, green: 0.98, blue: 0.96, alpha: 1.0)
    
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    @IBOutlet weak var tipBox: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet var menuLabels: [UILabel]!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var confrimLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var timbreSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var keyboardSquare: UIView!
    
    @IBOutlet weak var keyC: UIButton!
    
    @IBOutlet weak var keyCsharp: UIButton!
    
    @IBOutlet weak var keyD: UIButton!
    
    @IBOutlet weak var keyDsharp: UIButton!
    
    @IBOutlet weak var keyE: UIButton!
    
    @IBOutlet weak var keyF: UIButton!
    
    @IBOutlet weak var keyFsharp: UIButton!
    
    @IBOutlet weak var keyG: UIButton!
    
    @IBOutlet weak var keyGsharp: UIButton!
    
    @IBOutlet weak var keyA: UIButton!
    
    @IBOutlet weak var keyAsharp: UIButton!
    
    @IBOutlet weak var keyB: UIButton!
    
    @IBOutlet weak var delayTimeSlider: UISlider!
    
    @IBOutlet weak var tremoloDepthSlider: UISlider!
    
    @IBOutlet weak var reverbSlider: UISlider!
    
    @IBOutlet weak var delayMixSlider: UISlider!
    
    @IBOutlet weak var octaveDownButton: UIButton!
    
    @IBOutlet weak var octaveUpButton: UIButton!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //update the menu display
    func updateMenuDisplay(){
        
        switch enterQuizFlag{
        case 0:                   //means the user is not in the quiz
            
            questionLabel.isHidden = true
            answerLabel.isHidden = true
            feedbackLabel.isHidden = true
            scoreLabel.isHidden = true
            titleLabel.isHidden = false
            subtitle.isHidden = false
            selectLabel.isHidden = false
            confrimLabel.isHidden = false
            confrimLabel.text = "□ : CONFIRM"
            
            var items: [String]
            switch currentState {
            case .mainMenu:         //means the user is on the main menu
                items = mainMenuItems
                startBlinking(label:selectLabel)
                startBlinking(label: confrimLabel)
                startBlinking(label: backLabel)
                startBlinking(label: subtitle)
            case .settingsMenu:     //means the user is on the settings menu
                items = settingsMenuItems
                stopBlinking(label:selectLabel)
                stopBlinking(label: confrimLabel)
                stopBlinking(label: backLabel)
                stopBlinking(label: subtitle)
            case .authorMenu:       //means the user is checking the author info
                items = authorItems
                stopBlinking(label:selectLabel)
                stopBlinking(label: confrimLabel)
                stopBlinking(label: backLabel)
                stopBlinking(label: subtitle)
            }
            
            //display the corresponding menu and highlight user's current option
            for(index,label) in menuLabels.enumerated(){
                label.text = items[index]
                label.isHidden = false
                label.textColor = index == currentIndex ? .systemBlue : .label
                
                if currentState == .authorMenu{     //not highlighted on author page
                    label.textColor = .black
                    selectLabel.isHidden = true
                    confrimLabel.isHidden = true
                }
            }
        case 1:                   //means the user is in the quiz and hides labels
            questionLabel.isHidden = false
            answerLabel.isHidden = false
            feedbackLabel.isHidden = false
            scoreLabel.isHidden = false
            titleLabel.isHidden = true
            subtitle.isHidden = true
            selectLabel.isHidden = true
            confrimLabel.text = "□ : NEXT"
            stopBlinking(label:selectLabel)
            stopBlinking(label: confrimLabel)
            stopBlinking(label: backLabel)
            stopBlinking(label: subtitle)
            for label in menuLabels{
                label.isHidden = true
            }
        default:
            break
        }
        
    }
    
    //generate vibration feedback
    func generateHapticFeedback(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
    }
    
    //generate key animation
    func animateButtonPress(_ button:UIButton){
        UIView.animate(withDuration: 0.1, animations: {button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)}){_ in UIView.animate(withDuration: 0.1)
            {button.transform = .identity}}
    }
    
    //Play key feedback sound
    func playSound(for fileName: String) {
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: "wav") {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                        if soundonoffFlag == 0{
                            audioPlayer?.volume = 0.5
                            audioPlayer?.play()
                        }
                    } catch {
                        print("can't play the audio file：\(error.localizedDescription)")
                    }
                } else {
                    print("can't find the audio file：\(fileName).wav")
                }
       }
    
    //generate a flashing animation
    func startBlinking(label: UILabel) {
        UIView.animate(withDuration: 0.5,delay: 0.0,options: [.repeat, .autoreverse],animations: {
                           label.alpha = 0.0
                       },
                       completion: nil)
    }
    
    //stop the  flashing animation
    func stopBlinking(label: UILabel) {
        label.layer.removeAllAnimations()
        label.alpha = 1.0
    }
    
    //display feedback information
    func showInfoMessage(_ message: String, on label: UILabel, duration: TimeInterval = 1.0) {
        
        label.layer.removeAllAnimations()
        
        label.isHidden = false
        label.alpha = 1.0
        label.text = message
        
        // animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            UIView.animate(withDuration: duration, animations: {
                label.alpha = 0.0
            })
        }
        
    }
    
    //convert note names to MIDI numbers
    func midiNumber(from noteName: String) -> Int? {
        
        // Separating the letter and octave parts of a note name
        let regex = try! NSRegularExpression(pattern: "([A-Ga-g#]+)(-?\\d+)")
        guard let match = regex.firstMatch(in: noteName, range: NSRange(noteName.startIndex..., in: noteName)),
              let noteRange = Range(match.range(at: 1), in: noteName),
              let octaveRange = Range(match.range(at: 2), in: noteName) else {
            return nil
        }

        let note = String(noteName[noteRange])
        let octave = Int(noteName[octaveRange])

        // Check the note name
        guard let noteIndex = noteIndices[note], let octaveValue = octave else {
            return nil
        }

        // Calculating MIDI Numbers
        return (octaveValue + 1) * 12 + noteIndex
    }

    //Generate random questions
    func generateRandomQuestion(){
        
        correctAnswer = keys.randomElement() ?? "C4"
        
        scoreLabel.textAlignment = .right
        questionLabel.textAlignment = .left
        feedbackLabel.textAlignment = .right
        
        if questionType == 0{
            //When the user enters the first page of the quiz, a tutorial is given
            scoreLabel.textAlignment = .center
            questionLabel.textAlignment = .center
            feedbackLabel.textAlignment = .center
            scoreLabel.text = "Use Sliders to Adjust Sound Effects"
            questionLabel.text = "Use Switch to Change Timbre"
            answerLabel.text = ""
            feedbackLabel.text = "Click L and R to Change Octave"
            feedbackLabel.textColor = .black
            
        }
        else if questionType == 1{
            //Show first level quiz
            questionLabel.text = "Please Play the Key You See"
            answerLabel.text = correctAnswer
            feedbackLabel.text = ""
        }
        else if questionType == 2{
            //Show second level quiz
            questionLabel.text = "Please Play the Key You Hear"
            let midiNumber = midiNumber(from: correctAnswer) ?? 60
            setupEngineOutput(senderTag: midiNumber - octave)
            
            if timbre == 1{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.osc.$amplitude.ramp(to:0,duration: Float(0.2))
                }
            }
            answerLabel.text = "♫"
            feedbackLabel.text = ""
            print("midiNumber\(midiNumber)")
            print("senderTag\(midiNumber - octave )")
            
        }
        print("questionType\(questionType)")
        print("correct:\(correctAnswer)")
    }
    
    //Check if the user's answer is correct
    func checkAnswer(noteName: String) -> Bool{
        
        
        print(noteName)
        
        if noteName == correctAnswer{
            feedbackLabel.text = "CORRECT!"
            answerLabel.text = "\(correctAnswer) ✓"
            feedbackLabel.textColor = .systemMint
            return true
        }else{
            feedbackLabel.text = "WRONG:("
            answerLabel.text = "\(correctAnswer) ✗"
            feedbackLabel.textColor = .systemPink
            return false
        }
    }
    
    //Set up engine output and play
    func setupEngineOutput(senderTag: Int){
        if timbre == 0{
            
            tremolo = Tremolo(sampler)
            tremolo.depth = AUValue(tremoloDepth)
            
            delay = Delay(tremolo)
            delay.time = AUValue(delayTime)
            delay.dryWetMix = AUValue(delayMix)
            
            reverb = Reverb(delay)
            reverb.dryWetMix = AUValue(reverbMix)
            
            engine.output = reverb
            sampler.volume = 10
            sampler.play(noteNumber: MIDINoteNumber(senderTag + octave + 5), velocity: 100, channel: 0)
            
            print("piano key: \(senderTag + octave)")
            
            try! sampler.loadWav("fmpia1")
            
        }
        
        else if timbre == 1{
                            
            osc.amplitude = 0.1
            osc.frequency = AUValue(440 * pow(2,Double((senderTag - 20 + octave) - 49)/12))
            
            tremolo = Tremolo(osc)
            tremolo.depth = AUValue(tremoloDepth)
            
            delay = Delay(tremolo)
            delay.time = AUValue(delayTime)
            delay.dryWetMix = AUValue(delayMix)
            
            reverb = Reverb(delay)
            reverb.dryWetMix = AUValue(reverbMix)
            
            engine.output = reverb
            print(osc.frequency)
            print(osc.amplitude)
        }
        
        try! engine.start()         // Start the AudioKit audio-engine
    }
    
    //Set keyboard octave
    func setupOctave(senderTag: Int){
        
        if senderTag == 4
        {
            octave = octave - 12
        }
        else if senderTag == 5
        {
            octave = octave + 12
        }
        octave = min(max(octave,-36),36)
        print(octave)
        
        showInfoMessage("\((octave / 12) + 4)", on: infoLabel)

        if octave < 0
        {
            octaveDownButton.setImage(UIImage(systemName: "l.rectangle.roundedbottom.fill"), for: .normal)
            octaveUpButton.setImage(UIImage(systemName: "r.rectangle.roundedbottom"), for: .normal)
        }
        else if octave > 0
        {
            octaveDownButton.setImage(UIImage(systemName: "l.rectangle.roundedbottom"), for: .normal)
            octaveUpButton.setImage(UIImage(systemName: "r.rectangle.roundedbottom.fill"), for: .normal)
        }
        else if octave == 0
        {
            octaveDownButton.setImage(UIImage(systemName: "l.rectangle.roundedbottom"), for: .normal)
            octaveUpButton.setImage(UIImage(systemName: "r.rectangle.roundedbottom"), for: .normal)
        }
    }
    
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    //When the select key is pressed
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        generateHapticFeedback()
        animateButtonPress(sender)
        playSound(for: "tap01")
        if enterQuizFlag == 0{
            let itemCount = (currentState == .mainMenu) ? mainMenuItems.count : settingsMenuItems.count
            currentIndex = (currentIndex + 1) % itemCount
            updateMenuDisplay()
        }
    }
    
    //When the confirm key is pressed
    @IBAction func comfirmButtonTapped(_ sender: UIButton) {
        generateHapticFeedback()
        animateButtonPress(sender)
        playSound(for: "button")
        
        if enterQuizFlag == 0 {     //When the user is on the menu page
            
            switch currentState {
            case .mainMenu:     //main menu
                switch currentIndex{
                case 0:
                    enterQuizFlag = 1
                    updateMenuDisplay()
                    generateRandomQuestion()
                    print("start selected")
                case 1:
                    currentState = .settingsMenu
                    currentIndex = 0
                    updateMenuDisplay()
                case 2:
                    print("author selected")
                    currentState = .authorMenu
                    updateMenuDisplay()
                    
                default:
                    break
                }
            case .settingsMenu:     //setting menu
                switch currentIndex{
                case 0:         //Set the background color
                    print("background changed")
                    
                    if colorFlag == 0{
                        self.view.backgroundColor = skyBlue
                        tremoloDepthSlider.thumbTintColor = bubbleGum
                        reverbSlider.thumbTintColor = bubbleGum
                        delayTimeSlider.thumbTintColor = bubbleGum
                        delayMixSlider.thumbTintColor = bubbleGum
                        timbreSegmentedControl.selectedSegmentTintColor = bubbleGum
                        colorFlag = 1
                        showInfoMessage("Sky Blue", on: infoLabel)
                    }
                    else if colorFlag == 1{
                        self.view.backgroundColor = milkyWhite
                        tremoloDepthSlider.thumbTintColor = skyBlue
                        reverbSlider.thumbTintColor = skyBlue
                        delayTimeSlider.thumbTintColor = skyBlue
                        delayMixSlider.thumbTintColor = skyBlue
                        timbreSegmentedControl.selectedSegmentTintColor = skyBlue
                        colorFlag = 2
                        showInfoMessage("Milky White", on: infoLabel)
                    }
                    else if colorFlag == 2{
                        self.view.backgroundColor = bubbleGum
                        tremoloDepthSlider.thumbTintColor = milkyWhite
                        reverbSlider.thumbTintColor = milkyWhite
                        delayTimeSlider.thumbTintColor = milkyWhite
                        delayMixSlider.thumbTintColor = milkyWhite
                        timbreSegmentedControl.selectedSegmentTintColor = milkyWhite
                        colorFlag = 0
                        showInfoMessage("Bubble Gum", on: infoLabel)
                    }
                case 1:         //Turn on and off key hints
                    print("Help selected")
                    showInfoMessage("Bubble Gum", on: infoLabel)
                    if helpFlag == 0 {
                        helpFlag = 1
                        showInfoMessage("HELP: ON", on: infoLabel)
                        keyC.titleLabel?.isHidden = false
                        keyCsharp.titleLabel?.isHidden = false
                        keyD.titleLabel?.isHidden = false
                        keyDsharp.titleLabel?.isHidden = false
                        keyE.titleLabel?.isHidden = false
                        keyF.titleLabel?.isHidden = false
                        keyFsharp.titleLabel?.isHidden = false
                        keyG.titleLabel?.isHidden = false
                        keyGsharp.titleLabel?.isHidden = false
                        keyA.titleLabel?.isHidden = false
                        keyAsharp.titleLabel?.isHidden = false
                        keyB.titleLabel?.isHidden = false
                    }
                    else if helpFlag == 1{
                        helpFlag = 0
                        showInfoMessage("HELP: OFF", on: infoLabel)
                        keyC.titleLabel?.isHidden = true
                        keyCsharp.titleLabel?.isHidden = true
                        keyD.titleLabel?.isHidden = true
                        keyDsharp.titleLabel?.isHidden = true
                        keyE.titleLabel?.isHidden = true
                        keyF.titleLabel?.isHidden = true
                        keyFsharp.titleLabel?.isHidden = true
                        keyG.titleLabel?.isHidden = true
                        keyGsharp.titleLabel?.isHidden = true
                        keyA.titleLabel?.isHidden = true
                        keyAsharp.titleLabel?.isHidden = true
                        keyB.titleLabel?.isHidden = true
                    }
                case 2:         //Turn key sounds on or off
                    if soundonoffFlag == 0{
                        
                        soundonoffFlag = 1
                        showInfoMessage("SOUND: OFF", on: infoLabel)
                    }else{
                        
                        soundonoffFlag = 0
                        showInfoMessage("SOUND: ON", on: infoLabel)
                    }
                default:
                    break
                }
            case .authorMenu:
                updateMenuDisplay()
            }
        }
        else if enterQuizFlag == 1 && questionType != 2{    //When the user is on the question answering page
            
            questionType += 1
            questionType = min(questionType,2)
            generateRandomQuestion()
            if questionType == 1{
                scoreLabel.text = "Score: 0"
            }
            else if questionType == 2{
                currentScore = 0
                scoreLabel.text = "Score: 0"
                confrimLabel.isHidden = true
            }
            
        }
    }
    
    //When the back key is pressed
    @IBAction func backButtonTapped(_ sender: UIButton) {
        generateHapticFeedback()
        animateButtonPress(sender)
        playSound(for: "tap01")
        
        questionType = 0
        enterQuizFlag = 0
        currentState = .mainMenu
        currentIndex = 0
        updateMenuDisplay()
        
    }
    
    //When the user changes the timbre
    @IBAction func timbreChanged(_ sender: UISegmentedControl) {
        generateHapticFeedback()
        
        switch sender.selectedSegmentIndex{
        case 0:
            timbre = 0
            showInfoMessage("PIANO", on: infoLabel)
            playSound(for: "transition_down")
        case 1:
            timbre = 1
            osc.amplitude = 0
            showInfoMessage("OSCILLATOR", on: infoLabel)
            playSound(for: "transition_up")
        default:
            break
        }
        print("timbre:\(timbre)")
    }
    
    
    @IBAction func tremoloDepthChanged(_ sender: UISlider) {
        tremoloDepth = Double(sender.value)
        print(tremoloDepth)
        showInfoMessage("Tremolo: \(Int(tremoloDepth*100))%", on: infoLabel)
    }
    
    @IBAction func reverbMixChanged(_ sender: UISlider) {
        reverbMix = Double(sender.value)
        print(reverbMix)
        showInfoMessage("Reverb: \(Int(reverbMix*100))%", on: infoLabel)
    }
    
    @IBAction func delayTimeChanged(_ sender: UISlider) {
        delayTime = Double(sender.value)
        print(delayTime)
        showInfoMessage("DelayTime: \(Int(delayTime*100))%", on: infoLabel)
    }
    
    @IBAction func delayMixChanged(_ sender: UISlider) {
        delayMix = Double(sender.value)
        print(delayMix)
        showInfoMessage("DelayMix: \(Int(delayMix*100))%", on: infoLabel)
    }
    
    //When the user presses a key or moves up or down an octave
    @IBAction func buttonsPressed(_ sender: UIButton) {
        generateHapticFeedback()
        if keybuttonsTag.contains(sender.tag) //if piano keys pressed
        {
            
            sender.alpha  = 0.5
            guard let noteTitle = sender.titleLabel?.text else {return}
            let noteName = String("\(noteTitle)" + "\((octave / 12) + 4)")
            showInfoMessage("\(noteName)", on: infoLabel)
            setupEngineOutput(senderTag: sender.tag)
            
            if enterQuizFlag == 1 && questionType > 0 {
                self.scoreLabel.text = "Score: \(currentScore)"
                let isCorrect = checkAnswer(noteName: noteName)
                if isCorrect{
                    currentScore += 1
                    self.scoreLabel.text = "Score: \(currentScore)"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.generateRandomQuestion()
                        self.feedbackLabel.text = ""
                    }
                }else{
                    highestScore = max(highestScore,currentScore)
                    currentScore = 0
                    self.scoreLabel.text = "Score: \(currentScore)"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.feedbackLabel.text = "Highest Score: \(self.highestScore)"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                            self.generateRandomQuestion()
                            self.feedbackLabel.text = ""
                        }
                    }
                }
            }
        }
        else if sender.tag == 4 || sender.tag == 5  //if octave changed
        {
            animateButtonPress(sender)
            setupOctave(senderTag: sender.tag)

        }
        
    }
    
    //When the keys are released
    @IBAction func butonsReleasd(_ sender: UIButton)
    {
        sender.alpha  = 1.0
        if timbre == 0{
            sampler.stop(noteNumber: MIDINoteNumber(sender.tag + octave), channel: 0)
        }
        if timbre == 1{
            self.osc.$amplitude.ramp(to:0,duration: Float(0.2))
        }
    }
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize the user interface
        tipBox.layer.borderColor = UIColor.black.cgColor
        tipBox.layer.borderWidth = 2.0
        tipBox.layer.cornerRadius = 7
        keyboardSquare.layer.borderColor = UIColor.black.cgColor
        keyboardSquare.layer.borderWidth = 2.0
        keyboardSquare.layer.cornerRadius = 7
        infoView.layer.cornerRadius = 8
        keyC.titleLabel?.isHidden = true
        keyCsharp.titleLabel?.isHidden = true
        keyD.titleLabel?.isHidden = true
        keyDsharp.titleLabel?.isHidden = true
        keyE.titleLabel?.isHidden = true
        keyF.titleLabel?.isHidden = true
        keyFsharp.titleLabel?.isHidden = true
        keyG.titleLabel?.isHidden = true
        keyGsharp.titleLabel?.isHidden = true
        keyA.titleLabel?.isHidden = true
        keyAsharp.titleLabel?.isHidden = true
        keyB.titleLabel?.isHidden = true
        delayTimeSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        tremoloDepthSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        reverbSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        delayMixSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        updateMenuDisplay()
        
        //Loading Engines and Samples
        
        engine = AudioEngine()
        osc = Oscillator(waveform: Table(.square))
        sampler = MIDISampler()
        
        do {
            try sampler.loadWav("fmpia1")
                print("fmpia1 loaded successfully")
        } catch {
            print("Failed to load wav file: \(error)")
        }
        
        osc.amplitude = 0
        osc.start()                 // Start our oscillator
    }

}

