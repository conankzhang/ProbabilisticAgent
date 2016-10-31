function action = CS4300_MC_agent(percept)
% CS4300_MC_agent - Monte Carlo agent with a few informal rules
% On input:
%     percept (1x5 Boolean vector): percept from Wumpus world
%       (1): stench
%       (2): breeze
%       (3): glitter
%       (4): bump
%       (5): scream
% On output:
%     action (int): action to take
%       1: FORWARD
%       2: RIGHT
%       3: LEFT
%       4: GRAB
%       5: SHOOT
%       6: CLIMB
% Call:
%     a = CS4300_MC_agent(percept);
% Author:
%     T. Henderson
%     UU
%     Fall 2016
%

FORWARD = 1;
RIGHT = 2;
LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

persistent safe pits Wumpus board have_gold have_arrow plan
persistent agent frontier visited t

if isempty(agent)
    t = 0;
    agent.x = 1;
    agent.y = 1;
    agent.dir = 0;
    safe = -ones(4,4);
    pits = -ones(4,4);
    Wumpus = -ones(4,4);
    board = -ones(4,4);
    visited = zeros(4,4);
    frontier = zeros(4,4);
    safe(4,1) = 1;
    pits(4,1) = 0;
    Wumpus(4,1) = 0;
    board(4,1) = 0;
    visited(4,1) = 1;
    have_gold = 0;
    have_arrow = 1;
end

if have_gold==1&~isempty(plan)
    action = plan(1);
    plan = plan(2:end);
    return
end

% incorporate new percepts
% update info
% find safest place to go

if percept(3)==1
    plan = [GRAB];
    have_gold = 1;
    [so,no] = CS4300_Wumpus_A_star(abs(board),...
        [agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
    plan = [plan;so(2:end,4)];
    plan = [plan;CLIMB];
end

if isempty(plan)
    [cand_rows,cand_cols] = find(frontier==1&safe==1&visited==0);
    if ~isempty(cand_rows)
        cand_x = cand_cols;
        cand_y = 4 - cand_rows + 1;
        [so,no] = CS4300_Wumpus_A_star(abs(board),...
            [agent.x,agent.y,agent.dir],...
            [cand_x(1),cand_y(1),0],'CS4300_A_star_Man');
        plan = [so(2:end,4)];
    end
end

% No Wumpus shot yet
if have_arrow==1&isempty(plan)
    plan = CS4300_plan_shot(agent,Wumpus,visited,safe,board);
end

% Take a risk
if isempty(plan)
    [cand_rows,cand_cols] = find(frontier==1);
    cand_x = cand_cols;
    cand_y = 4 - cand_rows + 1;
    temp_board = board;
    temp_board(cand_rows(1),cand_cols(1)) = 0;
    [so,no] = CS4300_Wumpus_A_star(abs(temp_board),...
        [agent.x,agent.y,agent.dir],...
        [cand_x(1),cand_y(1),0],'CS4300_A_star_Man');
    plan = [so(2:end,4)];
end

action = plan(1);
plan = plan(2:end);

% Update agent's idea of state
agent = CS4300_agent_update(agent,action);
visited(4-agent.y+1,agent.x) = 1;

if action==SHOOT
    have_arrow = 0;
end

tch = 0;