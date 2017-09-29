# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

$ ->
  Harvester.textArea = document.getElementsByClassName("code-editor")[0]

  Harvester.readOnly = ->
    $(Harvester.textArea).hasClass("read-only")

  if Harvester.textArea != undefined
    Harvester.myCodeMirror = CodeMirror.fromTextArea Harvester.textArea, {
      theme: "monokai",
      lineNumbers: true,
      tabSize: 2,
      readOnly: Harvester.readOnly()
    }

    $(window).data "beforeunload", ->
      "You've modified your parser, reloading the page will reset all changes."

    Harvester.myCodeMirror.on "change", ->
      $(window).data "codechange", true
      window.onbeforeunload = $(window).data "beforeunload"

    $(".edit_parser input[value='Update Parser Script'], .edit_snippet input[value='Update Snippet'], .new_snippet input[value='Create Snippet'], .new_parser_template input[value='Create Parser template'], .edit_parser_template input[value='Update Parser template']").hover (->
      window.onbeforeunload = null
    ), ->
      window.onbeforeunload = $(window).data "beforeunload" if $(window).data("codechange")
