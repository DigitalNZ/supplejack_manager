# frozen_string_literal: true

get(
  :status,
  to: proc {[
    200,
    { 'Cache-Control' => 'no-store, must-revalidate, private, max-age=0' },
    ['ok']
  ]}
)
