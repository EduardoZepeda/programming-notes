# English for Developers

The customer's assumptions should be taken in account. It's the
developer responsability to transform the idea to tangible software.
Constant communication is **KEY**.

## Communicate with your customer accurately

### Idea Brainstorming

You could use brainstorming to get some good user requirements.

### User Stories

Are basically individual tasks the software has to do, they are composed
of somaller tasks, they contain a title, a description and a priority
rating. User stories should describe one action, and must be written in
plain simple language. It's very important to break your user stories
into tasks as soon as possible.

-   Nice to have
-   Moderately important
-   Important
-   Urgent

Title Description Priority

Estimates Design Thinking

### Iteration cycles

The sofware is developed in iterations with constant feedback, they
allow you to make quick adjustments. The shorter your iterations are the
chance to catch any problem increases. The processes of an iteration
cycle are the following.

-   Requirements
-   Design
-   Code
-   Test

A full iteration cycle produces working software.

### Estimating the whole project

You can calculate the estimated time by consensus. Developers usually
disagree about estimates. Eliminate assumptions.

### Planning considering priorities

If there is a big difference between the developer's estimated date, and
the client's estimated time, a good approach is to prioritize the user
stories, according to the client's needs.

A good pair of questions to ask:

-   What is the most important piece of functionality to you?
-   What are the first features you would like to see in the design?
-   We believe this User Story is really important. Do you agree?
-   We suggest a 30-day Iteration. Is that ok with you?

### Reaching Consensus in Estimations

The sum of time needed to create all the user stories. *A very good way
to estimate the time is playing planning poker*. Developers should
understand perfectly what the customer wants. If the software needs an
admin interface, if the softwares allows changes in orders.

### Milestones

It is a MAJOR release, a working software must be showed, also you
expect to get paid for it.

## Understand your customer and the requirements

### Achievable development Plan

### Prioritizing with the customer

### Defining Iterations

### VELOCITY- Productive time

Velocity is how fast your team can work, but we need to see it as a
potential time, not full time. You need to take in account sickness,
events, etc.

### Backlog

A big board used to show the pending, in progress and done tasks. It can
be virtual, like monday, trello, jira and similar apps.

### Milestone 1.0

Try to reach it ASAP, and try to iterate one time per month.

## Organize your tasks

### Break user stories into tasks

Breaking user stories adds condifence and accuracy to the time
estimates.

### Use estimates to track your project from inception to completion

You need to track your project from inception to completion.
Comunicating effectively with your client will make him/her trust you.

### Update your backlog

It is very important you keep thebacklog UPDATED. Constant communication
is essential.

### Daily Stand-up meetings

They should last between 5 and 15 minutes, no more.

They are for:

-   Track your progress
-   Update your burn-down rate
-   Update tasks
-   Talk about what happened yesterday and the tasks for today

### Analyze and design

Analyzing and designing your software , and pivoting when necessary is
going to be an Integral part of the Software Development Process.

### Modeling your design

Once you know you need to adjust remember you must adjust your Backlog,
User Stories and Estimates too.

### Burn-Down Rate

The burn-down rate is the velocity of the time when they're going
through the iteration. Usually the velocity is not constant. The main
advantage the Burndown rate gives the team is the possibility to track
the velocity of the team’s performance.If the team is going too slow,
then they need to speed up.If the team is going too fast, they can try
to work on additional User Stories

## Creating a deliverable design

### Refactoring your design

Modifying the structure of the code maintaining its behavior. It allows
you to have cleaner, flexible, extensible and readable code.

### SRP Single Responsability principle

All classes, modules and functions should have one responsability and
one reason to change.

### DRY Don't repeat yourself

Each piece of information in your system must be in ONE place.

### Refactoring & stand up meetings

You have to notify when you refactor your code

### Definition is done

When everything is complete you've definition

-   Finished all your tasks
-   Done your refactoring
-   Done any demos

### Ship out

Your software must have awesome quality and value. Focus on perfection
but deliver working and effective software.

## Protect your very valuable softwares

### Defend your software from yourself and your peers

Once your software is working you need to protect it.

You can use several techniques for this: \* Version Control (Git) \*
Control your dependencies (Test-Drive Development)

### Functional and unit testing

You need to developt tests for your project. There are several testing
frameworks available.

-   Manual Testing
-   Automated testing

Unit testing is all about creating tests that run automatically to test
the smallest components of the code for their business logic.

-   Always exercise your code
-   Let your peers understand your code documenting it

## Understanding Continuous Integration (CI) and testing

### Black-box

Done by users. Only looks for functionality. Users can test the software
from the outside, no database, code, nor algorithm evaluation.

### gray-box

Done by testers. The aspects to test are code, database evaluation,
security risk, memory leaks.

### white-box

Executed by developers. The deepest level of testing.

-   Class designs
-   Duplicate code
-   Branches
-   Error handling
-   Code on code

### Handle accidents when building the code

## CI

Guarantees the reduction in the impact of conflicts by:

-   Continuously submitting working code
-   Use automation software to control changes.
-   Source control emails developers involved in the last change
-   CI wraps version control, compilation and testing into a single
    repetable process

## TTD Test-driven development

Design and write tests first then write code. It's all about moving your
code from red to green. Tests are a must, never skip them.

## Be ready for development

### How to correct and report your Bugs

1)  The tester or somebody find the bugs
2)  The tester files a bug report
3)  You create a story to fix the bug (Your estimates will be affected)
4)  You fix the bug
5)  Review and verify the fix
6)  Update the bug report
7)  Reprioritize your user stories

Getting feedband and recommendations from other developers can truly
make a difference:

-   What do you suggest we do here?
-   What are your thoughts on this?
-   What do you think should be our number one priority?

### Plan your next iteration

It's important to have a standard set of questions to review.

Then the cycle start again 1) Speaking to the customer 2) Analyzing the
requirements 3) Coming up with user stories 4) Estimating user stories
-Learn from your data VELOCITY 5) Playing planning poker 6) Start the
next iteration (sprint)

## Fix your bugs

### The lifecycle of a Bug

Everything resolves about customer-oriented functionality, therefore
only what's broken must be fixed. We must focus on solving those bugs
that impact functionality only.

### Calculate your bug fix ratio

Number of bugs fixed / days

### Spike test

Spike testing is a period in which there is an "explosion" in testing.

1)  Take a week to do your spike test
2)  Pick a random sample from the test that are failing and try to fix
    just those tests

### Continuous Integration Test Delivery Method

Cloud enable fast delivery method for functionality. It must be done as
many times as possible Tested and readable code are the priorities
