# frozen_string_literal: true

class Array
  def delete_first(item)
    new_arr = self.clone
    new_arr.delete_at(index(item))
    new_arr
  end
end
