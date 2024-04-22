extends RigidBody2D

var GRAVITY = .667
var BH_MASS = 1000
var PLAYER_MASS = 100

var blackHoleNode = preload("res://Objects/BlackHole.tscn")
var spawnedBlackHoles = 0

var mouseLeftDown
var started
var isSlingshotting
var teleportPos
var teleportAngle
var teleporting

var dead

var startTime
var timeToComplete

var invertedGravity;

@onready var spawnableBlackHoleCheck = get_node_or_null("../../SpawnableBlackHoles")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	$Sprite2D.texture = load(Game.SKIN_PATHS[str(Game.selectedSkinIndex)])
	mouseLeftDown = false
	started = false
	dead = false
	teleporting = false
	invertedGravity = false
	if spawnableBlackHoleCheck:
		spawnableBlackHoleCheck.get_child(3).text = ": " + str(spawnableBlackHoleCheck.get_child(0).name)
	
	
@onready var trail = get_node("Trails/" + str(Game.selectedSkinIndex))
@onready var blackHoles = get_node("../../BlackHoles")
@onready var whiteHoles = get_node("../../WhiteHoles")
@onready var startPos = self.position

func _clampedVector2(vector: Vector2, length: float) -> Vector2:
	var mul = min(vector.length(), length) / vector.length()
	return Vector2(vector.x * mul, vector.y * mul)

func _die():
	if started:
		dead = true
		$deathSFX.playing = true
		$Sprite2D.visible = false
		$Trails.visible = false
		$Explosion.emitting = true
		started = false
		await get_tree().create_timer(1.0).timeout
		restartLevel()
		
func restartLevel():
	get_tree().change_scene_to_file("res://Levels/" + get_tree().current_scene.name.to_lower()+ ".tscn")
	
func completedLevel():
	$impactSFX.playing = true
	self.visible = false
	started = false
	timeToComplete = Time.get_unix_time_from_system() - startTime
	$"../../CompletedGroup".visible = true
	$"../../CompletedGroup/TimeValue".text = str(snapped(timeToComplete, .001)) + " s"
	$"../../CompletedGroup/SpeedValue".text = str(snapped(linear_velocity.length(), .001)) + " m/s"
	
func teleportTo(newPos: Vector2, angle: float):
	$popSFX.playing = true
	teleportPos = newPos
	teleportAngle = angle
	teleporting = true
	
func _integrate_forces(state):
	if teleporting:
		state.transform.origin = teleportPos
		state.linear_velocity = state.linear_velocity.rotated(teleportAngle)
		teleporting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	$Sprite2D.rotation = -1 * self.linear_velocity.angle_to(Vector2(1,0))

func _physics_process(delta):
	
	if started:
		for blackHole in blackHoles.get_children():
			var direction = (blackHole.position - self.position)
			var distance = direction.length()
			
			if (distance > 500):
				continue
			if (distance < 30):
				_die()
				
			
			var force = direction * ((GRAVITY*BH_MASS*PLAYER_MASS)/(distance**2))
			
			if invertedGravity:
				force *= -1
			
			apply_central_force(force)
		
		for whiteHole in whiteHoles.get_children():
			var direction = (whiteHole.position - self.position)
			var distance = direction.length()
			
			if (distance > 400):
				continue
				
			
			var force = -1 * direction * ((GRAVITY*BH_MASS*PLAYER_MASS)/(distance**2))
			
			if invertedGravity:
				force *= -1
			
			apply_central_force(force)
		
		var angle = -1 * self.linear_velocity.angle_to(Vector2(0,1))
		trail.rotation = angle
		var speedScale = clamp(self.linear_velocity.length(), 0, 400) / 400
		trail.modulate.a = speedScale
		trail.speed_scale = speedScale
	
	
func invertGravity():
	invertedGravity = !invertedGravity
	if invertedGravity:
		$"../../GravityBackground".texture = load("res://Assets/GravityBackgroundInverted.jpg")
	else:
		$"../../GravityBackground".texture = load("res://Assets/GravityBackground.jpg")

func _applySlingshotForce():
	var direction = _clampedVector2(self.position - get_global_mouse_position(), 100)
	if direction.length() < 20:
		return
	
	apply_central_force(direction * 200)
	started = true
	startTime = Time.get_unix_time_from_system()
	trail.emitting = true
	

func trySpawnBlackHole():
	if (get_global_mouse_position() - self.position).length() < 100:
		return
	
	if !spawnableBlackHoleCheck:
		return
	
	if int(str(spawnableBlackHoleCheck.get_child(0).name)) <= spawnedBlackHoles:
		return
	
	var blackHoleInstance = blackHoleNode.instantiate()
	blackHoles.add_child(blackHoleInstance)
	blackHoleInstance.position = get_global_mouse_position()
	spawnedBlackHoles += 1
	var bhCountLeft = int(str(spawnableBlackHoleCheck.get_child(0).name)) - spawnedBlackHoles
	spawnableBlackHoleCheck.get_child(3).text = ": " + str(bhCountLeft)

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == 1 and ev.is_pressed():
			trySpawnBlackHole()
			mouseLeftDown = true
			if (not started) && (get_global_mouse_position() - self.position).length() < 50:
				isSlingshotting = true
		if ev.button_index == 1 and not ev.is_pressed():
			mouseLeftDown = false
			if isSlingshotting:
				_applySlingshotForce()
				isSlingshotting = false
			
	
func _draw():
	
	if (not started) && mouseLeftDown && isSlingshotting:
#		draw_line(-1 * _clampedVector2((get_global_mouse_position() - self.position), 100), Vector2.ZERO, Color(255,255,255), 5)

		# Draw Dashed Line
		var fullVector = -1 * _clampedVector2((get_global_mouse_position() - self.position), 150)
		for i in 9:
			if i % 2 == 1:
				continue
			draw_line(Vector2((fullVector / 9) * i), Vector2((fullVector / 9) * (i+1)), Color.WHITE, 4)
		
	if not started && not dead:
		draw_arc(Vector2.ZERO, 80, 0, 360, 360, Color.WHITE)
