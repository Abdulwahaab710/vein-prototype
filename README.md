# Vein App

## The Problem

In many parts of the world, electricity is not easily accessible, whether because of regional, political, or other types of situations. This causes a major issue for hospitals in many ways; one key problem is that hospitals cannot store blood. Blood that is frozen in blood banks can be [used for up to 10 years](https://thebloodconnection.org/products-services/laboratory-services/frozen-blood-program/), but unfrozen blood in emergency medicine can typically only be kept [at room temperature for 24-72 hours](https://www.ncbi.nlm.nih.gov/pubmed/17958534) before becoming unsafe to use in a medical procedure. This means that hospitals rely on active donors to be readily available to donate blood on-demand. 

Yemen, a country of over 27 million people, is a country that faces this issue of electricity. How can individuals set themselves up as donors? 

## The Solution
Enter **Vein**, a web app which allows donors to match with recipients in the same region on-demand. 

## How it Works

### Registration

Any user can register with the following information:

* Identification - their username is their phone number, since email is less common in this area.
* Personal information - first name, last name, other forms of additional info to describe the individual.
* Region - one region can host multiple hospitals. A user's region determines the hospitals at which they can either give or receive blood.
* Blood type - this value should be stored and verified by a medical institution for authenticity. This is the most important piece of information along with the user's region and phone ID.

### Preparing to donate/receive

As a user, you log in and simply choose whether you wish to be a donor or recipient. Regardless of which type, you’re placed in a queue for the blood types that are compatible for you. For example, if you’re a recipient and AB+ type, you’re in the queue for all blood types for your region. If you're a donor and O+, you'll be added to all queues for all positive (+) blood types for your region.  
Once you change your status, will be notified via SMS when a match is found.

### Matching

When a donor and recipient for the proper blood type compatibility are matched, both parties receive an SMS message with the following information:
* The ID of your match
* The hospital to which you must meet for the transfusion.

Once the transfusion is complete, the hospital, which will have been notified of the match, will notify our system that the transfusion is complete, and we will reset both users' statuses to Inactive.

## Technical challenges/Learning outcomes
* **Encouraging users to re-apply as donors:** after a user donates blood, they should [wait 8-16 weeks before donating again](https://www.redcrossblood.org/faq.html). However, after this time period, they may forget to re-register. We decided to re-enrol donors as soon as they hit the 16-week mark and implement a notification system that notifies the user three times: right after donating, a warning at the 8-week mark, and a notification at the 16-week mark. At any point in time, the user can remove themselves from the list through the app, but by default they are re-enrolled.
* **Relationship between recipients and donors:** since any user can apply to either be a recipient or a donor, it was tricky to build a data model which accommodated in fact three user states: Recipient, donor, and inactive. There were some states in which a user could register as both a recipient and a donor, which would not realistically ever be the case. We built a verifier in the background which would check if the donor/recipient status was set and prevent users from crossing over unless they un-enrolled from their previous state.
* **Dealing with high-quantity requests for blood:** We learned that the amount of blood required recipient will vary greatly, and one donor may not be able to donate the whole quantity ([typically blood services only take 1 pint of blood](https://blood.ca/en/blood/faqs-whole-blood-donations)) . We set it up so that a recipient who reaches the top of the list will receive blood from the next x number of individuals until their necessary amount is reached.
* **Bringing the hospitals into the equation:** even though this app simplifies the process of matching a blood donor with someone in need we thought about the realism of having any two strangers on the internet be given each other's phone number. We also realized that the hospitals are key players in this interaction as well, since they are the ones that actually handle the transfusion. We therefore decided to limit hospitals to two functions: first, to certify a user's blood type, and second, to return whether or not the blood was successfully retrieved for the recipient. 

## Where to next?

* First, we need to work with the medical institutions in the area so that we can store and handle users' personal data, particularly blood type, securely and in compliance with local regulations. If this project takes off in Yemen, it could potentially be scaled to support other remote areas without easy access to blood, even within North America. The biggest issue with scaling would be to ensure that our platform supports international health legislations like HIPAA in the United States as well. 
