# 🎹 OKpiano  
**Integrating Retro Gaming Design with Modern Piano Education**  
Developed by **Jayson**

---

## 🕹️ Introduction
<img width="96" height="96" alt="icon" src="https://github.com/user-attachments/assets/80be125e-1636-41e2-9771-490c0ee92c78" />

**OKpiano** is a uniquely designed piano learning and practice app that combines the charm of retro **Nintendo DS** aesthetics with modern piano education principles. It transforms piano practice into an engaging, gamified experience — merging nostalgia and technology to make piano learning intuitive, flexible, and fun. Targeted at beginners and casual players, OKpiano offers quick, accessible practice sessions for users who prefer to learn anytime, anywhere.

---

## 🎨 App Design Overview

### Core Features
- 🎮 **Retro Game-Inspired Interface**  
  Dual-screen design inspired by the Nintendo DS, including tactile button feedback, animations, and vibration effects.
  
- 🎹 **Virtual Piano Keyboard**  
  Freely playable keyboard with adjustable range via L/R buttons, and optional note labels for beginners.

- ⚙️ **Sound Effect Controls**  
  Four sliders adjust:
  1. Tremolo depth  
  2. Reverb level  
  3. Delay time  
  4. Delay dry/wet mix

- 🧩 **Gamified Learning Mode**  
  Two interactive training stages:
  1. Identify note names by clicking correct keys  
  2. Recognize pitches by ear and respond on the keyboard  

- 🎨 **Customizable Interface**  
  Choose from multiple retro color schemes and toggle button sounds or key labels to personalize your experience.

---

## 🧠 Technical Implementation

- **Language & IDE:** Swift, Xcode 16.0  
- **Audio Engine:** [AudioKit v5.6.2](https://github.com/AudioKit) for sound synthesis and effects  
- **Tested on:** iPhone 13 Simulator and Device  
- **Architecture:**  
  - Core logic handled in a single `ViewController` class  
  - Modular sub-functions for display updates, random question generation, answer checking, and audio control  
  - Real-time linkage between user input and audio processing  

### Key Functional Modules
| Function | Description |
|-----------|-------------|
| `updateMenuDisplay()` | Refresh UI display |
| `generateHapticFeedback()` | Produce vibration feedback |
| `generateRandomQuestion()` | Create random quiz questions |
| `checkAnswer()` | Evaluate user input accuracy |
| `playSound()` | Trigger button feedback sound |
| `setupEngineOutput()` | Manage keyboard sound output |

---

## 🚀 Future Development

Planned updates include:
- 🎵 More instrument timbres and custom sound design tools  
- 🎮 New gamified challenges (rhythm mode, score learning, reward system)  
- 🎨 Expanded retro interface themes for further personalization  
- 🧠 Enhanced adaptive learning paths for different skill levels  

---

## 🛠️ Tech Stack

| Component | Technology |
|------------|-------------|
| Language | Swift |
| Framework | AudioKit |
| IDE | Xcode 16 |
| UI | UIKit + custom assets |
| Platform | iOS |

---

## 📷 Screenshots
<img width="753" height="475" alt="okpiano" src="https://github.com/user-attachments/assets/2d0f709c-6dcd-4ac6-91b4-869d1dd562ac" />
