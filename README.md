TP-LINK-Remote-Management
=========================

Multiple Batch scripts designed to control and monitor most TP-Link Routers through cURL.

######Tested on TD-W8950ND V2 and TD-W8960N V5.

####1. Interactive Router Control:

- It's an interactive batch script has the ability to:

* Reboot Router
* Change/Renew IP
* Disable/Enable Wireless AP

####2. Monitor WAN Statistics:

 **Make sure to create a Basic Task in the Task Scheduler to run "Track WAN Statistics.bat" every X mins.**

- Consists of 2 batch scripts used to monitor WAN Service (Internet Traffic) Bandwidth consumption.

* *Track WAN Statistics.bat* : Fetch and save logged traffic then reset the statistics counter.

* *View Statistics.bat* : View saved data in Gigs and Megs
