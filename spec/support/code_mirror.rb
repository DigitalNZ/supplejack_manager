# frozen_string_literal: true

def fill_code_mirror(code, append = true)
  value = append ? "Harvester.myCodeMirror.getValue() + '#{code}'" : "'#{code}'"
  page.execute_script("Harvester.myCodeMirror.setValue(#{value})")
end
