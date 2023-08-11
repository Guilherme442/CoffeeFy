// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../drawer.dart';
import 'youtube_util.dart';
import 'package:external_path/external_path.dart';
import 'package:percent_indicator/percent_indicator.dart';

class YoutubeutilPage extends StatefulWidget {
  const YoutubeutilPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _YoutubeutilPageState createState() => _YoutubeutilPageState();
}

class _YoutubeutilPageState extends State<YoutubeutilPage> {
  final TextEditingController _urlController = TextEditingController();
  String _videoTitle = '';
  bool _isDownloading = false;
  bool _downloadSuccess = false;
  late String _filePath;

  InputDecorationTheme _getTextFieldTheme(BuildContext context) {
    return InputDecorationTheme(
      labelStyle: const TextStyle(
          color: Colors.white), // Define a cor do labelText para branco
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _startDownload() async {
    String url = _urlController.text.trim();

    if (url.isNotEmpty) {
      setState(() {
        _isDownloading = true;
        _downloadSuccess = false;
        _videoTitle = '';
      });

      YoutubeUtil youtubeUtil = YoutubeUtil();
      // Adicione a seguinte linha para forçar a solicitação da permissão novamente
      await Permission.storage.request();
      bool videoLoaded = await youtubeUtil.loadVideo(url);

      if (videoLoaded) {
        setState(() {
          _videoTitle = youtubeUtil.getVideoTitle();
        });

        try {
          String folderName = 'Coffeefy';
          _filePath = await youtubeUtil.getSaveLocation(folderName);

          bool downloadSuccess = await youtubeUtil.downloadMP3(_filePath);

          if (downloadSuccess) {
            setState(() {
              _downloadSuccess = true;
            });
            _showDownloadLocation(_filePath); // Mostrar localização do arquivo
          } else {
            // Tratar caso o download falhe
          }
        } catch (e) {
          print("Ocorreu um erro durante o download: $e");
        }
      } else {
        // Tratar caso o vídeo não possa ser carregado
      }

      youtubeUtil.cleanUp();

      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> getPath_2() async {
    var path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_MUSIC);
    print(path);
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

  @override
  Widget build(BuildContext context) {
    final textFieldTheme = _getTextFieldTheme(context);

    return Scaffold(
      
        appBar: AppBar(
          centerTitle: true,
          title: const Text('YouTube Downloader'),
         
        ),
        drawer: const CustomDrawer(),
        body: Container(
          decoration: const BoxDecoration(
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Theme(
              data: Theme.of(context)
                  .copyWith(inputDecorationTheme: textFieldTheme),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _urlController,
                    style: const TextStyle(
                        color: Colors
                            .white), // Define a cor do texto inserido para branco
                    decoration: InputDecoration(
                      labelText: 'YouTube URL',
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[400]!, Colors.green[700]!],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _isDownloading ? null : _startDownload,
                      icon: _isDownloading
                          ? const SpinKitPumpingHeart(
                              color: Colors.red,
                              size: 24.0,
                            )
                          : const Icon(Icons.local_fire_department_rounded),
                      label:
                          Text(_isDownloading ? 'Downloading...' : 'Download'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (_isDownloading)
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      animation: true,
                      lineHeight: 10,
                      animationDuration: 3500,
                      percent: 0.8,
                      center: const Text(""),
                      // ignore: deprecated_member_use
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.green,
                    ), // Adicionando indicador de progresso
                  const SizedBox(height: 16.0),
                  Text(
                    'Título do vídeo: $_videoTitle',
                    style: const TextStyle(
                      color: Colors.white, // Define a cor do texto para branca
                    ),
                  ),
                  const SizedBox(height: 20),
                  _downloadSuccess
                      ? const Text(
                          'Download Concluído',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ));
  }

  void _showDownloadLocation(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Download Concluído',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sua música foi baixada com sucesso!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                     SpinKitPumpingHeart(
                color: Colors.red,
                size: 30,
              ),
                  SizedBox(width: 5),
                  Text('Sair', style: TextStyle(color: Colors.white)),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
