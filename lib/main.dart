import 'package:flutter/material.dart';
import 'package:flutter_music_player/provider/song_model_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'features/shared/ui/screens/AllSongs.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => SongModelProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
           home: const Scaffold(
        body: AllSongs(),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.emilysCandyTextTheme(),
      scaffoldBackgroundColor: Colors.brown[100],
      ),
      darkTheme: ThemeData.dark(),
      
    );
  }
}
