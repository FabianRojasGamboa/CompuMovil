import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class UploadFile extends StatelessWidget {
  final String ticketToken;
  final Function onFileUploaded; // Callback después de subir el archivo

  UploadFile(
      {Key? key, required this.ticketToken, required this.onFileUploaded})
      : super(key: key);

  // Instancia de Logger
  final Logger logger = Logger();

  Future<void> _uploadFile(BuildContext context) async {
    try {
      logger.i('Iniciando selección de archivo...');
      // Obtener el archivo del usuario
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'txt',
          'pdf',
        ], // Se agregó soporte para .docx
      );

      if (result == null) {
        logger.w('No se seleccionó ningún archivo');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se seleccionó ningún archivo')),
        );
        return;
      }

      final file = result.files.first;
      logger.i('Archivo seleccionado: ${file.name} (${file.size} bytes)');

      if (file.size > 5 * 1024 * 1024) {
        logger.w('El archivo supera el límite de 5MB');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El archivo supera el límite de 5MB')),
        );
        return;
      }

      // Leer el token de autorización
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String idToken = prefs.getString('idToken') ?? '';

      if (idToken.isEmpty) {
        logger.w('Token de autorización no encontrado');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se encontró el token de autorización')),
        );
        return;
      }

      String base64File;
      if (file.bytes != null && file.bytes!.isNotEmpty) {
        base64File = base64Encode(file.bytes!);
      } else if (file.path != null) {
        final fileOnDisk = File(file.path!);
        base64File = base64Encode(fileOnDisk.readAsBytesSync());
      } else {
        logger.w('No se pudo leer el contenido del archivo');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al leer el archivo seleccionado')),
        );
        return;
      }

      String mimeType;
      switch (file.extension?.toLowerCase()) {
        case 'pdf':
          mimeType = 'application/pdf';
          break;
        case 'txt':
          mimeType = 'text/plain';
          break;
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        default:
          logger.w('Formato de archivo no permitido');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formato de archivo no permitido')),
          );
          return;
      }

      // Subir el archivo al endpoint
      final dio = Dio();
      final url =
          'https://api.sebastian.cl/oirs-utem/v1/attachments/$ticketToken/upload';

      logger.i('Iniciando subida al servidor...');
      logger.d('URL: $url');
      logger.d('Token: $idToken');
      logger.d('Ticket Token: $ticketToken');

      // Log para verificar la data antes de enviarla
      Map<String, dynamic> requestData = {
        "name": file.name,
        "mime": mimeType,
        "data": base64File,
      };
      logger.d('Payload enviado: ${jsonEncode(requestData)}');

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
        data: requestData,
      );

      logger.i('Respuesta del servidor: Código ${response.statusCode}');
      logger.d('Datos de la respuesta: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si el archivo se sube correctamente, se llama al callback
        onFileUploaded();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Archivo subido exitosamente')),
        );
      } else {
        logger.e(
            'Error al subir archivo: ${response.statusCode} - ${response.statusMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error al subir archivo: ${response.statusMessage}')),
        );
      }
    } catch (e) {
      if (e is DioError && e.response != null) {
        logger.e(
            'Error al subir archivo: Código ${e.response!.statusCode}, Datos ${e.response!.data}');
      } else {
        logger.e('Error desconocido: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir archivo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _uploadFile(context),
        icon: const Icon(Icons.attach_file),
        label: const Text('Subir Archivo'),
      ),
    );
  }
}
