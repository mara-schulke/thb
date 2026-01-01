module Render

using Plots
using StatsPlots
using ColorSchemes

import GR

export run

gr()

const PLOT_FONT = "Computer Modern"

default(fontfamily=PLOT_FONT, linewidth=2, framestyle=:box, grid=true, dpi=300)
scalefontsizes()
scalefontsizes(1.3)

const DIMENSIONS = (1200, 600)

# ============================================================================
# Include submodules
# ============================================================================

include("data.jl")
include("plots.jl")
include("cli.jl")

# ============================================================================
# Constants (after includes so PaletteScheme is defined)
# ============================================================================

const PALETTE = PaletteScheme(
    reverse(palette(:matter, 12)),  # verified
    reverse(palette(:linear_bmy_10_95_c71_n256, 8))   # unverified
)

# ============================================================================
# Public API
# ============================================================================

"""
    run(args::Vector{String})

Main entry point for the visualization system.
Parses command-line arguments and generates all configured plots.
"""
function run(args::Vector{String})
    return main(args; plot_font=PLOT_FONT, palette=PALETTE)
end

end
