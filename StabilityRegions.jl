using Revise
using NSDERungeKutta

function parareal_stability_function(z, solver; steps)
    R_F(z) = exp(z)
    absR_F(z) = abs(R_F(z))

    R_G(z) = stability_function(steps * z, solver.tableau)
    absR_G(z) = abs(R_G(z))

    z1 = absR_G(z)
    z2 = abs(R_F(z)^steps - R_G(z)) / (1 - absR_G(z))
    return z1 ≤ 1 && z2 ≤ 1 ? z2 : NaN
end
parareal_stability_function(z, solver) = parareal_stability_function(z, solver; steps=1)

finesolver_stability_function(z, solver) = abs(stability_function(z, solver))

using Plots, LaTeXStrings
gr(
    fontfamily = "Computer Modern",
    framestyle = :box,
    label = "",
    tickdirection = :out,
)
using Colors: colormap

xspan = range(-6.0, 1.0, length=500)
yspan = range(-4.0, 4.0, length=500)

p1 = stabilityf(z -> finesolver_stability_function(z, Butcher5()); xspan, yspan, colour = colormap("Oranges"))
stabilityf!(p1, z -> finesolver_stability_function(z, RK4()); xspan, yspan, colour = colormap("Purples"))
stabilityf!(p1, z -> finesolver_stability_function(z, Heun3()); xspan, yspan, colour = :greens)
stabilityf!(p1, z -> finesolver_stability_function(z, Midpoint()); xspan, yspan, colour = :reds)
stabilityf!(p1, z -> finesolver_stability_function(z, Euler()); xspan, yspan, colour = :blues)
plot!(p1, xlabel = L"\mathrm{Re}\,(z)", ylabel = L"\mathrm{Im}\,(z)", colorbar = false)

p2 = stabilityf(z -> parareal_stability_function(z, Butcher5()); xspan, yspan, colour = colormap("Oranges"))
stabilityf!(p2, z -> parareal_stability_function(z, RK4()); xspan, yspan, colour = colormap("Purples"))
stabilityf!(p2, z -> parareal_stability_function(z, Heun3()); xspan, yspan, colour = :greens)
stabilityf!(p2, z -> parareal_stability_function(z, Midpoint()); xspan, yspan, colour = :reds)
stabilityf!(p2, z -> parareal_stability_function(z, Euler()); xspan, yspan, colour = :blues)
plot!(p2, xlabel = L"\mathrm{Re}\,(z)", ylabel = L"\mathrm{Im}\,(z)", colorbar = false)

plot(p1, p2, size = (600, 300))

savefig("./Images/StabilityRegions.pdf")
