# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#poll_public').iphoneStyle(checkedLabel: 'Yes', uncheckedLabel: 'No')
  $('#poll_public_button').iphoneStyle(
    checkedLabel: 'Yes', 
    uncheckedLabel: 'No', 
    onChange: (el) -> 
        $el = $(el)
        if window.confirm(if $el.attr('checked') then 'Are you sure you want to publish this poll?' else 'Are you sure you want to unpublish this poll?')
          console.log($el.attr('data-publish-url'))
          $.ajax(
              type: 'put',
              error: (error) -> console.log(error),
              contentType: 'json',
              url: $el.attr('data-publish-url')+'.json',
              beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
          )
        
        else
            $el.attr('checked', !$el.attr('checked'));
  )

