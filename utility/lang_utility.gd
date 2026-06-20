class_name LangUtility


static func toggle_japanese() -> void:
	var locale := TranslationServer.get_locale()
	if locale == "ja":
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale("ja")
