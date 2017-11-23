function parameters = GetFriendParameters(pos, vel, nNeighbors)
% get parameters for agents based on the information provided from the friendly
% agents

RTP = GetRTP(pos, vel, pos, vel, nNeighbors+1);
parameters = RTP(4:end,:);