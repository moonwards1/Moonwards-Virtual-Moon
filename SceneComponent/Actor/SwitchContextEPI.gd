extends EPIBase
class_name SwitchContextEPI

#Make a variable for when we are a dummy EPI.
export(bool) var is_dummy : bool = false

signal context_lost()
const CONTEXT_LOST = "context_lost"
signal context_taken()
const CONTEXT_TAKEN = "context_taken"

var previous_context : SwitchContextEPI = null


#Take context from whatever had context before it.
func take_context_from(old_context : SwitchContextEPI = null) -> void :
	#Do nothing if we are a dummy EPI.
	if is_dummy :
		return
	
	#If the passed old context does nothing, emit context taken and nothing else.
	elif old_context == null || old_context.is_dummy :
		emit_signal(CONTEXT_TAKEN)
		return
	
	else : 
		previous_context = old_context
		old_context.emit_signal(old_context.CONTEXT_LOST)
		emit_signal(CONTEXT_TAKEN)
