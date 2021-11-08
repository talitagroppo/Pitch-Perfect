//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Talita Groppo on 26/10/2021.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    var isRecording: Bool = false {
        didSet {
            self.stopRecordingButton.alpha = isRecording ? 1.0 : 0.5
            self.stopRecordingButton.isEnabled = isRecording
            self.recordButton.alpha = isRecording ? 0.5 : 1.0
            self.recordButton.isEnabled = !isRecording
            self.recordingLabel.text = isRecording ? "Recording ..." : "Tap To Record"
        }
    }
    
    //I used alpha to stop button will be disabled in shaded colors when there is no audio recording.
    override func viewDidLoad() {
        super.viewDidLoad()
        isRecording = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        isRecording = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
                let recordingName = "recordedVoice.wav"
                let pathArray = [dirPath, recordingName]
                let filePath = URL(string: pathArray.joined(separator: "/"))

                let session = AVAudioSession.sharedInstance()
                try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
       isRecording = false
        audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
        print("Recording was not sucessful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURl = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURl
        }
    }
}

