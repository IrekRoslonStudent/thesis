%% Linearize Circuit to View Frequency Response of Nanodrum
% Linearization of the equivalent circuit for a porous graphene nanodrum 
% showing the frequency response to a sinusoidal drive.
%
% Modelling by Ireneusz Eugeniusz Roslon (2018)
% As part of the Master Thesis for Applied Physics
%
% Script based on example showing how you can view the small-signal 
% frequency response of a Simscape(TM) model by using linearization. 
% by The MathWorks, Inc.
%

%% Open the model and set circuit parameters
open_system('nanodrum')

%% Linearize
[a, b, c, d] = linmod('nanodrum');
clear simlog_check

%% Bode plot

% Settings
npts = 1200;
fr_low = 4;  % lower frequency limit                                                                                            
fr_high = 8; % upper frequency limit                
f_vect = logspace(fr_low, fr_high, npts);

% Code
G = zeros(1, npts);
for i = 1:npts
    G(i) = c*(2*pi*1i*f_vect(i)*eye(size(a))-a)^-1*b +d;
end

% Reuse figure if it exists, else create new figure
if ~exist('nanodrum_frequency_response', 'var') || ...
        ~isgraphics(nanodrum_frequency_response, 'figure')
    nanodrum_frequency_response = figure('Name', 'nanodrum_frequency_response');
end
figure(nanodrum_frequency_response)
clf(nanodrum_frequency_response)

% Figure 1
simlog_handles(1) = subplot(2, 1, 1);
magline_h = semilogx(f_vect, 20*log10(abs(G)));
grid
ylabel('Magnitude (dB)')
title('Frequency Response (Nanodrum)');
simlog_handles(2) = subplot(2, 1, 2);
phsline_h = semilogx(f_vect, 180/pi*unwrap(angle(G)));                                                                
set([magline_h phsline_h], 'LineWidth', 1);
legend({'Phase'});
ylabel('Phase (degrees)')
xlabel('Frequency (Hz)')
grid on
linkaxes(simlog_handles, 'x')

% Figure 2
figure(2)
semilogx(f_vect,real(G),f_vect,imag(G),'LineWidth', 1)
legend('Real','Imaginary')
title('Real-imaginary plot (Nanodrum)')
grid on

% Remove temporary variables
clear a b c d f_vect npts i 
clear simlog_handles


