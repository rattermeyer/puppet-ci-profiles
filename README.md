# Profiles
First thought about inheritance. But node inheritance is not recommended.
Then thought of composition. I wanted to compose a node definition from parts or profiles.
So I came up with this profile module. 

# Open issues / Still bothers me
According to my current understanding, I need to have all modules available, that are referenced
from any of the classes contained in this module. This would mean, I need to either rethink my requirement _one module for all profiles, I currently need_ or 
need to find a different way to do it in Puppet

