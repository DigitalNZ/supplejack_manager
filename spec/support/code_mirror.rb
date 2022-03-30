# frozen_string_literal: true

def fill_code_mirror(code, append = true)
  value = append ? "Harvester.myCodeMirror.getValue() + '#{code}'" : "'#{code}'"
  # the Harvester object isn't always initialized when running this code
  # the sleep is here to wait for the JS code to execute
  3.times do
    page.execute_script("Harvester.myCodeMirror.setValue(#{value})")
    break
  rescue
    sleep 1
  end
end
