% PE_Fault_Detection.m
% Verification of Requirements:
% SYS3-SW-FLT-DET-PE-001a: Monitor PE status at least once every 100 ms while plugged in.
% SYS3-SW-FLT-DET-PE-001b: Make PE fault status available to charging state machine and diagnostics.

clear; clc;

% --- Configuration ---
SampleTime = 0.05;      % 50 ms (Satisfies < 100 ms requirement)
SimulationDuration = 2.0; % seconds

% --- Dummy Shared Data Structures (Implementing Req 001b) ---
% These represent the interfaces to the Charging State Machine and Diagnostics Module
global Charging_State_Machine
global Diagnostics_Module

Charging_State_Machine.PE_Fault_Status = false;
Diagnostics_Module.PE_Fault_Status = false;

% Initialize Dummy Signals
Connector_Plugged_In = false; % Boolean: false = disconnected, true = plugged in
PE_Signal_Input = 1;          % Dummy Integer: 1 = Valid Ground, 0 = Fault/Open

fprintf('Starting PE Fault Detection Monitor...\n');
fprintf('Sample Time: %.3fs\n\n', SampleTime);
fprintf('%-8s | %-12s | %-10s | %-10s\n', 'Time', 'Plugged In', 'PE Input', 'Fault Out');
fprintf('%s\n', repmat('-', 1, 55));

% --- Main Execution Loop ---
for t = 0:SampleTime:SimulationDuration
    
    % --- 1. Simulate Input Changes (Test Scenarios) ---
    if t >= 0.5 && t < 1.5
        Connector_Plugged_In = true; % Plug in at 0.5s
    elseif t >= 1.5
        Connector_Plugged_In = true;
        PE_Signal_Input = 0;         % Simulate PE loss (Fault) at 1.5s
    end
    
    % --- 2. Requirement Logic Implementation ---
    
    % Req SYS3-SW-FLT-DET-PE-001a: Monitor... while plugged in
    if Connector_Plugged_In
        
        % Check the physical signal (Dummy logic)
        if PE_Signal_Input == 1
            current_fault_status = false; % No Fault
        else
            current_fault_status = true;  % Fault Detected
        end
        
    else
        % If not plugged in, fault status is cleared or not applicable
        current_fault_status = false;
    end
    
    % Req SYS3-SW-FLT-DET-PE-001b: Make status available
    Charging_State_Machine.PE_Fault_Status = current_fault_status;
    Diagnostics_Module.PE_Fault_Status = current_fault_status;
    
    % --- 3. Display Status (Verification) ---
    fprintf('%-8.2f | %-12d | %-10d | %-10d\n', ...
        t, Connector_Plugged_In, PE_Signal_Input, Charging_State_Machine.PE_Fault_Status);
end

fprintf('\nFinal Status in Diagnostics Module: %d\n', Diagnostics_Module.PE_Fault_Status);
