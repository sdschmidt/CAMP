function [p_volt] = measure_now(a, n_sample, delta_t, pinmap)
% a: the arduino object
% n_sample: number of samples
% delta_t : timestep between the samples
% pinmap: list of pins to read from, eg [0 1 2 3 4 5 6 7 8]
    p_volt = zeros(1,numel(pinmap));
    for i=1:n_sample
        pause(delta_t);
        for j = 1:numel(pinmap)
        p_volt(j) = p_volt(j) +  a.analogRead(pinmap(j));
        end
    end
    p_volt = p_volt / n_sample;
end
