import 'package:train_beers/src/domain/entities/event_participant_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'active_users_presenter.dart';

class ActiveUsersController extends Controller {
  /// Members
  List<EventParticipantEntity> _participants;
  final ActiveUsersPresenter activeUsersPresenter;
  
  /// Properties
  List<EventParticipantEntity> get participants => _participants;

  // Constructor
  ActiveUsersController(filesRepo, usersRepo, List<EventParticipantEntity> participants) :
    activeUsersPresenter = ActiveUsersPresenter(filesRepo, usersRepo),
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
    activeUsersPresenter.dispose();
    super.dispose();
  }

  /// Methods
  void loadAvatars() {
    _participants.forEach((participant) {
      getAvatarDownloadUrl(participant.user.id, participant.user.avatarPath);
    });
  }

  void initGetAvatarUrlListeners() {
    activeUsersPresenter.getAvatarUrlOnNext = (String id, String url) {
      print('Get avatar url onNext');
      if (_participants == null) {
        return;
      }
      var participant = _participants.where((participant) => participant.user.id == id).first;
      participant.user.avatarUrl = url;
      refreshUI();
    };

    activeUsersPresenter.getAvatarUrlOnComplete = () {
      print('Get avatar url complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    activeUsersPresenter.getAvatarUrlOnError = (e) {
      print('Could not get avatar url.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void getAvatarDownloadUrl(String id, String path) => activeUsersPresenter.getAvatarDownloadUrl(id, path);
}