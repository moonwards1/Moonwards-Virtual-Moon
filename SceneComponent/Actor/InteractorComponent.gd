extends AComponent

const INTERACT_METHOD : String = "on_interacted_from_client"

onready var interactor : Area = $Interactor

#This function is required by AComponent.
func _init().("Interactor", true) -> void :
	pass

func _interactable_left(interactable_user_node : Node) -> void :
	Signals.Hud.emit_signal(Signals.Hud.INTERACTABLE_LEFT_REACH, interactable_user_node)

#Bring up the interact display
func _interact_made_possible(_string_closest_potential_interact : String):
	Signals.Hud.emit_signal(Signals.Hud.INTERACT_POSSIBLE, "to bring up interact menu")

#Hide the interact display when no interactions are available.
func _interact_made_impossible():
	Signals.Hud.emit_signal(Signals.Hud.INTERACT_BECAME_IMPOSSIBLE)

#Make Interactor have my Entity variable as it's user.
func _ready() -> void :
	interactor.owning_entity = self.entity
	
	#Interact with the interactable the player has chosen from the list.
	Signals.Hud.connect(Signals.Hud.INTERACT_OCCURED, interactor, "interact")
	
	#Listen for when interactions are possible and when they become impossible.
	interactor.connect("interacted_with", self, "on_interacted_with")
	interactor.connect("interactable_left_area", self, "_interactable_left")

func _input(event : InputEvent) -> void :
	if event.is_action_pressed("use") :
		var potential_interacts : Array = interactor.get_potential_interacts()
		Signals.Hud.emit_signal(Signals.Hud.POTENTIAL_INTERACT_REQUESTED, potential_interacts)

#Function for testing that the server works correctly.
master func on_interacted_from_client(_interactees : Array) -> void :
	Log.warning(self, "", "HEY, I GOT CALLED FROM A CLIENT OVER NETWORK!!!")

#Called after the interactable has been interacted with. Networks that the interaction happened.
func on_interacted_with(interactable : Interactable)->void:
	print("Interacted with %s " %interactable)
	if interactable.is_networked() :
		crpc("on_interacted_from_client", [interactable, interactor.owning_entity], [entity.owner_peer_id])

func interactable_entered(interactable_node):
	Signals.Hud.emit_signal(Signals.Hud.INTERACTABLE_ENTERED_REACH, interactable_node)

func disable():
	Signals.Hud.emit_signal(Signals.Hud.HIDE_INTERACTS_MENU_REQUESTED)
	$Interactor.enabled = false
	.disable()

func enable():
	$Interactor.enabled = true
	.enable()
