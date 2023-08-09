import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

class PianoScreen extends StatefulWidget {
  const PianoScreen({Key? key}) : super(key: key);

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  FlutterMidi flutterMidi = FlutterMidi();
  String? choice;

  @override
  void initState() {
    load('assets/Guitars.sf2');
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute();
    ByteData byte = await rootBundle.load(asset);
    flutterMidi.prepare(
        sf2: byte, name: 'assets/$choice.sf2'.replaceAll('assets/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Piano'),
          backgroundColor: Colors.black87,
          centerTitle: true,
          actions: [
            DropdownButton<String>(
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              padding: EdgeInsets.zero,
              dropdownColor: Colors.black45,
              value: choice ?? 'Guitars',
              items: const [
                DropdownMenuItem(
                    value: 'Guitars',
                    child: Text(
                      'Guitar',
                      style: TextStyle(color: Colors.white),
                    )),
                DropdownMenuItem(
                  value: 'Expressive',
                  child: Text(
                    'Expressive',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Yamaha',
                  child: Text(
                    'Yamaha',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  choice = value;
                  load('assets/$choice.sf2');
                });
              },
            )
          ],
        ),
        body: Center(
          child: InteractivePiano(
            highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
            naturalColor: Colors.white,
            accidentalColor: Colors.black,
            keyWidth: 60,
            noteRange: NoteRange.forClefs([
              Clef.Treble,
            ]),
            onNotePositionTapped: (position) {
              flutterMidi.playMidiNote(midi: position.pitch);
              // Use an audio library like flutter_midi to play the sound
            },
          ),
        ));
  }
}
