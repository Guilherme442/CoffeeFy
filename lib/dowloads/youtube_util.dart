// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeUtil {

  late final _yt;
  late String url;
  var video;
  bool videoLoaded = false;

  YoutubeUtil() {
    _yt = YoutubeExplode();
  }

  void cleanUp() {
    _yt.close();
  }

  Future<bool> loadVideo(String url) async {
    try {
      this.url = url;
      video = await _yt.videos.get(url);
      videoLoaded = true;
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Ocorreu um erro: $e");
      }
      return false;
    }
  }


  String getVideoTitle() {
    if (videoLoaded) {
      return video.title;
    } else {
      return "Nenhum vídeo carregado";
    }
  }



  Future<void> getPath_2() async {
    var path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_MUSIC);
    if (kDebugMode) {
      print(path);
    }
  }

  Future<String> getSaveLocation(String folderName) async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      var downloadsDirectory =
          await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_MUSIC);
      // ignore: unnecessary_null_comparison
      if (downloadsDirectory != null) {
        var coffeefyFolderPath = '$downloadsDirectory/$folderName';
        Directory(coffeefyFolderPath).createSync(recursive: true);
        return coffeefyFolderPath;
      } else {
        throw Exception('Não foi possível obter o diretório de downloads');
      }
    } else {
      status = await Permission.storage
          .request(); // Tentar a permissão do Android 10
      if (status.isGranted) {
        var downloadsDirectory =
            await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_MUSIC);
        // ignore: unnecessary_null_comparison
        if (downloadsDirectory != null) {
          var coffeefyFolderPath = '$downloadsDirectory/$folderName';
          Directory(coffeefyFolderPath).createSync(recursive: true);
          return coffeefyFolderPath;
        } else {
          throw Exception('Não foi possível obter o diretório de downloads');
        }
      } else {
        throw Exception('Permissão negada');
      }
    }
  }

  Future<bool> downloadMP3(String saveLocation) async {
    try {
      // Obtenha o manifesto de vídeo e os fluxos de áudio
      var manifest = await _yt.videos.streamsClient.getManifest(url);
      var audioStream = manifest.audioOnly.last;

     // Crie o diretório e o caminho do arquivo para o arquivo MP3.
      var filePath = '$saveLocation/${video.title}.mp3';
      filePath = filePath.replaceAll(' ', '');
      filePath = filePath.replaceAll("'", '');
      filePath = filePath.replaceAll('"', '');
      print(filePath);

      // Abre o arquivo para escrever
      var file = File(filePath);
      var fileStream = file.openWrite();

      // Canalize o fluxo de áudio para o arquivo.
      await _yt.videos.streamsClient.get(audioStream).pipe(fileStream);

      // Fecha o arquivo.
      await fileStream.flush();
      await fileStream.close();

      print("Download concluído!");
      return true;
    } catch (e) {
      print("Algo deu errado: $e");
      return false;
    }
  }
}
