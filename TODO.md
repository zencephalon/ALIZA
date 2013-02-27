Refactor all of this so that concerns are separate, the code is testable, and
state is managed sanely through a state machine instead of instance vars.


1. Give Aliza a daily task list.

-> I should meditate every day.
A> Okay, I will remind you to meditate every day.

2. Personal assistant mode

-> At 8 pm tonight I have a dinner with Viki.
A> I will remind you at 7:00 tonight that you have a dinner with Viki.
