# Flows for APEX - Model and run process flows all within Oracle APEX

This github repository is for developers willing to contribute to the upcoming version of Flows for APEX.

## Resources you might find useful

- [Demo and Packaged App](https://apex.mt-ag.com/flowsforapex)
- [Introductory video](https://youtu.be/q77HqPuVN7s)
- [Introductory slides](https://knowledgebase.mt-ag.com/q/flowsforapex)
- [Introductory blog post](https://nielsdebr.blogspot.com/2020/06/flows-for-apex.html)
- [Documentation](https://mt-ag.github.io/apex-flowsforapex/)

## How to contribute as a developer to this project

1. Clone/fork the repository apex-flowsforapex to get your own copy.
2. Create a workspace with the ID 2400405578329584.
   For this you will need your own APEX environment.
3. Run /src/install_all_dev.sql.  
   When prompted enter the parameters.  
   This will install all DB-Objects and the application with fixed ID 100.  
   Make sure you have Application ID 100 free for this.
4. Make your changes in the app and/or db objects.
5. Commit your changes in your own branch.  
   Preferable a dedicated branch for the feature you're working on.
6. Send in a pull request for review.  
   We will then verify the changes before accepting the pull request.  
   We might ask you to update your pull request based on our findings.

**Some important rules:**

1. Retain Workspace ID and Application ID, otherwise each and every file of the application export will be marked as changed.  
   Easiest way to achieve this is to use the provided development install script mentioned above.
2. Always enable "Export as ZIP" and "Export with Original IDs".

## Getting in touch

Communication for this project is done using [Slack](http://flowsforapex.slack.com).  
Send a DM on Twitter to [Niels de Bruijn (@nielsdb)](https://twitter.com/nielsdb?s=20) to get involved.
