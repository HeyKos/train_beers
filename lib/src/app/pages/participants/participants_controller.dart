import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../domain/entities/event_participant_entity.dart';
import 'participants_presenter.dart';

class ParticipantsController extends Controller {
  /// Members
  final List<EventParticipantEntity> _participants;
  final ParticipantsPresenter participantsPresenter;

  /// Properties
  List<EventParticipantEntity> get participants => _participants;

  // Constructor
  ParticipantsController(filesRepo, usersRepo, participants)
      : participantsPresenter = ParticipantsPresenter(filesRepo, usersRepo),
        _participants = participants,
        super() {
    loadAvatars();
  }

  /// Overrides
  @override
  // this is called automatically by the parent class
  void initListeners() {
    initGetAvatarUrlListeners();
  }

  @override
  void dispose() {
    participantsPresenter.dispose();
    super.dispose();
  }

  /// Methods
  void loadAvatars() {
    for (var participant in _participants) {
      getAvatarDownloadUrl(participant.user.id, participant.user.avatarPath);
    }
  }

  void initGetAvatarUrlListeners() {
    participantsPresenter.getAvatarUrlOnNext = (id, url) {
      print('Get avatar url onNext');
      if (_participants == null) {
        return;
      }
      var participant = _participants.where((participant) {
        return participant.user.id == id;
      }).first;
      participant.user.avatarUrl = url;
      refreshUI();
    };

    participantsPresenter.getAvatarUrlOnComplete = () {
      print('Get avatar url complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    participantsPresenter.getAvatarUrlOnError = (e) {
      print('Could not get avatar url.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void getAvatarDownloadUrl(String id, String path) {
    participantsPresenter.getAvatarDownloadUrl(id, path);
  }
}
