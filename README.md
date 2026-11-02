Blueprint:

Player is a small AI core located in a futuristic underground lab. 
The player can possess stunned enemies and use their abilities to clear levels and work their way up the floors of the 
lab to the surface. 

Structure:

Enemies/Players both share the same health system, using reusable nodes like a health controller or whatever. 
health is split into health and armor/stun meter. Different abilities deal damage to both health and stun in different amounts
Use resources like DamagePayload to define the damage so I don't have to code as much. USE RESOURCES AS MUCH AS POSSIBLE
Different enemies can inherit from a base enemy class to reuse as much code as possible. 