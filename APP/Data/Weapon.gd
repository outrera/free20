# WEAPON COMPONENT

extends "res://Data/Item.gd"

const ONE_HANDED = 0
const TWO_HANDED = 1
const VERSITILE = 2

#onready var owner = get_parent()
# Paperdoll texture
export(Texture) var doll_texture = null

# Normal or versitile 1h damage
export(String) var damage = "1d6"
# Versitile 2d damage
export(String) var damage2h = "1d6"
# Enchantment bonus
export(int,-5,5) var enchantment = 0

# Finesse weapon?
export(bool) var finesse = false
# Reach weapon?
export(bool) var reach = false

# Handedness
export(int, "One-handed", "Two-handed", "Versitile") var handedness = 0
# Proficiency class
export(int, "Simple", "Martial") var prof_class = 0
# Weight class
export(int, "Normal", "Light", "Heavy") var weight_class = 0
# Damage type
export(int, "Bashing", "Slashing", "Piercing") var damage_type = 0
# Missile type (or none)
export(int, "None", "Thrown", "Projectile") var missile_type = 0
# Missile range
export(int) var missile_range = 0

func is_versitile():
	return self.handedness == VERSITILE


func get_damage( dmg2h=false ):
	var D = self.damage2h if dmg2h else self.damage
	var s = Array(D.split("d"))
	var r = []
	for i in s:
		r.append(int(i))
	return r

func get_attack_mod():
	return self.enchantment

func get_damage_mod():
	return self.enchantment

	
	
func roll_damage():
	var r = get_damage()
	return RPG.roll(r[0],r[1])




