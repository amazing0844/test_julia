using DirectSearch
using Plots
using Statistics
logocolors = Colors.JULIA_LOGO_COLORS
Revise.track(DirectSearch)

# include("/Users/zyy/.julia/dev/DirectSearch/src/DirectSearch.jl")
# using .DirectSearch_test
# import("Direct")
# using Plots
# using Gadfly
# using GR
# function s(x)
#     return abs(floor(x + 1 / 2) - x)
# end
#
# function f(x::Vector{Float64},test=6)
#     Taka = 0
#     w = 0.9
#     test=4
#     for n in 1:100
#         Taka -= w^n * s(2^n * x[1])
#     end
#     return Taka
# end



function test_easy(x)
f1(x) = (x[1]+2).^2 - 10.
f2(x) = (x[1]-2).^2 + 20.
# f3(x)=(1-x[1])
return [f1]
end

function discontiguous_test(x)
    m=30
    f1(x)=x[1]
    g(x)=1+9 .* sum((x[2:m] ./ (collect(2:m) .- 1)))
    h(x)=1-sqrt(f1(x)/ g(x))-(f1(x)/g(x))*sin(10*pi*f1(x))
    f2(x)=g(x)*h(x)
    return [f1,f2]
end


# p = DSProblem(1; objective=test_easy, initial_point=[-7.5],full_output=false);
p = DSProblem(30; objective=discontiguous_test,initial_point=ones(30)./2, iteration_limit=1000000,full_output=false);
# p = DSProblem(2; objective=discontiguous_test, initial_point=[0.51,0.51],iteration_limit=1000,full_output=false);
# AddStoppingCondition(p, HypervolumeStoppingCondition(0.001))
# AddStoppingCondition(p, RuntimeStoppingCondition(3.5))
SetFunctionEvaluationLimit(p,1000000)

# SetVariableRange(p,1,0.,0.19)
# cons1(x) = 0. < x[1] < 1.
# AddExtremeConstraint(p, cons1)
for i=1:30
    cons(x) = 0. < x[i] <1.
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
display(fig)
