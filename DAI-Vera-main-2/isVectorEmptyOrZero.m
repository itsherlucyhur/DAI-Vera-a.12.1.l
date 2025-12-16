function result = isVectorEmptyOrZero(v)
    result = true;
    if (~isempty(v))
        if (~all(v == 0))
            result = false;
        end
    end
end