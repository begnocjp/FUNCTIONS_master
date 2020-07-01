function [grandaverage] = generate_grandaverage(wpms,time)
grandaverage = zeros(length(wpms.names),length(wpms.conditions),length(wpms.responsetype),60,length(time));
for name_i = 1:length(wpms.names)
    fprintf('\n%s\t%s','Working on subject:',wpms.names{name_i});
    for cond_i = [1:3 6:length(wpms.conditions)];
        fprintf('\n%s\t',wpms.conditions{cond_i});
        for response_i = 1:length(wpms.responsetype)
            fprintf('.');
            filename = [wpms.dirs.ERP_DIR 'Mastoid_Referenced' filesep wpms.names{name_i} ...
                filesep wpms.conditions{cond_i} filesep ...
                wpms.names{name_i} '_' wpms.conditionshort{cond_i} ...
                '_' wpms.responsetype{response_i} '_erp.mat'];
            load(filename,'ERP');
            if strcmpi(wpms.names{name_i},'XS005C')==1 || strcmpi(wpms.names{name_i},'XS024B')==1;
                grandaverage(name_i,cond_i,response_i,[1:41 43:60],:) = ERP(:,time);
            elseif strcmpi(wpms.names{name_i},'XS023A')==1;
                grandaverage(name_i,cond_i,response_i,[1:31 33:40 42:59],:) = ERP(:,time);
            elseif strcmpi(wpms.names{name_i},'XS063B')==1;
                grandaverage(name_i,cond_i,response_i,[1:28 30:37 39:57],:) = ERP(:,time);
            elseif strcmpi(wpms.names{name_i},'XS065D')==1;
                grandaverage(name_i,cond_i,response_i,[1:30 32:39 41:59],:) = ERP(:,time);
            else
                grandaverage(name_i,cond_i,response_i,:,:) = ERP(:,time);
            end
        end
    end
end
