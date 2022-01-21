require "package_matcher/version"

module PackageMatcher
  class Error < StandardError; end

  BOX_M = :M
  BOX_L = :L

  CAM = "Cam"
  GAME = "Game"
  BLUE = "Blue"

  ITEM_TYPES = [
    CAM,
    GAME,
    BLUE,
  ]

  SIZE_MAP = {
    BOX_M => 4,
    BOX_L => 10,
    CAM => 4,
    GAME => 5,
    BLUE => 8
  }

  MEDIUM_SIZE_MAP = {
    CAM => 1
  }
  LARGE_SIZE_MAP = {
    CAM => 2,
    GAME => 2,
    BLUE => 1
  }

  class << self
    def call(items)
      return [] if items.empty?

      counters = count_items(items)

      boxes = {}
      counters.each do |type, num|
        boxes[type] = calculate_boxes(type, num)
      end

      # HERE: {CAM: { full: {MEDIUM: 2, LARGE: 3}, partial: {MEDIUM: 0, LARGE: 1}, GAME: ...}

      box_output = []
      boxes.compact.each do |type, box_counters|
        box_counters.each do |capacity, box_data|
          box_data.each do |box_type, count|
            box_occurrences = case box_type
            when BOX_M
              MEDIUM_SIZE_MAP[type]
            when BOX_L
              if capacity == :full
                LARGE_SIZE_MAP[type]
              else
                1
              end
            end

            count.times do
              box_output << [box_type, [].fill(type, nil, box_occurrences)]
            end
          end
        end
      end

      box_output
    end

    private

    def count_items(items)
      # Input: items, type = nil
      # Output: { CAM => 2, GAME => 3, blue => 5 }
      counters = {}
      ITEM_TYPES.each do |type|
        counters[type] = items.select { |item| item == type }.count
      end

      counters
    end

    def calculate_boxes(item_type, item_num)
      return {} if item_num.zero?
      # Input: CAM, 5
      # Output: { FULL: { BOX_M => 2, BOX_L => 3 }, PARTIAL: { BOX_M => 0, MOX_L => 1 } }
      boxes_data = { full: { BOX_M => 0, BOX_L => 0 }, partial: { BOX_M => 0, BOX_L => 0 } }

      # calculate full boxes
      boxes_data[:full][BOX_L] += item_num / LARGE_SIZE_MAP[item_type]

      # calculate medium and partial boxes
      if item_num % LARGE_SIZE_MAP[item_type] == 1 && MEDIUM_SIZE_MAP[item_type]
        boxes_data[:partial][BOX_M] += 1
      elsif item_num % LARGE_SIZE_MAP[item_type] == 1
        boxes_data[:partial][BOX_L] += 1
      end

      boxes_data
    end
  end
end
