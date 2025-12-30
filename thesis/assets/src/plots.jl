"""
Plot types and rendering functions for thesis visualizations.
"""

using Plots
using StatsPlots

include("data.jl")

# Include all plot types
include("plots/utils.jl")
include("plots/Benchmark.jl")
include("plots/MetricComparisonBars.jl")
include("plots/RelativeImprovement.jl")
include("plots/SotaComparison.jl")
include("plots/ExampleSource.jl")
