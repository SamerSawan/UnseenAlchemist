extends Control

@onready var dash_potion_recipe = $NinePatchRect/GridContainer/DashPotionRecipe
@onready var invis_potion_recipe = $NinePatchRect/GridContainer/InvisPotionRecipe
@onready var noise_potion_recipe = $NinePatchRect/GridContainer/NoisePotionRecipe
@onready var smoke_potion_recipe = $NinePatchRect/GridContainer/SmokePotionRecipe
@onready var slime_potion_recipe = $NinePatchRect/GridContainer/SlimePotionRecipe
@onready var statue_potion_recipe = $NinePatchRect/GridContainer/StatuePotionRecipe
@onready var sleepy_potion_recipe = $NinePatchRect/GridContainer/SleepyPotionRecipe
@onready var strength_potion_recipe = $NinePatchRect/GridContainer/StrengthPotionRecipe

var ClumpOfMoss = preload("res://Inventory/inventoryItems/ClumpOfMoss.tres") 
var DarkShroom = preload("res://Inventory/inventoryItems/DarkShroom.tres") 
var DeadMouse = preload("res://Inventory/inventoryItems/DeadMouse.tres") 
var GunpowderPouch = preload("res://Inventory/inventoryItems/GunpowderPouch.tres")
var MagicalBranch = preload("res://Inventory/inventoryItems/MagicalBranch.tres")
var VialOfGoo = preload("res://Inventory/inventoryItems/VialOfGoo.tres")

var item : InventoryItem
var ingr1 : InventoryItem
var ingr2: InventoryItem
var is_open = false
var inventory = preload("res://Inventory/player_inventory.tres")
var hotbar = preload("res://Inventory/HotBar.tres")

func _ready():
	close()

func _process(_delta):
	if Input.is_action_just_pressed("OpenCrafting"):
		if is_open:
			close()
		else:
			open()

func close():
	visible = false
	is_open = false

func open():
	visible = true
	is_open = true



func _on_strength_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false

	item = preload("res://Inventory/inventoryItems/StrengthPotion.tres")
	ingr1 = DeadMouse
	ingr2 = DeadMouse


func _on_sleepy_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false
	
	item = preload("res://Inventory/inventoryItems/SleepPotion.tres")
	ingr1 = VialOfGoo
	ingr2 = ClumpOfMoss


func _on_statue_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false
	
	item = preload("res://Inventory/inventoryItems/StatuePotion.tres")
	ingr1 = MagicalBranch
	ingr2 = GunpowderPouch


func _on_slime_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false
	
	item = preload("res://Inventory/inventoryItems/SlimePotion.tres")
	ingr1 = VialOfGoo
	ingr2 = VialOfGoo


func _on_smoke_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false
	
	item = preload("res://Inventory/inventoryItems/SmokePotion.tres")
	ingr1 = DarkShroom
	ingr2 = GunpowderPouch


func _on_noise_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	invis_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false
	
	item = preload("res://Inventory/inventoryItems/NoisePotion.tres")
	ingr1 = DeadMouse
	ingr2 = GunpowderPouch

func _on_invis_potion_recipe_button_down():
	dash_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false
	
	item = preload("res://Inventory/inventoryItems/InvisPotion.tres")
	ingr1 = VialOfGoo
	ingr2 = DarkShroom

func _on_dash_potion_recipe_button_down():
	invis_potion_recipe.button_pressed = false
	noise_potion_recipe.button_pressed = false
	smoke_potion_recipe.button_pressed = false
	slime_potion_recipe.button_pressed = false
	statue_potion_recipe.button_pressed = false
	sleepy_potion_recipe.button_pressed = false
	strength_potion_recipe.button_pressed = false
	
	item = preload("res://Inventory/inventoryItems/DashPotion.tres")
	ingr1 = MagicalBranch
	ingr2 = ClumpOfMoss


func _on_craft_button_pressed():
	if inventory.remove(ingr1):
		if inventory.remove(ingr2):
			hotbar.insert(item)
			SignalBus.potion_crafted.emit()
			close()
			SignalBus.close_inventory.emit()
			SignalBus.potion_changed.emit() #UPDATES INV PROPERLY FROM THROWER (fixes scroll bug)

		else:
			inventory.insert(ingr1)
	
