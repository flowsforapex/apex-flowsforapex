# apex-flowsforapex
Flows for APEX - Model and run workflows all within APEX!

This github repository is for developers willing to contribute to the upcoming version of Flows for APEX.

If you are looking for a <b>demo</b> or want to <b>download</b> the packaged app, please go to the website: 

https://apex.mt-ag.com/flowsforapex

Introduction <b>slides</b> can be found here:

https://knowledgebase.mt-ag.com/q/flowsforapex

A <b>video</b> of Flows for APEX v1 can be found at ODTUG (requires a membership):

https://www.odtug.com/p/do/sd/sid=13259

Introduction <b>blog</b> post:

https://nielsdebr.blogspot.com/2020/06/flows-for-apex.html

# How to contribute as a developer to this project
1. Clone/fork the repository apex-flowsforapex to get your own copy
2. Create a workspace with the ID 2400405578329584 (you will need your own APEX environment)
3. Run /src/install_all.sql, enter the parameters and install all db objects together with the application
4. Make your changes in the app and/or db objects
5. Commit your changes in your branch (master branch or in your feature branch when working with multiple developers on it)
6. Send a pull request so we can verify and decide on taking over your changes

<b>Some important rules:</b>
1. Only import the app in the workspace with the ID mentioned above to prevent every file being touched by APEX after exporting it again.
2. Export your APEX app "as ZIP" with the setting "retaining the original IDs" enabled.

Communication for this project is done using http://flowsforapex.slack.com. DM me on Twitter (@nielsdb) to get involved.
