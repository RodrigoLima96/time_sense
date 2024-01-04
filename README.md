<img src="README_FILES/badges/built-with-love.svg" height="28px"/>&nbsp;&nbsp;
<img src="README_FILES/badges/flutter-dart.svg" height="28px" />&nbsp;&nbsp;
<img src="README_FILES/badges/Flutter-3.svg" height="28px" />&nbsp;&nbsp;
<img src="README_FILES/badges/dart-null_safety.svg" height="28px"/>

# Time Sense
### Time Sense is an innovative app blending the concepts of a Pomodoro timer and task management. Users can create tasks and complete them within Pomodoro intervals, effectively tracking time spent on each task. This fusion allows for efficient task management while monitoring time allocation for increased productivity.

<img src="README_FILES/images/time_sense.png"/>

<p align="center">
  <a href="https://drive.google.com/file/d/1zZAtIJ8nIhoP1kCrMfPjlv867k4dTmPl/view?usp=drive_link">
    <img src="README_FILES/images/apk_download.png" alt="Time Sense" style="display: inline-block; width: 200px;"/>
  </a>
</p>


## Core Features:
* <span style="font-weight:bold; font-size: 18; color: white">Pomodoro Timer: </span> 
<span style="font-weight:600; font-size: 15;">Customizable Pomodoro Cycles. Link tasks to cycles for focused work sessions.</span>

* <span style="font-weight:bold; font-size: 18; color: white">Task Management:</span>
<span style="font-weight:600; font-size: 15;">Users can create, organize, and track time for each task.</span> 

* <span style="font-weight:bold; font-size: 18; color: white">Notification System:</span>
<span style="font-weight:600; font-size: 15;">Alerts users when a Pomodoro session ends.</span> 

* <span style="font-weight:bold; font-size: 18; color: white">User Statistics:</span>
<span style="font-weight:600; font-size: 15;">Users can view their overall focus time, completed tasks, and detailed breakdowns by date.</span> 
<br>


### These combined features can create a comprehensive user experience for individuals seeking to manage their time and productivity using the Pomodoro technique.

<br>

## Dependencies
<details>
     <summary> Click to expand </summary>

* [flutter_localizations](https://pub.dev/packages/flutter_localization)
* [flutter_svg](https://pub.dev/packages/flutter_svg)
* [circular_countdown_timer](https://pub.dev/packages/circular_countdown_timer)
* [provider](https://pub.dev/packages/provider)
* [sqflite](https://pub.dev/packages/sqflite)
* [wakelock](https://pub.dev/packages/wakelock)
* [equatable](https://pub.dev/packages/equatable)
* [uuid](https://pub.dev/packages/uuid)
* [flutter_phoenix](https://pub.dev/packages/flutter_phoenix)
* [intl](https://pub.dev/packages/intl)
* [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
* [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
* [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
* [timezone](https://pub.dev/packages/timezone)
* [flutter_native_timezone_updated_gradle](https://pub.dev/packages/flutter_native_timezone_updated_gradle)
* [permission_handler](https://pub.dev/packages/permission_handler)
* [image_picker](https://pub.dev/packages/image_picker)
* [calendar_date_picker2](https://pub.dev/packages/calendar_date_picker2)
* [flutter_image_compress](https://pub.dev/packages/flutter_image_compress)
* [flutter_animate](https://pub.dev/packages/flutter_animate)

</details>
<br>
<br>

## Directory Structure
<details>
     <summary> Click to expand </summary>

```
lib
│   main.dart
│
└───src
    │   app_widget.dart
    │
    ├───controllers
    │   │   controllers.dart
    │   │   pomodoro_controller.dart
    │   │   settings_controller.dart
    │   │   tasks_controller.dart
    │   │   user_controller.dart
    │   │
    │   └───helpers
    │           helper.dart
    │           helpers.dart
    │           pomodoro_helper.dart
    │           settings_helper.dart
    │           user_helper.dart
    │
    ├───models
    │       models.dart
    │       notification.dart
    │       pomodoro.dart
    │       settings.dart
    │       statistic.dart
    │       task.dart
    │       user.dart
    │
    ├───pages
    │   │   pages.dart
    │   │
    │   ├───home
    │   │   │   home_page.dart
    │   │   │
    │   │   └───widgets
    │   │       │   home_body.dart
    │   │       │   home_buttons.dart
    │   │       │   timer_widget.dart
    │   │       │   widgets.dart
    │   │       │
    │   │       ├───bottomSheet
    │   │       │       home_bottom_sheet.dart
    │   │       │       task_container_bottom_sheet.dart
    │   │       │
    │   │       ├───drawer
    │   │       │       drawer_icon.dart
    │   │       │       home_page_drawer.dart
    │   │       │
    │   │       └───sessions
    │   │               session.dart
    │   │               sessions_widget.dart
    │   │
    │   ├───settings
    │   │   │   settings_page.dart
    │   │   │
    │   │   └───widgets
    │   │           change_notification_option.dart
    │   │           change_setting_value_widget.dart
    │   │           settings_body.dart
    │   │           settings_options_buttons.dart
    │   │           settings_option_widget.dart
    │   │           tasks_status_widget.dart
    │   │           widgets.dart
    │   │
    │   ├───tasks
    │   │   │   tasks_page.dart
    │   │   │
    │   │   └───widgets
    │   │           tasks_list.dart
    │   │           tasks_page_body.dart
    │   │           widgets.dart
    │   │
    │   └───user
    │       │   user_page.dart
    │       │
    │       └───widgets
    │               statistics_by_date_widget.dart
    │               tasks_complete_widget.dart
    │               username_widget.dart
    │               user_body.dart
    │               user_circle_avatar.dart
    │               widgets.dart
    │
    ├───repositories
    │       pomodoro_repository.dart
    │       repositories.dart
    │       settings_repository.dart
    │       task_repository.dart
    │       user_repository.dart
    │
    ├───routes
    │       app_routes.dart
    │       routes.dart
    │
    ├───services
    │   │   services.dart
    │   │
    │   ├───database
    │   │       database_service.dart
    │   │       init_database_service.dart
    │   │
    │   └───notification
    │           notification_service.dart
    │
    └───shared
        ├───utils
        │       constants.dart
        │       utils.dart
        │
        └───widgets
                add_task_widget.dart
                confirm_dialog.dart
                custom_app_bar.dart
                primary_button.dart
                task_focus_time_widget.dart
                task_widget.dart
                total_focusing_time_widget.dart
                widgets.dart
```

</details>
