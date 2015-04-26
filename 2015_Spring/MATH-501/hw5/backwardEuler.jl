function func(t,x)
    return exp(2*t)*x^2
end

function newtonFunc(yn1, tn1, yn)
    return yn1-yn-h*func(tn1, yn)
    # x_{n+1} - x_n -hfunc(t_{n+1}, x_{n+1}) =0
end


function fixedpointFunc(tn, yn)
    return yn+h*func(tn, yn)
    # x_{n+1} - x_n -hfunc(t_{n+1}, x_{n+1}) =0
end

N = 10000
h = 1/N
time = linrange(0,1,N)
tolerance = 10e-6
maxSteps = 100

function newton(a, b, index, previous)
    steps = 0
    mid = (a + b)/2
    while b-a>=2*tolerance 
        #println("Step", " ", steps)
        mid = (a + b)/2
        if (abs(newtonFunc(mid, time[index],previous ))<tolerance)
            return mid
        elseif newtonFunc(mid, time[index], previous)*newtonFunc(b, time[index], previous) <0
            a = mid
        elseif newtonFunc(a, time[index], previous)*newtonFunc(mid, time[index], previous) <0
            b = mid
        end
        steps = steps+1
        if steps>100
            return mid
        end
    end
    return mid
end

function fixedpoint(x0, index)

    ## x = hf(t,x) -x0

    x1 = fixedpointFunc(time[index], x0)
    x2 = fixedpointFunc(time[index], x1)
    k = 0
    shouldReturn=0
    while(abs(x2-x1)>=tolerance && abs(fixedpointFunc(time[index], x2)-x2)>=tolerance && k<=maxSteps-1)
        x2temp=x2;
        x2=fixedpointFunc(time[index],x1);
        x1=x2temp;
        k=k+1;
        if (abs(fixedpointFunc(time[index],x2)-x2)<tolerance)
            shouldReturn=1;
        end
        if shouldReturn==1
            return x2
        end
    end
    return x2
end

function exactsolution(index)
    return 1/(10.5-exp(2*time[index]))
end

newtonOut  = zeros(N)
fixedpointOut = zeros(N)
exactOut = zeros(N)
newtonOut[1] = 0.1
fixedpointOut[1] = 0.1
exactOut[1] = exactsolution(1)
### Implicit backward euler
## Newton


for i=2:N
    println("Running", " ", i)
    newtonOut[i] = newton(newtonOut[i-1], 1, i, newtonOut[i-1])
    fixedpointOut[i] = fixedpoint(fixedpointOut[i-1], i)
    exactOut[i] = exactsolution(i)

    println(newtonOut[i], " ", fixedpointOut[i], " ", exactOut[i])
end