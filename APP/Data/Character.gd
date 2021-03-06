extends "res://Data/Actor.gd"


 ############################
 #	CHARACTER CLASS			#
 #	inherits Creature		#
 ############################

signal xp_changed()

# eXperience Points earned
export(int) var XP = 0 setget _set_XP

# Base Creature Level 
# ( Class levels are added to get total level )
export(int) var base_level = 1


# EQUIPMENT
export(String) var weapon = "dagger"
export(String) var armor = "leather"





func get_XP_needed_for_level( what ):
	pass

# Get Creature total level
func get_total_level():
	return self.base_level


func get_weapon():
	return Database.get_weapon( self.weapon )

func get_armor():
	return Database.get_armor( self.armor )


# Get proficiency bonus
func get_proficiency():
	var l = self.get_total_level()
	return 2 + int( ( l - 1 ) / 2 )

func get_melee_attack_mod(proficient=true, use_dex=false):
	var prof = get_proficiency() if proficient else 0
	var bonus = 0
	if self.weapon:
		var weapon = self.get_weapon()
		bonus = weapon.get_attack_mod()
	var abil = self.get_dex_mod() if use_dex else self.get_str_mod()
	return prof + abil

func get_melee_attack_damage( use_dex=false ):
	var dice = [ 1,4 ]
	var bonus = 0
	if self.weapon:
		var weapon = self.get_weapon()
		dice = weapon.get_damage()
		bonus = weapon.get_damage_mod()
	var abil = self.get_dex_mod() if use_dex else self.get_str_mod()
	return {
		'dice':	dice,
		'mod':	bonus + abil
		}

# Get AC
func get_armor_class():
	var ac = 10	# base AC if no armor
	var dex = self.get_dex_mod()
	if self.armor:
		var armor = self.get_armor()
		ac = armor.get_AC()
		if armor.weight_class == 2:	# medium armor
			dex /= 2
		elif armor.weight_class == 3:	# heavy armor
			dex = 0
	return ac + dex

# Set XP
func set_XP(what):
	self.XP = what

# Get XP
func get_XP():
	return self.XP

# Sum HP log
func calculate_total_hitpoints():
	var total = 0
	for v in self.HP_log:
		total += v
	return total


# Roll a HD and add CON mod
# return a minimum of 1
func roll_HD():
	var con = self.get_con_mod()
	var roll = RPG.roll( con, _get_HD_dice() ).total
	return max( 1, roll )


# Populate the HP log with 
# HD rolls. Should only be 
# done with a "fresh" Creature.
func create_HP_log():
	for i in range( self.get_total_level() ):
		HP_log.append( self.roll_HD() )


func _ready():
	self.create_HP_log()
	self.set_max_HP( self.calculate_total_hitpoints() )

func _set_XP( what ):
	XP = what
	emit_signal("xp_changed")

func _get_HD_dice():
	# Converts "1d6" to [1,6]
	var s = Array(self.HD.split("d"))
	var r = []
	for i in s:
		r.append(int(i))
	return r
