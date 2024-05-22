import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/model/CandidateModel.dart';
import 'package:chat_with_bisky/model/RTCSessionDescriptionModel.dart';
import 'package:chat_with_bisky/model/RoomAppwrite.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';

final roomRepositoryProvider = Provider((ref) => RoomRepositoryProvider(ref));

class RoomRepositoryProvider {
  final Ref _ref;

  Databases get _db => _ref.read(databaseProvider);

  RoomRepositoryProvider(this._ref);

  Future<RoomAppwrite?> getRoom(String roomId) async {
    try {
      Document document = await _db.getDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionRoomId,
          documentId: roomId);

      return RoomAppwrite.fromJson(document.data);
    } on AppwriteException catch (e) {
      print('ERROR getRoom $e');
    } catch (e) {
      print('ERROR getRoom $e');
    }

    return null;
  }

  Future<CandidateModel?> addCallerCandidates(
      RoomAppwrite roomAppwrite, RTCIceCandidate rtcIceCandidate) async {

    final model = CandidateModel(
        id: ObjectId().hexString,
        candidate: rtcIceCandidate.candidate,
        sdpMid: rtcIceCandidate.sdpMid,
        roomId: roomAppwrite.roomId,
        sdpMLineIndex: rtcIceCandidate.sdpMLineIndex);

    try {
      print('addCallerCandidates>>() ${model.toJson()}');
      Document document = await _db.createDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionCallerId,
          documentId: ObjectId().hexString,
          data: model.toJson());

      print('addCallerCandidates Created CallerId   ${document.$id}');
      return CandidateModel.fromJson(document.data);
    } catch (e) {
      print('addCallerCandidates ERROR RoomRepositoryProvider $e');
    }
    return null;
  }

  Future<CandidateModel?> addCalleeCandidates(
      RoomAppwrite roomAppwrite, RTCIceCandidate rtcIceCandidate) async {

    final model = CandidateModel(
        id: ObjectId().hexString,
        roomId: roomAppwrite.roomId,
        candidate: rtcIceCandidate.candidate,
        sdpMid: rtcIceCandidate.sdpMid,
        sdpMLineIndex: rtcIceCandidate.sdpMLineIndex);

    try {
      Document document = await _db.createDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionCalleeId,
          documentId: ObjectId().hexString,
          data: model.toJson());
      return CandidateModel.fromJson(document.data);
    } on AppwriteException  catch (e) {
      print('addCalleeCandidates ERROR createCallerUserData message= ${e.message} code=${e.code} response=${e.response} type=${e.type}');
    }catch (e) {
      print('addCalleeCandidates ERROR createCallerUserData $e');
    }

    return null;
  }

  Future<RoomAppwrite> addRtcSessionDescription(
      RoomAppwrite roomAppwrite, RTCSessionDescription description) async {


    List<RTCSessionDescriptionModel> list = [];
    final model = RTCSessionDescriptionModel(
        type: description.type, description: description.sdp);

    RoomAppwrite? room = await getRoom(roomAppwrite.roomId!);

    if (room != null) {
      if (room.rtcSessionDescription == null) {
        list.add(model);
      } else {
        List<dynamic> jsonData = json.decode(room.rtcSessionDescription!);
        list = jsonData
            .map((item) => RTCSessionDescriptionModel.fromJson(item))
            .toList();

        bool exist = false;
        for (RTCSessionDescriptionModel md in list) {
          if (md.type == model.type) {
            exist = true;
            md = model;
          }
        }

        if (exist == false) {
          list.add(model);
        }
      }

      try {
        Document document = await _db.updateDocument(
            databaseId: Strings.databaseId,
            collectionId: Strings.collectionRoomId,
            documentId: roomAppwrite.roomId!,
            data: {
              'rtcSessionDescription': json.encode(list),
              'roomId': roomAppwrite.roomId!
            });
        return RoomAppwrite.fromJson(document.data);
      } catch (e) {
        print('addRtcSessionDescription ERROR createCallerUserData $e');
      }
    }

    return roomAppwrite;
  }

  Future<void> deleteRoom(String id) async {
    try {
      deleteCalleeCandidates(id);
      deleteCallerCandidates(id);
      Document document = await _db.deleteDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionRoomId,
          documentId: id);




    } on AppwriteException catch (e) {
      print('ERROR deleteRoom $e');
    } catch (e) {
      print('ERROR deleteRoom $e');
    }
  }


  deleteCalleeCandidates(String roomId) async {
      try{
        DocumentList documentList = await _db.listDocuments(databaseId: Strings.databaseId,
            collectionId: Strings.collectionCalleeId,
            queries: [
              Query.equal("roomId", [roomId]),
              Query.limit(100)
            ]);

        if(documentList.total > 0){

          for(Document document in documentList.documents){

             await _db.deleteDocument(
                databaseId: Strings.databaseId,
                collectionId: Strings.collectionCalleeId,
                documentId: document.$id);
          }

        }

      }catch (e){

        print('delete callee candidates Exception $e');
      }
  }


  deleteCallerCandidates(String roomId) async {
    try{
      DocumentList documentList = await _db.listDocuments(databaseId: Strings.databaseId,
          collectionId: Strings.collectionCallerId,
          queries: [
            Query.equal("roomId", [roomId]),
            Query.limit(100)
          ]);

      if(documentList.total > 0){

        for(Document document in documentList.documents){

          await _db.deleteDocument(
              databaseId: Strings.databaseId,
              collectionId: Strings.collectionCallerId,
              documentId: document.$id);
        }

      }

    }catch (e){

      print('delete caller candidates Exception $e');
    }
  }

  Future<RoomAppwrite?> createNewRoom(RoomAppwrite callDataAppwrite) async {
    try {
      Document document = await _db.createDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionRoomId,
          documentId: callDataAppwrite.roomId!,
          data: callDataAppwrite.toJson());

      return RoomAppwrite.fromJson(document.data);
    } catch (e) {
      print('ERROR createNewRoom $e');
    }

    return null;
  }
  Future<RoomAppwrite?> updatePresenterUserRoom(RoomAppwrite room,String? presenterUserId) async {
    try {
        Document document = await _db.updateDocument(
            databaseId: Strings.databaseId,
            collectionId: Strings.collectionRoomId,
            documentId: room.roomId!,
            data: {
              'presentingUserId': presenterUserId
            });
        return RoomAppwrite.fromJson(document.data);


      return RoomAppwrite.fromJson(document.data);
    } catch (e) {
      print('ERROR updatePresenterUserRoom $e');
    }

    return null;
  }

}
