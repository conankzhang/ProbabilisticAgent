function [pits,wumpus] = CS4300_WP_estimates(breezes,stench,num_trials)
% CS4300_WP_estimates - estimate pit and Wumpus likelihoods
% On input:
% breezes (4x4 Boolean array): presence of breeze percept at cell
% -1: no knowledge
% 0: no breeze detected
% 1: breeze detected
% stench (4x4 Boolean array): presence of stench in cell
% -1: no knowledge
% 0: no stench detected
% 1: stench detected
% num_trials (int): number of trials to run (subset will be OK)
% On output:
% pits (4x4 [0,1] array): likelihood of pit in cell
% Wumpus (4x4 [0 to 1] array): likelihood of Wumpus in cell
% Call:
% breezes = -ones(4,4);
% breezes(4,1) = 1;
% stench = -ones(4,4);
% stench(4,1) = 0;
% [pts,Wumpus] = CS4300_WP_estimates(breezes,stench,10000)
% pts =
% 0.2021 0.1967 0.1956 0.1953
% 0.1972 0.1999 0.2016 0.1980
% 0.5527 0.1969 0.1989 0.2119
% 0 0.5552 0.1948 0.1839
%
% Wumpus =
% 0.0806 0.0800 0.0827 0.0720
% 0.0780 0.0738 0.0723 0.0717
% 0 0.0845 0.0685 0.0803
% 0 0 0.0741 0.0812
% Author:
% Rajul Ramchandani and Conan Zhang
% UU
% Fall 2016
%


is_wumpus=1;

if stench == zeros(4,4)
    is_wumpus = 0;
end

pits = zeros(4,4);
wumpus = zeros(4,4);
s = 0;
while s<num_trials
    board = CS4300_gen_board(0.2);
    if(is_wumpus==0)%generate boards without a wumpus if stench board is all zeros, i.e wumpus has been killed
        [rows,cols] = find(board>=3);
        board(rows,cols)= 0;
    end
    if CS4300_WP_satisfies(breezes, stench, board)
        s=s+1; %increment only if satisfied
        [rows, cols] = size(board);
        for r= 1:rows
            for c = 1:cols
                if board(r,c)==1 %if pit
                    pits(r,c) = pits(r,c)+1;
                elseif board(r,c)>=3 %if wumpus
                    wumpus(r,c) = wumpus(r,c)+1;
                end
            end
        end
    end
end

pits = pits/num_trials;
wumpus = wumpus/num_trials;
    
