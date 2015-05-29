function chem_potential_salt = gsw_chem_potential_salt(SA,t,p)

% gsw_chem_potential_salt            chemical potential of salt in seawater
%==========================================================================
%
% USAGE:
%  chem_potential_salt  = gsw_chem_potential_salt(SA,t,p)
%
% DESCRIPTION:
%  Calculates the chemical potential of salt in seawater
%
% INPUT:
%  SA =  Absolute Salinity                                         [ g/kg ]
%  t  =  in-situ temperature (ITS-90)                             [ deg C ]
%  p  =  sea pressure                                              [ dbar ]
%        (ie. absolute pressure - 10.1325 dbar) 
%
%  SA & t need to have the same dimensions.
%  p may have dimensions 1x1 or Mx1 or 1xN or MxN, where SA & t are MxN.
%
% OUTPUT:
%  chem_potential_salt  =  chemical potential of salt in seawater
%                                                                 [ J/kg ]
%
% AUTHOR: 
%  Trevor McDougall and Paul Barker        [ help_gsw@csiro.au ]
%
% VERSION NUMBER: 2.0 (28th September, 2010)
%
% REFERENCES:
%  IOC, SCOR and IAPSO, 2010: The international thermodynamic equation of 
%   seawater - 2010: Calculation and use of thermodynamic properties.  
%   Intergovernmental Oceanographic Commission, Manuals and Guides No. 56,
%   UNESCO (English), 196 pp.  Available from http://www.TEOS-10.org
%
%  The software is available from http://www.TEOS-10.org
%
%==========================================================================

%--------------------------------------------------------------------------
% Check variables and resize if necessary
%--------------------------------------------------------------------------

if ~(nargin == 3)
   error('gsw_chemical_potential_salt:  Requires three inputs')
end %if

[ms,ns] = size(SA);
[mt,nt] = size(t);
[mp,np] = size(p);

if (mt ~= ms | nt ~= ns)
    error('gsw_chem_potential_salt: SA and t must have same dimensions')
end

if (mp == 1) & (np == 1)              % p is a scalar - fill to size of SA
    p = p*ones(size(SA));
elseif (ns == np) & (mp == 1)         % p is row vector,
    p = p(ones(1,ms), :);              % copy down each column.
elseif (ms == mp) & (np == 1)         % p is column vector,
    p = p(:,ones(1,ns));               % copy across each row.
elseif (ns == mp) & (np == 1)          % p is a transposed row vector,
    p = p';                              % transposed then
    p = p(ones(1,ms), :);                % copy down each column.
elseif (ms == mp) & (ns == np)
    % ok
else
    error('gsw_chem_potential_salt: Inputs array dimensions arguments do not agree')
end %if

if ms == 1
    SA = SA';
    t = t';
    p = p';
    transposed = 1;
else
    transposed = 0;
end

%--------------------------------------------------------------------------
% Start of the calculation
%--------------------------------------------------------------------------

chem_potential_salt = gsw_chem_potential_relative(SA,t,p) + ...
                          gsw_chem_potential_water(SA,t,p);

if transposed
    chem_potential_salt = chem_potential_salt';
end

end
