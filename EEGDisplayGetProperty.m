function [Values,Text] = EEGDisplayGetProperty(PropertyLists,PropertyName)
% EEGDisplayGetProperty: Utility for accessing Trial Property Values
%
% [Values,Text] = EEGDisplayGetProperty ( PropertyLists,PropertyName)
%
%   PropertLists    a hdr.orig.PropertyList created by EEGDisplay2FT()
%   PropertyName    Name of the property to extract
%
%   Values        Numeric values of property for each trial
%                 Will be 0 if Property is a string that does not represent
%                 a number.
%   Text          Property Value for each trial as text string
%
% Retrieves the specified Property associated with each trial
% from a hdr.orig.PropertyList created when importing an EEGDisplay data
% file.
%
% Example:
% [V,T] = EEGDisplayGetProperty(Data.hdr.orig.PropertyList,'$RawCode')
% return the $RawCode property for each trial.
% T is a [Nx1] cell array containing the property value as a text string
% V is a [Nx1] numeric array containg the property value as a number.
% V contains zeros if the property can not be converted to numeric.
% where N = number of trials
%
% Properties containing Text have Name with a $ prefix, eg $Subject
% Properties containing Numbers have a Name with a # prefix, eg #RT
%
% Version 1, 19/6/2014. Written by Ross Fulham

[nTrials,nChans] = size(PropertyLists);

Values = zeros(nTrials,1);
Text = cell(nTrials,1);

for trl=1:nTrials
   PropertyList = PropertyLists{trl,1};
   
   nProperties = size(PropertyList,2);
   
   for prop=1:nProperties
      Name = PropertyList(prop).PropertyName;
            
      if strcmp(PropertyName,Name)
          PropertyValue = PropertyList(prop).PropertyValue;
          Text{trl} = PropertyValue;
          V = str2num(PropertyValue);
          if ~isempty(V)
              Values(trl) = V;
          end
          break;
      end
   end
end

end
