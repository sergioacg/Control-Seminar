function [Hs] = tf2sym(FT,z)
%   
%Fun��o para transformar uma fun��o de transferencia em variable simbolica
%[Hs] = tf2sym(FT,z)
%Hs:    Fun��o de Transferencia simbolica
%FT:    Fun��o de Transferencia normal
%z:     Variable symbolica (Z ou S) (se tem que definir previamente no codigo)
%
%Exemplo
%   >>syms z
%   >>g=tf[1,[2 1],1)
%   >>H= tf2sym(g,z)
%% By: Sergio Andres Casta�o Giraldo
%% Universidade Federal de Santa Catarina (UFSC - Brasil - Florian�polis)
%% http://controlautomaticoeducacion.com/

M=size(FT);  %Determina o cumprimento de FT
num=0;
den=0;
Hs1(M(1,1),M(1,2))=z;
Hs1(M(1,1),M(1,2))=subs(Hs1(M(1,1),M(1,2)),z,0);
for i=1:M(1,1)
    for j=1:M(1,2)
        
        [B,A]=tfdata(FT(i,j),'v'); %Separo num e den
        if B==0
            Hs1(i,j)=0;
        else
            if B(1)==0
             B=B(2:end);
            end
            at=FT(i,j).iodelay;  %Acho o Atraso
            na=length(A);
            nb=length(B);
            for k=1:na
                den=vpa(den+z^(na-k)*A(k));
            end
            for k=1:nb
                num=vpa(num+z^(nb-k)*B(k));
            end
            
            if FT(i,j).Ts==0 %Pregunto si la funcion es discreto o continuo
                Hs1(i,j)=((num/den)*exp(-at*z));
            else
                Hs1(i,j)=((num/den)*z^(-at));
            end
            num=0;
            den=0;
        end
    end
end
Hs=vpa(combine(Hs1),4);
%Hs=Hs1;
end
