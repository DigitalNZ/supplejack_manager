module Sass::Script::Functions
  def trim_list(list, threshold, ascending)
    # remove list items above or below a threshold
    sep = list.separator if list.is_a?(Sass::Script::List)
    list = list.to_a.dup
    if ascending.value
      list = list.delete_if {
        |x| x.value <= threshold.value
      }
    else
      list = list.delete_if {
        |x| x.value >= threshold.value
      }
    end
    Sass::Script::List.new(list, sep)
  end
end
