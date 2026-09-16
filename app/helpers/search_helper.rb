module SearchHelper
  def keep_search
    q = params.permit(:from, :to, :on, :min_rating, :min_price, :max_price, :ac_type, :layout_type, :amenity)
    return q unless defined?(@from) && @from.present?

    q.merge(from: @from, to: @to, on: @on)
  end
end
