###
Create an extension for views
empower the view to:
* trigger process blocking the ui components.

###
class @Lemonette.Processes

	process: ($detonator, $icon = null, $text = null, loadingText = null, process = null) ->
		backup = @triggerLoading($detonator, $icon, $text, loadingText)
		process() if process

	triggerLoading: ($detonator, $icon = null, $text = null, loadingText = null) ->
		backup = {}

		backup.detonator_classes = @triggerLoadingOnDetonator($detonator)

		if $icon
			backup.icon_classes = @triggerLoadingOnIcon($icon)

		if $text && loadingText
			backup.original_text = @triggerLoadingOnText($text, loadingText)

		backup

	restoreLoading: (backup, $detonator, $icon = null, $text = null, loadingText = null) ->
		@restoreLoadingOnDetonator(backup.detonator_classes, $detonator)

		if $icon
			@restoreLoadingOnIcon($icon)

		if $text && loadingText
			@restoreLoadingOnText($text, loadingText)

	triggerLoadingOnDetonator: (backup_data, $detonator) ->
		$detonator.blur()
		$detonator.prop('disabled', true)
		detonator_original_classes = $detonator.prop('class')
		$detonator.removeClass(
			detonator_original_classes
		).addClass('btn btn-disabled')

		detonator_original_classes

	triggerLoadingOnIcon: (backup_data, $icon) ->
		icon_original_classes = $icon.prop('class')
		$icon.removeClass(
			icon_original_classes
		).addClass('fa fa-refresh fa-spin')

		icon_original_classes

	triggerLoadingOnText: (backup_data, $text, $loadingText) ->
		text_original_text = $text.text()
		$text.text(loadingText)

		text_original_text

	restoreLoadingOnDetonator: (backup_classes, $detonator) ->
		$detonator.prop('disabled', false)
		$detonator.removeClass(
			$detonator.prop('class')
		).addClass(backup_classes)

	restoreLoadingOnIcon: (backup_classes, $icon) ->
		$icon.removeClass(
			$icon.prop('class')
		).addClass(backup_classes)

	restoreLoadingOnText: (backup_text, $text) ->
		$text.text(backup_text)
