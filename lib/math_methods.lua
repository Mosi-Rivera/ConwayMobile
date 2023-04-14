local math_methods = {};

function math_methods.easeOut(t,n)
    return 1 - (1 - t) ^ (n or 2);
end

function math_methods.easeIn(t,n)
    return t ^ (n or 2);
end

function math_methods.lerp(from,to,t)
    return from + (to - from) * t;
end

function math_methods.approach(a,b,c)
    return a > b and math.max(b,a - c) or math.min(b,a + c);
end

function math_methods.sign(n)
    return n < 0 and -1 or 1; 
end

return math_methods;