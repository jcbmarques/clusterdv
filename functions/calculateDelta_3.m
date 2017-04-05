function delta=calculateDelta_3(rho,distz)

%%
%%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% distz = maxjump;

%%
%initiate delta array
delta=zeros(size(rho));

%loop through all points
for n=1:length(delta)

%find ind of points of higher density   
thisdistz = find(rho > rho(n));

%if there are points of higher density
if (~isempty(thisdistz))
    
    %delta is the min max jump of the points of higher densities
    delta(n) = min(distz(thisdistz,n));
    
    
else%if the point is the point of higher density
    
         delta(n) = max(distz(:,n));%max density ???

%if it is point of highest density delta is the same as the highest delta
%    delta(n)=max(delta(:,n));%the point of highest delta

end
    
end

end