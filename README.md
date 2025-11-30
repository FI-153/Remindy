# Remindy
A fast and miminalist reminder app that interprets what you want, directly in the Menu Bar

![153](https://github.com/FI-153/Remindy/blob/f4f0ada0f5525ea54d3123fd1db1de24f41428fd/githubAssets/githubImage.png)

## 🤨 Why?
Opening Reminders or talking to Siri is too distracting if i am in deep work but sometimes a tought comes to my head that i wanto to think about later in the day. So I built this utility that is always available in the menu bar. 
- Add Reminder and notes fast;
- Use natural language;
- Immediatelly see what reminders you have set a notification for.

## 📦 Installation (Homebrew)
You can install this easily using Homebrew as a cask.
### 1. Add the tap
```bash
brew tap FI-153/tap
```
### 2. Install the cask
```bash
brew install remindy
```
### 3. Updating
To update just use 
``` bash
brew update && brew upgrade quicknetstats
```

## 🛠️ Build from Source
Can clone this repo, open the project in Xcode and build the app from scratch. If you considered this route you probably don't need more instruction!

## 💡 Features & Usage
Opening the app displays a bell icon in the menu bar. By holding `cmd` you can use the mouse to drag the app to your preferred position in the menu bar. 

> [!NOTE]
> If you are using some utilities like Bartender it may have hidden the app, so you may want to access Bartender's settings to display it.

### Main View
You are presented with a textbox to write notes and reminders and under it a list of reminders. By clicking on the bell you can toggle the notification on or off
for this reminder. The reminders with a bell on the right can be reminded. 

### Notification Status
When the bell and the date are not colored then there is no notification

![Remindable Reminder](https://github.com/user-attachments/assets/3ba83ad2-89be-4e77-86cf-b612d5ee5a2a)

Otherwise a notification will be delivered at the specified time

![Normal Reminder with Notification](https://github.com/user-attachments/assets/9209ccaa-a807-4d16-a2a5-b666b6636421)

### Writing a reminder
The structure of new entry is divided in three parts as follows:
| A | B | C |
| ------------- | ------------- | ------------- |
| Text of the note | `,` | Notification time |

If you don't want to set a notification you can skip **B** and **C**.

### Accepted Natural-Language Times
Here is a description of accepted natural-language times to set a reminder

| Intent | Description | Examples |
| :--- | :--- | :--- |
| Relative Day + Time | Matches "today" or "tomorrow" followed by a 12-hour time format. Minutes are optional. | "Today at 5 pm", "tomorrow at 12.30 am", "Today at 4pm" |
| N Days + Time | Matches a specific number of days in the future (1-99) combined with a specific time. | "in 2 days at 4 pm", "in 1 day at 9:00 am" |
| Countdown (Min) | Matches a relative countdown in minutes (1-999). | "in 10 minutes", "in 1 minute" |
| Countdown (Hour) | Matches a relative countdown in hours (1-999). | "in 2 hours", "in 1 hour" |

### Clearing a Reminder
To clear a reminder you can tap on the circle on the left of the title.

### Settings
From the settings screen you can customize the appearence of the app and clear all the reminders.

![Settings View](https://github.com/user-attachments/assets/2ef58efe-47f3-4774-a424-283b386d20ac)


## 🛠️ Contributing
Contributions are welcome! To contribute:
- Fork the repository and create your branch;
- Make your changes with clear commit messages;
- Open a pull request describing your changes.
