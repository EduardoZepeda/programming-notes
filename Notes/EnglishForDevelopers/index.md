# English for Developers

The customer's assumptions should be taken in account. It's the
developer responsability to transform the idea to tangible software.
Constant communication is 



## 1.1 Communicate with your customer accurately

### 1.1.1 Idea Brainstorming

You could use brainstorming to get some good user requirements.

### 1.1.2 User Stories

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

### 1.1.3 Iteration cycles

The sofware is developed in iterations with constant feedback, they
allow you to make quick adjustments. The shorter your iterations are the
chance to catch any problem increases. The processes of an iteration
cycle are the following.

-   Requirements
-   Design
-   Code
-   Test

A full iteration cycle produces working software.

### 1.1.4 Estimating the whole project

You can calculate the estimated time by consensus. Developers usually
disagree about estimates. Eliminate assumptions.

### 1.1.5 Planning considering priorities

If there is a big difference between the developer's estimated date, and
the client's estimated time, a good approach is to prioritize the user
stories, according to the client's needs.

A good pair of questions to ask:

-   What is the most important piece of functionality to you?
-   What are the first features you would like to see in the design?
-   We believe this User Story is really important. Do you agree?
-   We suggest a 30-day Iteration. Is that ok with you?

### 1.1.6 Reaching Consensus in Estimations

The sum of time needed to create all the user stories. *A very good way
to estimate the time is playing planning poker*. Developers should
understand perfectly what the customer wants. If the software needs an
admin interface, if the softwares allows changes in orders.

### 1.1.7 Milestones

It is a MAJOR release, a working software must be showed, also you
expect to get paid for it.

## 1.2 Understand your customer and the requirements

### 1.2.1 Achievable development Plan

### 1.2.2 Prioritizing with the customer

### 1.2.3 Defining Iterations

### 1.2.4 VELOCITY- Productive time

Velocity is how fast your team can work, but we need to see it as a
potential time, not full time. You need to take in account sickness,
events, etc.

### 1.2.5 Backlog

A big board used to show the pending, in progress and done tasks. It can
be virtual, like monday, trello, jira and similar apps.

### 1.2.6 Milestone 1.0

Try to reach it ASAP, and try to iterate one time per month.

## 1.3 Organize your tasks

### 1.3.1 Break user stories into tasks

Breaking user stories adds condifence and accuracy to the time
estimates.

### 1.3.2 Use estimates to track your project from inception to completion

You need to track your project from inception to completion.
Comunicating effectively with your client will make him/her trust you.

### 1.3.3 Update your backlog

It is very important you keep thebacklog UPDATED. Constant communication
is essential.

### 1.3.4 Daily Stand-up meetings

They should last between 5 and 15 minutes, no more.

They are for:

-   Track your progress
-   Update your burn-down rate
-   Update tasks
-   Talk about what happened yesterday and the tasks for today

### 1.3.5 Analyze and design

Analyzing and designing your software , and pivoting when necessary is
going to be an Integral part of the Software Development Process.

### 1.3.6 Modeling your design

Once you know you need to adjust remember you must adjust your Backlog,
User Stories and Estimates too.

### 1.3.7 Burn-Down Rate

The burn-down rate is the velocity of the time when they're going
through the iteration. Usually the velocity is not constant. The main
advantage the Burndown rate gives the team is the possibility to track
the velocity of the team’s performance.If the team is going too slow,
then they need to speed up.If the team is going too fast, they can try
to work on additional User Stories

## 1.4 Creating a deliverable design

### 1.4.1 Refactoring your design

Modifying the structure of the code maintaining its behavior. It allows
you to have cleaner, flexible, extensible and readable code.

### 1.4.2 SRP Single Responsability principle

All classes, modules and functions should have one responsability and
one reason to change.

### 1.4.3 DRY Don't repeat yourself

Each piece of information in your system must be in ONE place.

### 1.4.4 Refactoring & stand up meetings

You have to notify when you refactor your code

### 1.4.5 Definition is done

When everything is complete you've definition

-   Finished all your tasks
-   Done your refactoring
-   Done any demos

### 1.4.6 Ship out

Your software must have awesome quality and value. Focus on perfection
but deliver working and effective software.

## 1.5 Protect your very valuable softwares

### 1.5.1 Defend your software from yourself and your peers

Once your software is working you need to protect it.

You can use several techniques for this: \* Version Control (Git) \*
Control your dependencies (Test-Drive Development)

### 1.5.2 Functional and unit testing

You need to developt tests for your project. There are several testing
frameworks available.

-   Manual Testing
-   Automated testing

Unit testing is all about creating tests that run automatically to test
the smallest components of the code for their business logic.

-   Always exercise your code
-   Let your peers understand your code documenting it

## 1.6 Understanding Continuous Integration (CI) and testing

### 1.6.1 Black-box

Done by users. Only looks for functionality. Users can test the software
from the outside, no database, code, nor algorithm evaluation.

### 1.6.2 gray-box

Done by testers. The aspects to test are code, database evaluation,
security risk, memory leaks.

### 1.6.3 white-box

Executed by developers. The deepest level of testing.

-   Class designs
-   Duplicate code
-   Branches
-   Error handling
-   Code on code

### 1.6.4 Handle accidents when building the code

## 1.7 CI

Guarantees the reduction in the impact of conflicts by:

-   Continuously submitting working code
-   Use automation software to control changes.
-   Source control emails developers involved in the last change
-   CI wraps version control, compilation and testing into a single
    repetable process

## 1.8 TTD Test-driven development

Design and write tests first then write code. It's all about moving your
code from red to green. Tests are a must, never skip them.

## 1.9 Be ready for development

### 1.9.1 How to correct and report your Bugs

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

### 1.9.2 Plan your next iteration

It's important to have a standard set of questions to review.

Then the cycle start again 1) Speaking to the customer 2) Analyzing the
requirements 3) Coming up with user stories 4) Estimating user stories
-Learn from your data VELOCITY 5) Playing planning poker 6) Start the
next iteration (sprint)

## 1.10 Fix your bugs

### 1.10.1 The lifecycle of a Bug

Everything resolves about customer-oriented functionality, therefore
only what's broken must be fixed. We must focus on solving those bugs
that impact functionality only.

### 1.10.2 Calculate your bug fix ratio

Number of bugs fixed / days

### 1.10.3 Spike test

Spike testing is a period in which there is an "explosion" in testing.

1)  Take a week to do your spike test
2)  Pick a random sample from the test that are failing and try to fix
    just those tests

### 1.10.4 Continuous Integration Test Delivery Method

Cloud enable fast delivery method for functionality. It must be done as
many times as possible Tested and readable code are the priorities
