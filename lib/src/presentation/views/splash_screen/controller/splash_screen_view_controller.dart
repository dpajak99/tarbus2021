import 'dart:async';
import 'dart:convert';

import 'package:tarbus2021/src/app/app_consts.dart';
import 'package:tarbus2021/src/model/api/repository.dart';
import 'package:tarbus2021/src/model/api/response/response_last_updated.dart';
import 'package:tarbus2021/src/model/api/response/response_welcome_dialog.dart';
import 'package:tarbus2021/src/model/api/response/response_welcome_message.dart';
import 'package:tarbus2021/src/model/database/database_helper.dart';
import 'package:tarbus2021/src/model/entity/app_start_settings.dart';
import 'package:tarbus2021/src/utils/connection_utils.dart';
import 'package:tarbus2021/src/utils/json_databaase_utils.dart';
import 'package:tarbus2021/src/utils/shared_preferences_utils.dart';

enum ScheduleStatus { actual, old, noConnection }

class SplashScreenViewController {
  ScheduleStatus scheduleStatus;
  ResponseLastUpdated lastUpdated;
  AppStartSettings settings;

  SplashScreenViewController();

  Future<ResponseLastUpdated> getLastUpdateDate() async {
    return await DatabaseHelper.instance.getLastSavedUpdateDate();
  }

  Future<ResponseWelcomeMessage> getWelcomeMessage() async {
    return await Repository.getClient().getWelcomeMessage();
  }

  Future<ResponseWelcomeDialog> getAlertDialog() async {
    return await Repository.getClient().getAlertDialog();
  }

  Future<bool> setSettingsOffline() async {
    settings = AppStartSettings();
    settings.lastUpdated = await getLastUpdateDate();
    settings.welcomeMessage = ResponseWelcomeMessage.offline();
    settings.hasDialog = false;
    settings.isOnline = false;
    scheduleStatus = ScheduleStatus.noConnection;
    return false;
  }

  Future<bool> setSettingsOnline() async {
    settings = AppStartSettings();
    settings.lastUpdated = await getLastUpdateDate();
    settings.welcomeMessage = await getWelcomeMessage();
    settings.dialogContent = await getAlertDialog();
    if (settings.dialogContent == null || settings.dialogContent.id == 0) {
      settings.hasDialog = false;
    } else {
      settings.hasDialog = !await SharedPreferencesUtils.checkIfExist(AppConsts.SharedPreferencesDialog, settings.dialogContent.id.toString());
    }
    settings.isOnline = true;
    return true;
  }

  Future<bool> init() async {
    if (!await ConnectionUtils.checkInternetStatus()) {
      return setSettingsOffline();
    } else {
      return setSettingsOnline();
    }
  }

  Future<ScheduleStatus> checkForUpdates() async {
    if (scheduleStatus == ScheduleStatus.noConnection) return ScheduleStatus.noConnection;
    var remoteLastUpdate = await Repository.getClient().getLastUpdateDate();
    var localLastUpdate = settings.lastUpdated;
    lastUpdated = remoteLastUpdate;
    if (remoteLastUpdate.equal(localLastUpdate)) {
      return ScheduleStatus.actual;
    }
    return ScheduleStatus.old;
  }

  Future<bool> updateIfExpired() async {
    if (scheduleStatus == ScheduleStatus.noConnection) return false;
    if (scheduleStatus == ScheduleStatus.actual) {
      return true;
    } else {
      if (await DatabaseHelper.instance.clearAllDatabase()) {
        String newDatabaseString = await Repository.getClient().getNewDatabase();
        JsonDatabaseUtils dbResponse = JsonDatabaseUtils.fromJson(jsonDecode(newDatabaseString));
        DatabaseHelper.instance.updateScheduleDate(lastUpdated);
        settings.lastUpdated = lastUpdated;
        return dbResponse.operationStatus;
      }
    }
    return false;
  }
}
