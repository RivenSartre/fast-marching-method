function y=eetanh(x,sigma)
eplus = exp(sigma*x);
emiun = exp(-sigma*x);
y = (eplus - emiun)./(eplus + emiun);
end