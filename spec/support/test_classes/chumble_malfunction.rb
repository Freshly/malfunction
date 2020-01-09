# frozen_string_literal: true

class ChumbleMalfunction < GrumboMalfunction
  contextualize :frayed_chumble, allow_nil: true

  def self.problem
    :fumble_wumble
  end
end
