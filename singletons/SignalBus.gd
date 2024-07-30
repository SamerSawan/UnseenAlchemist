extends Node

signal display_dialogue(text_key)
signal change_scene
signal deathzone
signal player_died
signal jump_buffer
signal coyote_jump
signal box_pushing
signal respawn

signal stealth_entered
signal stealth_exited

signal anim_state_change
signal shoot_anim_windup
signal shoot_anim_throw


#inventory related
signal player_pickup
signal update_inventory
signal potion_changed
signal potion_crafted
var item
var equipped_potion
