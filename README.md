# PawPal

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

PawPal is an iOS application designed to help new puppy owners organize and track their pets' daily routines. Raising a puppy involves managing several responsibilities, including feeding, potty breaks, grooming, and other care activities. PawPal provides a simple and convenient way to keep track of these tasks in one place.

The app allows users to create a profile for their puppy, add daily care activities, mark tasks as completed, and review their activity history. PawPal aims to make puppy care more organized, especially for first-time pet owners who are still learning how to establish a consistent routine.

### App Evaluation

- **Category:** Lifestyle / Pet Care
- **Mobile:** PawPal is designed for mobile devices because puppy owners often need to record activities throughout the day. Users can quickly log care tasks from their phones, with optional features such as photo selection and notifications.
- **Story:** New puppy owners may struggle to remember feeding times, potty breaks, grooming activities, and other responsibilities. PawPal helps them organize this information and maintain a more consistent care routine.
- **Market:** The target audience includes first-time puppy owners, households with young dogs, and pet owners who want a simple way to organize their puppies' daily care.
- **Habit:** Users can interact with PawPal several times per day to check upcoming activities, record completed tasks, and review their puppy's routine.
- **Scope:** The initial version will focus on creating a puppy profile, tracking daily activities, marking tasks as completed, and viewing activity history. Additional features may be implemented if time allows.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must Have Stories**

- [ ] User can create and edit a puppy profile with basic information such as name, age, and breed.
- [ ] User can view a list of daily puppy care activities.
- [ ] User can add a new activity by selecting a category, date, and time.
- [ ] User can mark an activity as completed.
- [ ] User can view a history of completed activities.

**Optional Nice to Have Stories**

- [ ] User can upload a profile picture of their puppy from the photo library.
- [ ] User can receive notifications reminding them of scheduled activities.
- [ ] User can track their puppy's weight over time.
- [ ] User can share their puppy's care information with another caregiver.

### 2. Screen Archetypes

**Home Screen**
- User can view today's puppy care activities.
- User can see which activities are pending or completed.
- User can select an activity to view its details.
- User can navigate to the Add Activity screen.

**Activities Screen**
- User can view all puppy care activities.
- User can select an activity to view its details.
- User can navigate to the Add Activity screen.

**Add Activity Screen**
- User can select an activity category, such as feeding, potty breaks, or grooming.
- User can choose a date and time.
- User can add optional notes and save the activity.

**Activity Detail Screen**
- User can view information about a selected activity.
- User can mark an activity as completed.

**History Screen**
- User can view previously completed activities.
- User can select an activity to view its details.

**Profile Screen**
- User can view their puppy's profile information.
- User can navigate to the Edit Profile screen.

**Edit Profile Screen**
- User can enter or update their puppy's name, age, and breed.
- User can save profile changes.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

- Home
- Activities
- History
- Profile

**Flow Navigation** (Screen to Screen)

- Home → Add Activity
- Home → Activity Detail
- Home → Activities, History, or Profile using the bottom navigation bar
- Activities → Activity Detail
- Activities → Add Activity
- Add Activity → Activities after saving an activity
- Add Activity → Home using the back button
- Activity Detail → Activities using the back button
- Activity Detail → History after marking an activity as completed
- History → Activity Detail
- Profile → Edit Profile
- Edit Profile → Profile after saving changes or using the back button

## Wireframes

The following hand-drawn low-fidelity wireframes illustrate PawPal's seven main screens, their key interface elements, and the navigation flow between screens.

The sketches show the basic layouts for Home, Activities, Add Activity, Activity Detail, History, Profile, and Edit Profile. The navigation diagram illustrates how users move between the main tabs and secondary screens.

**Hand-Drawn Wireframes**

![Hand-Drawn Wireframe 1](3.jpeg)

![Hand-Drawn Wireframe 2](2.jpeg)

**Navigation Flow Diagram**

![PawPal Navigation Flow](WhatsApp%20Image%202026-11-01%20at%201.03.11%20AM.jpeg)

### [BONUS] Digital Wireframes & Mockups

We created seven digital mockups in Figma to visualize PawPal's user interface. The designs use a consistent color palette, activity cards, simple forms, and a bottom navigation bar to make daily puppy care easy to manage.

**Home Screen**

![Home Screen](Home.png)

**Activities Screen**

![Activities Screen](Activities.png)

**Add Activity Screen**

![Add Activity Screen](Add%20Activity.png)

**Activity Detail Screen**

![Activity Detail Screen](Activity%20Detail.png)

**History Screen**

![History Screen](History.png)

**Profile Screen**

![Profile Screen](Profile.png)

**Edit Profile Screen**

![Edit Profile Screen](Edit%20Profile.png)

### [BONUS] Interactive Prototype

We created an interactive prototype in Figma to demonstrate how users would navigate through PawPal and interact with its main features.

The prototype demonstrates:

- Navigating between Home, Activities, History, and Profile using the bottom tab bar.
- Opening the Add Activity form and returning to the Activities screen after saving.
- Selecting an activity to view its details.
- Marking an activity as completed and navigating to History.
- Opening Edit Profile and returning to Profile after saving changes.
- Using back buttons to return to previous screens.

**Prototype Video**

[Watch the PawPal Interactive Prototype](https://youtube.com/shorts/56_4BqYvuUc?feature=share)

The interactive prototype demonstrates the intended user experience. Data entry and activity updates are simulated and will be implemented during later development milestones.

## Schema

### Models

(To be completed during the development planning milestone.)

### Networking

(To be completed if networking is required.)
