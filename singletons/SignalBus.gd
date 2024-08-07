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
signal potion_used
signal close_inventory
signal inventory_reset
signal craft_menu_visibility_changed
signal update_drinkability
var item
var equipped_potion
#the signals are all kinds of messed up, defo some dupes that serve the same purpose

#potion effects
signal is_slept
signal is_awake
signal is_slowed
signal not_slowed
signal activate_strength
signal deactivate_strength
signal activate_dash
signal activate_invis
signal activate_statue
signal statue_disabled

signal music_level_fade_in
signal music_level_fade_out
