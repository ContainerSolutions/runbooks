---
title: "Debug Vscode View Issues"
summary: "Understand a fix visual changes in Visual Studio Code"
---

## Overview {#overview}

Visual studio code can sometimes get into a state where it's not obvious why the visual appearance has changed, usually as the result of accidentally pressing a key combination.

The problem is that not all settings are visible via the `settings.json` file. Every time you open up a new instance of VSCode there is a secret workspace created that you won't find mentioned in the VSCode documentation. In this, you will find a file called `state.vscdb` which is an SQLite database that stores many different, mostly visual, settings.

## Check RunBook Match {#check-runbook-match}

Use this runbook if you have a visual annoyance in VSCode that only appears when in a certain directory/workspace and not in other VSCode windows.

## Initial Steps Overview {#initial-steps-overview}

1) [Check View/Appearance](#step-1)

2) [Another step](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Check View/Appearance {#step-1}

Often the setting that's change will be one of the options that can be toggled under View -> Appearance.

## Solutions List {#solutions-list}

A) [Clear out all workspace settings](#solution-a)

## Solutions Detail {#solutions-detail}

### A) Clear out all workspace settings {#solution-a}

This is the nuclear option but it is also the easiest if you just want to reset the view back to its defaults.

  1. Simply install the [workspace-cacheclean](https://marketplace.visualstudio.com/items?itemName=MamoruDS.workspace-cacheclean) extension.

  2. Open the command pallet:  
  
     Windows/Linux: `Ctrl+Shift+P`  
     OSX: `⇧⌘P`

  3. Search for `Workspace: Cache Clean` and hit `[Enter]`

  4. Click `Reload` in the popup that is displayed

Everything should now be reset to their defaults.

### B) Investigate the specific change (linux/osx) {#solution-b}

This process is a **lot** more involved, but if you don't wish to reset the entire workspace and really want to track done the specific setting in the VSCode, then this is possibly the only thing left.

  1. Install the [SQLite extension for VSCode](https://marketplace.visualstudio.com/items?itemName=alexcvzz.vscode-sqlite)

  2. To find the path to your current workspace you should close VSCode and reopen it like so:
  `code --verbose /path/to/your/project | grep workspaceStorage`

  3. You should see a path in the output containing the phrase `workspaceStorage` space. This is the path to your temporary workspace. Copy the path.

  4. Open the command pallet:  
  
     Linux: `Ctrl+Shift+P`  
     OSX: `⇧⌘P`

  5. Search for `SQLite: Open Database` and hit `[Enter]`. Then select "choose database from file"

  6. Open the file using the workspace path with `state.vscdb` as the file. For example:
  `/Users/simone/.config/Code/User/workspaceStorage/4ba03951ac493ed2c501dc3cc8cc6237/state.vscdb`

  7. In the explorer view you will find `SQLite Explorer`. Open it can click the play button to the right of the `ItemTable` table.

  8. In the next window that opens click on the `Export json` button at the top right as this will make searching through the data much simpler.

  9. Now you can inspect the actual state settings and search for keywords such as `layout`, `workspace` or anything you think might be related to your problem. If you still can't locate the culprit, you can always open a new project that doesn't display this issue and run the same export of its current state. Then go though and look for differences between these files.

## Authors {#authors}

[@Gerry](https://github.com/gerrywastaken)


[//]: # (REFERENCED DOCS)
[//]: # (Where are breakpoints stored in vscode: https://stackoverflow.com/questions/57767800/where-does-breakpoints-stores)
[//]: # (Workspace storage: https://github.com/microsoft/vscode/search?q=workspaceStorage&type=Code)
