module Render

using Plots
using StatsPlots
using ColorSchemes

import GR

export run

gr()

const BERKELEY_MONO_PATH = get(ENV, "BERKELEY_MONO_PATH", "")
const BERKELEY_MONO_FONT = isempty(BERKELEY_MONO_PATH) ? "" : joinpath(BERKELEY_MONO_PATH, "BerkeleyMono-Regular.ttf")

const PLOT_FONT = if !isempty(BERKELEY_MONO_FONT) && isfile(BERKELEY_MONO_FONT)
    try
        ENV["GKS_FONT_DIRS"] = BERKELEY_MONO_PATH
        font = GR.loadfont("Berkeley Mono")
        GR.settextfontprec(font, GR.TEXT_PRECISION_OUTLINE)
        "Berkeley Mono"
    catch e
        @warn "Failed to load Berkeley Mono font: $e"
        "monospace"
    end
else
    if isempty(BERKELEY_MONO_PATH)
        @warn "BERKELEY_MONO_PATH not set, using default monospace"
    else
        @warn "Berkeley Mono font not found at $BERKELEY_MONO_FONT, using default monospace"
    end
    "monospace"
end

default(fontfamily=PLOT_FONT, linewidth=2, framestyle=:box, grid=true, dpi=300)
scalefontsizes()
scalefontsizes(1.3)

const PALETTE = reverse(palette(:dense, 12))

# ============================================================================
# Include submodules
# ============================================================================

include("data.jl")
include("plots.jl")
include("cli.jl")

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
