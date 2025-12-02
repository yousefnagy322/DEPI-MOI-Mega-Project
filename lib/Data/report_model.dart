import 'dart:io';
import 'package:dio/dio.dart';

class ReportsResponse {
  final List<Report> reports;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  ReportsResponse({
    required this.reports,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory ReportsResponse.fromJson(Map<String, dynamic> json) {
    return ReportsResponse(
      reports: (json['reports'] as List<dynamic>)
          .map((e) => Report.fromJson(e))
          .toList(),
      total: json['total'],
      page: json['page'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reports': reports.map((e) => e.toJson()).toList(),
      'total': total,
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
    };
  }
}

class Report {
  final String title;
  final String descriptionText;
  final String categoryId;
  final String location;

  final bool isAnonymous;
  final String? transcribedVoiceText;
  final String? hashedDeviceId;

  /// Files you want to upload → NOT part of API response
  final List<File>? filesToUpload;

  /// Response-only fields
  final String? reportId;
  final String? status;
  final double? aiConfidence;
  final String? createdAt;
  final String? updatedAt;
  final String? userId;
  final List<Attachment> attachments;

  Report({
    required this.title,
    required this.descriptionText,
    required this.categoryId,
    required this.location,
    this.isAnonymous = false,
    this.transcribedVoiceText,
    this.hashedDeviceId,
    this.filesToUpload,
    this.reportId,
    this.status,
    this.aiConfidence,
    this.createdAt,
    this.updatedAt,
    this.userId,
    required this.attachments,
  });

  /// ----------- FROM JSON (GET) -----------
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      title: json['title'],
      descriptionText: json['descriptionText'],
      categoryId: json['categoryId'],
      location: json['location'],
      isAnonymous: json['isAnonymous'] ?? false,
      transcribedVoiceText: json['transcribedVoiceText'],
      hashedDeviceId: json['hashedDeviceId'],
      reportId: json['reportId'],
      status: json['status'],
      aiConfidence: json['aiConfidence']?.toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => Attachment.fromJson(e))
          .toList(),
      filesToUpload: null, // important: never included from backend
    );
  }

  /// ----------- TO JSON (for reading only, not for POST) -----------
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'descriptionText': descriptionText,
      'categoryId': categoryId,
      'location': location,
      'isAnonymous': isAnonymous,
      'transcribedVoiceText': transcribedVoiceText,
      'hashedDeviceId': hashedDeviceId,
      'reportId': reportId,
      'status': status,
      'aiConfidence': aiConfidence,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userId': userId,
      'attachments': attachments.map((e) => e.toJson()).toList(),
    };
  }

  /// ----------- FORM DATA FOR API UPLOAD -----------
  Future<FormData> toFormData() async {
    List<MultipartFile> fileList = [];

    if (filesToUpload != null) {
      for (var file in filesToUpload!) {
        fileList.add(
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }
    }

    return FormData.fromMap({
      "title": title,
      "user_id": userId,
      "descriptionText": descriptionText,
      "location": location,
      "categoryId": categoryId,
      "isAnonymous": isAnonymous.toString(),
      "transcribedVoiceText": transcribedVoiceText ?? "",
      "hashedDeviceId": hashedDeviceId ?? "",
      "files": fileList,
    });
  }
}

class Attachment {
  final String attachmentId;
  final String reportId;
  final String blobStorageUri;
  final String downloadUrl;
  final String mimeType;
  final String fileType;
  final int fileSizeBytes;
  final String createdAt;

  Attachment({
    required this.blobStorageUri,
    required this.mimeType,
    required this.fileType,
    required this.fileSizeBytes,
    required this.attachmentId,
    required this.reportId,
    required this.createdAt,
    required this.downloadUrl,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      blobStorageUri: json['blobStorageUri'],
      mimeType: json['mimeType'],
      fileType: json['fileType'],
      fileSizeBytes: json['fileSizeBytes'],
      attachmentId: json['attachmentId'],
      reportId: json['reportId'],
      createdAt: json['createdAt'],
      downloadUrl: json['downloadUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blobStorageUri': blobStorageUri,
      'mimeType': mimeType,
      'fileType': fileType,
      'fileSizeBytes': fileSizeBytes,
      'attachmentId': attachmentId,
      'reportId': reportId,
      'createdAt': createdAt,
      'downloadUrl': downloadUrl,
    };
  }
}
