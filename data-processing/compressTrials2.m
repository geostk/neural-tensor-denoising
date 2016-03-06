function [ Data_out ] = compressTrials2( Data )
% converts an n x t x c x r tensor from r = total_trials to r =
% max(trials_i/condition_i).
% todo:
% - output indices for method 2 n x c x t can be reconstructed;
% - other method options -- e.g. for trial avging
% - maybe a smoothing option.

if length(Data)==1
    structType = 1;
else
    structType = 2;
end

switch structType
    %% case 1
    case 1
        Y = Data.Y;
        Ys = Data.Ys;

        cond = Data.cond;
        c = length(unique(cond));
        max_r = max(histc(cond,1:c));

        [n,t,r] = size(Y);
        Y_out = nan(n,t,c,max_r);
        Ys_out = nan(n,t,c,max_r);    
        for rr = 1:r
            prev_count = sum(~isnan(Y_out(1,1,cond(rr),:))); % 1,1 or nn,1?
            Y_out(:,:,cond(rr),prev_count+1) = Y(:,:,rr);
            Ys_out(:,:,cond(rr),prev_count+1) = Ys(:,:,rr);
        end
        Data_out.Y = Y_out;
        Data_out.Ys= Ys_out;
        Data_out.cond = cond;
    
    %% case2
    case 2
        n = length(Data);
        c = length(unique(vertcat(Data(:).cond)));
        
        % get max trial counts
        for nn = 1:n
            max_r(nn) = max(histc(Data(nn).cond,1:c));
            allConds{nn} = Data(nn).cond;
        end
        
        t = size(Data(1).Y,1);
        Y_out = nan(n,t,c,max(max_r));
        Ys_out = Y_out;
        for nn = 1:n
            Y = Data(nn).Y;
            Ys = Data(nn).Ys;
            
            cond = Data(nn).cond;           
            r = size(Y,2);
            for rr = 1:r
                prev_count = sum(~isnan(Y_out(nn,1,cond(rr),:)));
                Y_out(nn,:,cond(rr),prev_count+1) = Y(:,rr);
                Ys_out(nn,:,cond(rr),prev_count+1) = Ys(:,rr);
            end
        end
        Data_out.Y = Y_out;
        Data_out.Ys = Ys_out;
        Data_out.cond = allConds;
     
end

end

