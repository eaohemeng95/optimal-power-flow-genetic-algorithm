
function cost = fitness_function(Pg, mpc)
% FITNESS_FUNCTION Calculate total fuel cost for generator outputs.
%
% Inputs:
%   Pg  - Vector of active power outputs (MW), one per generator
%   mpc - MATPOWER case structure containing generator limits
%         and generator cost coefficients
%
% Output:
%   cost - Total generation cost in the units of gencost

    define_constants;

    % Convert generator outputs to a column vector
    Pg = Pg(:);

    % Extract generator limits
    Pmin = mpc.gen(:, PMIN);
    Pmax = mpc.gen(:, PMAX);

    % Extract quadratic cost coefficients:
    % gencost columns 5, 6, 7 are a, b, c for this case
    a = mpc.gencost(:, 5);
    b = mpc.gencost(:, 6);
    c = mpc.gencost(:, 7);

    % Validate the input
    if numel(Pg) ~= size(mpc.gen, 1)
        error('Pg must contain one power output per generator.');
    end

    % Reject outputs outside generator operating limits
    if any(Pg < Pmin) || any(Pg > Pmax)
        cost = Inf;
        return;
    end

    % Calculate total quadratic generation cost
    cost = sum(a .* Pg.^2 + b .* Pg + c);
end
