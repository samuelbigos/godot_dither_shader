extends HBoxContainer


func setup(text, min_val, max_val, default_val, step):
	$ValueSlider.min_value = min_val
	$ValueSlider.max_value = max_val
	$ValueSlider.value = default_val
	$ValueSlider.step = step
	$Label.text = text
	
func get_value():
	return $ValueSlider.value

func _on_ValueSlider_value_changed(value):
	$ValueLabel.text = String($ValueSlider.value)
