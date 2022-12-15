class String
  def integers
    tr('^0-9-', ' ').split(' ').map(&:strip).reject(&:nil?).map(&:to_i)
  end
end