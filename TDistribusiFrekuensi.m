function [res,f] = TDistribusiFrekuensi(x,k)
    
    n=size(x,1);
    x_min = min(x);
    x_max = max(x);
    R = x_max-x_min;
    i=ceil((R/k)+0.000001);
    
	%INTERVAL;
    interval = zeros;
    for q=1:k+1
        interval(q) = x_min +(q-1)*i;
    end
    
    %MEDIAN
    for q=1:k
       m(q) = interval(q)+0.5*1;
       f(q) = 0;
    end
    
	%FREKUENSI
    for p=1 : n
       for q = 1 : k
           if x(p) >= interval(q) && x(p) < interval(q+1)
               f(q)=f(q)+1;
           end
       end
    end
    
    %FREKUENSI RELATIF
    for q=1 : k
        fr(q)= f(q)/n;
    end
    
    fk=zeros;
    fk(1) = f(1);
    
    for q = 2 : k
        fk(q) = fk(q-1)+f(q);
    end
    
    %parse table [interval, m, f, fr, fk]
    %ubah ke dalam bentuk matrix
    res =  [interval(1) m(1) f(1) fr(1) fk(1)];
    n = size(interval,2)-1;
    for y = 2 : n
        res =  [res; interval(y) m(y) f(y) fr(y) fk(y)];
    end    
    
return