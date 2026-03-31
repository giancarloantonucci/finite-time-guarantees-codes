using Plots, DelimitedFiles, LaTeXStrings

pyplot(
    framestyle = :box,
    label = "",
    markersize = 5,
    markerstrokewidth = 0,
    tickdirection = :out,
)
using PyPlot: rc
rc("text", usetex = "true")
rc("mathtext", fontset = "cm")
rc("font", family = "serif")

data_sources = [
    ("rpeak.dat", "Theoretical peak-performance (GFlop/s)", :hexagon),
    ("rmax.dat",  "LINPACK performance (GFlop/s)",          :pentagon),
    ("power.dat", "Power (kW)",                             :square),
    ("cores.dat", "Number of cores",                        :utriangle)
]

p = plot(
    size = (600, 400),
    legend = :topleft,
    xminorgrid = true,
    yscale = :log10,
    xticks = 1993:3:2023,
    xlims = (1992, 2024),
    yticks = (10.0 .^ (2:9), [L"10^2", [L"10^{%$i}" for i in 3:9]...]),
    ylims = (5e1, 5e9),
    xlabel = "Year"
)

for (i, (filename, label, marker)) in enumerate(data_sources)
    path = joinpath("./Top500", filename)
    data = readdlm(path)
    scatter!(p, data[:, 1], data[:, 2], marker = marker, label = label, color = i + 1)
end

savefig(p, "./Images/Top500.pdf")
