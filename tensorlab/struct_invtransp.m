function [x,state] = struct_invtransp(z,task)
%STRUCT_INVTRANSP Matrix inverse transpose.
%   [x,state] = struct_invtransp(z) computes x as the matrix inverse of z.
%   The  structure state stores information which is reused in computing
%   the right and left Jacobian-vector products.
%
%   struct_invtransp(z,task) computes the right or left Jacobian-vector
%   product of this transformation, depending on the structure task. Use
%   the structure state and add the field 'r' of the same shape as z or the
%   field 'l' of the same shape as x to obtain the structure task for
%   computing the right and left Jacobian-vector products
%   
%      (dF(:)/dz(:).')*task.r(:) and
%      (dF(:)/dz(:).')'*task.l(:) + conj((dF(:)/dconj(z(:)).')'*task.l(:)),
%   
%   respectively. Here, F(z) represents this transormation, (:) signifies
%   vectorization and the derivative w.r.t. z (conj(z)) is a partial
%   derivative which treats conj(z) (z) as constant. The output has the
%   same shape as x or z for the right and left Jacobian-vector products,
%   respectively.
%   
%   See also struct_inv.

%   Authors: Laurent Sorber (Laurent.Sorber@cs.kuleuven.be)
%            Marc Van Barel (Marc.VanBarel@cs.kuleuven.be)
%            Lieven De Lathauwer (Lieven.DeLathauwer@kuleuven-kulak.be)
%
%   References:
%   [1] L. Sorber, M. Van Barel, L. De Lathauwer, "Structured data fusion,"
%       ESAT-SISTA Internal Report 13-177, KU Leuven, 2013.

if nargin < 2, task = []; end

if isempty(task) || (isempty(task.l) && isempty(task.r))
    x = inv(z).';
    state.invztrans = x;
elseif ~isempty(task.r)
    x = -(task.invztrans*task.r.'*task.invztrans);
    state = [];
elseif ~isempty(task.l)
    x = -conj(task.invztrans*task.l'*task.invztrans);
    state = [];
end

end
