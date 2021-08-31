using DirectSearch
using Plots
using Statistics
using LinearAlgebra
logocolors = Colors.JULIA_LOGO_COLORS
gr(show = false, size = (400, 400))
Revise.track(DirectSearch)

function QV1(x)

    # params
    n = 10;

    #fonctions
    f1 = sum((x[1:n].^2 - 10 * cos.(2 * pi * x[1:n]) .+ 10) / n)^0.25;
    f2 = sum( ((x[1:n] .- 1.5).^2 - 10 * cos.(2 * pi * (x[1:n] .- 1.5)) .+ 10) / n )^0.25;

    return [f1;f2]

end

m=10
function F1(x)
    f1(x)=QV1(x)[1]
    f2(x)=QV1(x)[2]
    return [f1,f2]
end

p = DSProblem(m; objective=F1,initial_point=ones(m) ./2, iteration_limit=100000,full_output=false);
# AddStoppingCondition(p, HypervolumeStoppingCondition(4.13))
# AddStoppingCondition(p, RuntimeStoppingCondition(4.1320))
SetFunctionEvaluationLimit(p,10000000)

# SetVariableRange(p,1,0.,0.19
# cons1(x) = 0. < x[1] < 1.
# AddExtremeConstraint(p, cons1)
for i=1:m
    cons(x) = (-5.12 <= x[i] <=5.12)
    AddExtremeConstraint(p, cons)
end

# cons2(x) = -5. < x[2:30] <5.
# AddExtremeConstraint(p, cons2)

# AddStoppingCondition(p, ButtonStoppingCondition("quit"))
# SetIterationLimit(p,2)
# AddStoppingCondition(p, RuntimeStoppingCondition(0.01))
# SetRuntimeLimit(p, 0.2)

result=Optimize!(p)
# @show p.status
# @show p.x
# @show p.x_cost
# @show p.status.iteration
# @show paretoCoverage(result)
# @show hvIndicator(result)
fig=scatter()
for i in 1:length(result)
    fig=scatter!([result[i].cost[1]],[result[i].cost[2]],color=logocolors.red,legend = false)
end

plot!(fig,xlabel="f1 cost",ylabel="f2 cost")
display(fig)
# savefig(fig, "./test_functions/pareto_result/QV1.pdf")
