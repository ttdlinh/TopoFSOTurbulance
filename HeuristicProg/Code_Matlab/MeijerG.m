function y = MeijerG(a,b,z)
% MeijerG
% 	A wrapper for MATLAB symbolic library implementation of the 'MeijerG' G^{m,n}_{p,q}(...|z) function.
%   It uses Maple with MATLAB 2008a or earlier; muPad with later versions. 
%
%   Syntax    : 
%       MeijerG({[a_1,...a_n],[a_n+1,...a_p]},{[b_1,...b_m],[b_m+1,...b_q]},z)
%   Input arguments : 
%       a - {[a_1,...a_n],[a_{n+1},...a_p]}
%       b - {[a_1,...a_m],[a_{m+1},...a_q]}
%       z - matrix of (possibly complex) numbers
%   Output:
%       y - has same dimensions as 'z'
%
%   Notes:
%   1.) For invalid arguments, 'double' function for converting results back
%   from symbols would return an error.
%   'MeijerG' catches the error, displays a warning, and sets corresponding
%   position of 'y' to 'nan'.
%   2.) 'double' to 'string' conversion used for forming the symbolic
%   expressions causes a precision loss, and possibly, round of errors.
%   3.) Sometimes, even the slightest changes to arguments 
%   could produce unacceptable results.
%       e.g.
%       >> MeijerG({[1,1], []},{1, 1},[1,2,3])
%       ans =
%           NaN   0.666666666666667   0.750000000000000
%       >> MeijerG({[1,1], []},{1, 1},[1+1e-5,2,3])
%       ans =
%           0.500002499987500   0.666666666666667   0.750000000000000
%       Here the second result appears correct, since
%            MeijerG({[1,1], []},{1, 1},z ) = z/(z+1)
%   Please let me know if such issues can be circumvented.
%
%   Author        : Damith Senaratne, (http://www.damiths.info)
%   Released date : 16th August 2011 

if verLessThan('matlab','7.7.0')
    useMaple = true;
    maple('MeijerGi := sqrt(-1);');
else
    useMaple = false;
    SE = symengine;
    evalin(SE,'MeijerGi := sqrt(-1)');
end
% Note: Given the performance penalty and other implications,
% the symbolic engine is not reset within 'MeijerG'.
% Hence, the choosing a simple identifier for imaginary unit (e.g. 'i')
% appears difficult. 
% The identifier 'MeijerGi' is chosen above hoping that it won't conflict
% with any already defined symbolic variable.
    
% extract the arguments
a1 = a{1}; a2 = a{2};
b1 = b{1}; b2 = b{2};

a1 = a1(:); a2 = a2(:);
b1 = b1(:); b2 = b2(:);

zvec = z(:); % vectorize (to make the computation independent of the dimensions)
y = zeros(size(zvec));
for k=1:length(y)
    % iterate for each element of 'z'!
    if imag(z(k))>=0
        zStr = sprintf('%g + MeijerGi* %g',real(z(k)),imag(z(k))); 
    else
        zStr = sprintf('%g - MeijerGi* %g',real(z(k)),abs(imag(z(k)))); 
    end
   
    if useMaple
        cmd = sprintf('evalf(MeijerG([%s,%s],[%s,%s],%s))',intVecToStr(a1),intVecToStr(a2),intVecToStr(b1),intVecToStr(b2),zStr);
        [r,s] = maple(cmd);
        
        if s ~= 0
            warning('MeijerG: failed evaluating for k = %d',k);
            y(k) = nan;
        else
            r = str2double(r);
            y(k) = r(1);
        end
    else
       expr = sprintf('meijerG([%s,%s],[%s,%s],%s)',intVecToStr(a1),intVecToStr(a2),intVecToStr(b1),intVecToStr(b2),zStr);
       [r,s] = evalin(SE,expr); 
       if s ~= 0
            warning('MeijerG: failed evaluating for k = %d',k);
            y(k) = nan;     
       else
            try
                y(k) = double(r(1));                  
            catch err
                warning('MeijerG: failed evaluating for k = %d',k);
                y(k) = nan;
            end
       end
    end
end
y = reshape(y,size(z));

% -----------------------
% function: intVecToStr
% -----------------------
% converts elements of an integer array 'a' to a string
function s = intVecToStr(a)
s = ['[', sprintf(' %ld,',a)];
s = [s(1:end-1), ' ]'];
