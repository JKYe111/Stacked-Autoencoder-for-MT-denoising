clear all; clc;

num_segments = 1000;  % Number of segments to generate

result_signal = [];

for seg_idx = 1:num_segments
    % Randomly choose waveform type
    waveform_type = rand();
    
    % Randomly generate common parameters for all segments
    zero_before = randi([0, 20]);
    zero_after = randi([0, 20]);
    wave_length = randi([5, 30]);

    amplitude = -100000 + 200000*rand();  % Amplitude: -100000 to 100000
    
    if waveform_type<0.5
        % Generate charging/discharging triangular wave
        tao = 0.1 + 0.9*rand();
        t_end = 0.5 + 2.5*rand();
        t_step = 0.01 + 0.05*rand();

        t = 0:t_step:t_end;

        if length(t)>wave_length
            t = t(1:wave_length);
        elseif length(t)<wave_length
            t_extend = t(end) + t_step:t_step:t(end) + (wave_length-length(t))*t_step;
            t = [t, t_extend];
        end
        
        % Generate charging/discharging triangular wave
        ca1 = -amplitude*(exp(-3*t/tao) - exp(-4*t/tao));

        if rand()>0.5
            wave = -ca1;
        else
            wave = ca1;
        end
        
        if rand()>0.5 && length(wave)<wave_length*0.75
            wave = [-wave, wave];
            if length(wave)>wave_length
                wave = wave(1:wave_length);
            elseif length(wave)<wave_length
                wave = [wave, zeros(1, wave_length - length(wave))];
            end
        end
    else
        % Generate sawtooth/triangle wave
        wave_param = rand();
        period = randi([5, 50]);
        phase_shift = rand()*2*pi;
        
        % Random waveform type selection
        wave_type = rand();
        t = 0:1:wave_length-1;
        
        % Generate waveform based on random parameters
        if wave_type < 0.6
            % Sawtooth/triangle wave
            wave = amplitude*sawtooth((2*pi/period)*t + phase_shift, wave_param);
        elseif wave_type<0.85
            % Sine wave
            wave = amplitude*sin((2*pi/period)*t + phase_shift);
        else
            % Mixed waveform: sawtooth + sine
            sawtooth_wave = sawtooth((2*pi/period)*t + phase_shift, wave_param);
            sin_wave = 0.3*sin((2*pi/(period/2))*t + phase_shift);
            wave = amplitude*(0.7*sawtooth_wave + 0.3*sin_wave);
        end
    end

    segment = [zeros(1, zero_before), wave, zeros(1, zero_after)];

    result_signal = [result_signal, segment];
end

figure('Position', [100, 100, 1200, 400]);
plot(result_signal(1:1000), 'LineWidth', 1.5); % Display first 1000 sampling points
xlabel('Sample Point');
ylabel('Amplitude');
title(sprintf('Concatenated 100 Random Waveform Segments (Total Length: %d)', length(result_signal)));
grid on;

% Display statistics
fprintf('Generation complete\n');
fprintf('Total length: %d samples\n', length(result_signal));
fprintf('Number of segments: %d\n', num_segments);
fprintf('Average segment length: %.2f samples\n', length(result_signal)/num_segments);
fprintf('Maximum amplitude: %.3f\n', max(result_signal));
fprintf('Minimum amplitude: %.3f\n', min(result_signal));