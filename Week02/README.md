# Week 02 README

I decided to stick with Struct.

I didn't see a reason to use Class, as we don't really need more than one instance of the game.

What I absolutely *would* change, though, is the `mutating` method in the refactored BullsEye. It doesnt' feel right to use a mutating func. I'd rather solve it with parameters. Not quite sure yet how, but thinking about it :]