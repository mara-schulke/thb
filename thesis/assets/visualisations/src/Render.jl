"""
Render - Thesis visualization and plotting system

Main module that coordinates benchmark data visualization.
"""
module Render

using Plots
using StatsPlots
using ColorSchemes
import PyPlot

export run

# ============================================================================
# Configuration and Setup
# ============================================================================

pyplot()

# Get Berkeley Mono path from environment, or use default monospace
const BERKELEY_MONO_PATH = get(ENV, "BERKELEY_MONO_PATH", "")
const BERKELEY_MONO_FONT = isempty(BERKELEY_MONO_PATH) ? "" : joinpath(BERKELEY_MONO_PATH, "BerkeleyMono-Regular.ttf")

# Try to load Berkeley Mono, fall back to default monospace if unavailable
const PLOT_FONT = if !isempty(BERKELEY_MONO_FONT) && isfile(BERKELEY_MONO_FONT)
    try
        PyPlot.matplotlib.font_manager.fontManager.addfont(BERKELEY_MONO_FONT)
        PyPlot.matplotlib.rcParams["font.monospace"] = ["Berkeley Mono"]
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

PyPlot.matplotlib.rcParams["svg.fonttype"] = "path"
PyPlot.matplotlib.rcParams["font.family"] = "monospace"

default(fontfamily=PLOT_FONT, linewidth=2, framestyle=:box, grid=true)
scalefontsizes()
scalefontsizes(1.0)

# :lajolla10 or :tofino10 or :vanimo10
const PALETTE = palette(:tofino10)

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

end # module
