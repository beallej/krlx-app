Project: KRLX

Client: Ibrahim Rabbani

Team members: Josie Bealle, Phuong Dinh, Maraki Ketema and Naomi Yamamoto

CS342 Mobile Application Development Final Project (Spring 2015)

Description of KRLX: KRLX is a iOS-based application (an application version of KRLX website). KRLX live streams KRLX Carleton radio and pulls articles from the website and displays them in a readable way. 
It will also integrate social media sharing options for the content, shows schedule of radio shows, displays which show is currently playing and have a playing song history of 5 most recently heard songs. 
The goal of creating this application is to enable more students enjoying and accessing KRLX radio, hence giving KRLX more listeners.

Instruction to install:

* When you clone the project, the Google Calendar API key will be missing. You will need to add a new file in the directory (folder KRLX) named GoogleCalCredentials.txt. The text contains only the API key. Then, drag the file into the Project Navigator in Xcode (The folder tab under the left menu, that lists all of the files in a hierarchical layout).
We use a SidebarMenu library (created by Simon Ng), libxml2 and Swift-HTML-Parser (by TID) which will be installed as you download and pull the repository.
We did not write any files in the SWRevealViewController folder or Swift-HTML-Parser directories.

* Also, since KRLX does not stream during the summer, we have a dummy radio station in our app. To change back to KRLX, go to line 25 in AppDelegate.swift, uncomment that line, and comment the line below.

Other Notes:
* In the summer, KRLX does not stream, so the schedule table may be empty depending on the actions of the calendar creator.
* In NewsTableViewController, ArticleViewController, and RecentlyHeardTableViewController we scrape from the KRLX website. There is some incorrect HTML tagging on the website, and that causes some output (ex "HTML parser error") in the console. We do not have access to the code that creates that out; it is in a library, so we were not able to suppress it.
* The correctness of the recently heard song depends on KRLX's DJ and the website source. We do not have the means and access to ensure the song always match the radio
* KRLX Live stream only works within the Carleton network.

Note to future developers:
* All basic functions are complete and functional. We commented our code extensively following Ibrahim's request.
* If the website structure changes, certain aspects of the project will no longer be valid (News and recently Heard). Future development of this project can attempt to access the Joomla database which will potentially be more stable and fast.