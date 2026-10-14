# frozen_string_literal: true

BATCH_NUMS = [
  7804,
  7803,
  7805,
  7774,
  7826,
  7790,
  7755
]

BATCH_NUMS.each do |num|
  `bin/exe #{num}`
end