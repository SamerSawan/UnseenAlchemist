extends Control

@onready var dash_potion_recipe = $NinePatchRect/GridContainer/DashPotionRecipe
@onready var invis_potion_recipe = $NinePatchRect/GridContainer/InvisPotionRecipe
@onready var noise_potion_recipe = $NinePatchRect/GridContainer/NoisePotionRecipe
@onready var smoke_potion_recipe = $NinePatchRect/GridContainer/SmokePotionRecipe
@onready var slime_potion_recipe = $NinePatchRect/GridContainer/SlimePotionRecipe
@onready var statue_potion_recipe = $NinePatchRect/GridContainer/StatuePotionRecipe
@onready var sleepy_potion_recipe = $NinePatchRect/GridContainer/SleepyPotionRecipe
@onready var strength_potion_recipe = $NinePatchRect/GridContainer/StrengthPotionRecipe

var item : InventoryItem

func _on_strength_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false


func _on_sleepy_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false


func _on_statue_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false


func _on_slime_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false


func _on_smoke_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false


func _on_noise_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false


func _on_invis_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false


func _on_dash_potion_recipe_button_down():
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false
