function byteSwapNeeded = isByteSwapNeeded(transferSyntaxUID)
switch(transferSyntaxUID)
    case '1.2.840.113619.5.2'
        byteSwapNeeded = true;
    otherwise
        byteSwapNeeded = false;
end
end