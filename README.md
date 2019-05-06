# ![](https://raw.githubusercontent.com/Sublivion/RocketSys/master/RocketSys.png) RocketSys III
![Release](https://img.shields.io/github/tag-date/sublivion/rocketsys.svg?style=flat-square) ![Last commit](https://img.shields.io/github/last-commit/sublivion/rocketsys.svg?style=flat-square) ![MIT license](https://img.shields.io/github/license/sublivion/rocketsys.svg?style=flat-square) ![Open issues](https://img.shields.io/github/issues/sublivion/rocketsys.svg?style=flat-square) ![Closed issues](https://img.shields.io/github/issues-closed/sublivion/rocketsys.svg?style=flat-square) ![Contributors](https://img.shields.io/github/contributors/sublivion/rocketsys.svg?style=flat-square) ![Code size](https://img.shields.io/github/languages/code-size/sublivion/rocketsys.svg?style=flat-square) ![Discord](https://img.shields.io/discord/530216666416807947.svg?style=flat-square)

### [Website](https://sublivion.github.io/RocketSys/) | [Documentation](https://sublivion.github.io/RocketSys/)
---
###### Note: RocketSys III is currently under development and is not yet released

## What's RocketSys?
RocketSys is a simple object-orientated API for launching rockets in Roblox featuring real world physics equations. Don't worry if you're not a coder though - we've provided many examples and rocket presets in the repository. You can find tutorials and documentation on [our website](https://sublivion.github.io/RocketSys/). @Sublivion - who founded the project at the beginning of 2019 - codes the API and other developers are working on presets and example scripts.

## Aims
- The original Rocket System aims: allow everyone to simulate realistic rocket and missile launches in Roblox games
- Provide a better and less limited experience than its predecessor: RocketSys II

## Tutorial
###### This tutorial may require some prior studio and scripting knowledge and beginners may find it difficult. A more thorough and easier tutorial with better methods will soon be uploaded to the website. If you are unsure, ask in the #help channel of the discord server (not in DMs).
#### Step 1: Installing the system
- Create a folder in ServerScriptService called "RocketSysIII"
- Inside, create a script called MainModule
- Copy and paste the contents of [this script](https://github.com/Sublivion/RocketSys/blob/master/src/MainModule.lua) inside
![](https://i.gyazo.com/73f5ea935b291eeca394efda2464faa7.png)

#### Step 2: Configuring your rocket
- Each stage must be in its own model
- The model for each stage must have its PrimaryPart property set to a part in the middle of the rocket
- The PrimaryPart must have its top face pointing upwards, or towards the direction of travel
- All special effects that occur when the engines are on (e.g. smoke, sound) should be inside the PrimaryPart and should be disabled
- There should be a gray box that is visible when you select the model around the part that is the PrimaryPart
- Anchor everything
- If you're unsure, download the [demo rocket](https://github.com/Sublivion/RocketSys/blob/master/examples/DemoRocket.rbxm) that I used while developing the system
![](https://i.gyazo.com/5b1696712e558694a410f03cb9c20b71.png)

#### Step 3: Making your rocket go
3A: Preparing the script
- Create a script. This can go anywhere you like, however, it is best practice to put scripts inside ServerScriptService
- I recommend that you copy the [classic script](https://github.com/Sublivion/RocketSys/blob/master/examples/Classic.lua) to start
- However, if you have some scripting knowledge, you can create your own script using the API, which is commented at the top of the MainModule
- Change all the `model` properties of each stage table to the models you created in the last step
- Change the performance stats of your rocket to suit your needs. You can find performance stats for real world rockets that can be used in the system [here](https://github.com/Sublivion/RocketSys/tree/master/presets)
![](https://i.gyazo.com/651e6689a5cdb8fff8a5d2949dbf282b.png)

3B: Controlling the rocket
- At the bottom of the "classic" launch script (lines 46-54), you will see some "commands" that control the throttle and orientation of the rocket
- To make a stage separate at a specific time, use `wait(time)` and then `rocket.stages.The name of your stage:separate`
- The other "commands" include `setOrientationGoal(orientation, time)` and `setThrottle(throttle)`
- Be careful when using setThrottle as throttle should be as a decimal - not a percentage
- In other words, full throttle is 1, half throttle is 0.5, no throttle is 0, and so on
- If you want to make your rocket launch on the click of a button, you will have to put all this code inside of a block that runs when a button is clicked or a remote event is fired
- Soon, extra scripts will be added [here](https://github.com/Sublivion/RocketSys/tree/master/examples). You can use these to do rocket stuff other than launching. For example - tracking the Rocket with a nice UI, adding a launch button, or even performing suicide burn landings for your boosters
![](https://i.gyazo.com/b3827ed8467e914b38307e39da426b12.png)

If you followed all the steps correctly, you should see your rocket fly after you press play!
![](https://i.gyazo.com/b9b8cbb39282810634237a3270a1d2ae.png)

## Community
There is a supportive community surrounding the rocket system. Our discord server consists of a large variety of people - from Roblox game developers to those who model rockets. You can join us [here](https://discord.gg/bqRdNPw).

## Copyright
The RocketSys MainModule is licensed under the [MIT license](https://raw.githubusercontent.com/Sublivion/RocketSys/master/LICENSE). The licenses for other files and their copyright holders are included in the file. The logo is designed by @jobcremers.
