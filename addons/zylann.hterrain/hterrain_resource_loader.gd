@tool
class_name HTerrainDataLoader
extends ResourceFormatLoader


const HTerrainData = preload("./hterrain_data.gd")


func _get_recognized_extensions():
	return PackedStringArray([HTerrainData.META_EXTENSION])


func _get_resource_type(path):
	var ext = path.get_extension().to_lower()
	if ext == HTerrainData.META_EXTENSION:
		return "Resource"
	return ""


func _handles_type(typename):
	return typename == "Resource"


func load(path, original_path):
	var res = HTerrainData.new()
	res.load_data(path.get_base_dir())
	return res
