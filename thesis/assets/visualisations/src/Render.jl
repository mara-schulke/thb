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

const PLOT_FONT = "Berkeley Mono"
const BERKELEY_MONO_PATH = "/nix/store/yy92c3cq5lkfbcawckwv733rck0lz04d-berkeley-mono-1.0.0/share/fonts/truetype/berkeley-mono"

PyPlot.matplotlib.font_manager.fontManager.addfont(joinpath(BERKELEY_MONO_PATH, "BerkeleyMono-Regular.ttf"))
PyPlot.matplotlib.rcParams["svg.fonttype"] = "path"
PyPlot.matplotlib.rcParams["font.family"] = "monospace"
PyPlot.matplotlib.rcParams["font.monospace"] = ["Berkeley Mono"]

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
