% Kristofer Drozd
% UniformRandomN

function [W] = UniformRandomN(a,b,rows,cols,mats)

W = (b-a).*rand (rows,cols,mats) + a;

end