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
    ("transistors.dat", "Number of transistors (thousands)",                 :circle),
    ("specint.dat",     L"Single-thread performance (SPECint$\times 10^3$)", :hexagon),
    ("frequency.dat",   "Clock rate (MHz)",                                  :pentagon),
    ("watts.dat",       "Power (W)",                                         :square),
    ("cores.dat",       "Number of cores",                                   :utriangle)
]

p = plot(
    size = (600, 400),
    legend = :topleft,
    xminorgrid = true,
    yscale = :log10,
    xticks = 1970:5:2020,
    xlims = (1970, 2023),
    yticks = (10 .^ (0:8), ["1", "10", [L"10^%$i" for i in 2:8]...]),
    xlabel = "Year"
)

for (filename, label, marker) in data_sources
    path = joinpath("./Rupp2022", filename)
    data = readdlm(path) 
    scatter!(p, data[:, 1], data[:, 2], marker = marker, label = label)
end

savefig(p, "./Images/Rupp2022.pdf")
