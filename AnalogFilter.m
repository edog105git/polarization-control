% TODO: look at group delay removal
classdef AnalogFilter
    properties
        type                % filter type {'super-gaussian', 'bessel'}
        order               % filter order
        f3dB                % 3dB cutoff
        gd                  % group delay
        H                   % frequency response 
    end

    methods
        function obj = AnalogFilter(type, order, f3dB)
            % Constructor
            obj.type = type;
            obj.order = order;
            obj.f3dB = f3dB;
            
            switch obj.type
                case 'super-gaussian'
                    obj.H = @(f) exp(-log(2)*((2*f)/obj.f3dB).^(2*obj.order));
                case 'bessel'
                    besfact = [1.000, 1.272, 1.405, 1.515, 1.621];
                    [b, a] = besself(obj.order, 2*pi*besfact(obj.order)*obj.f3dB);
                    obj.H = @(f) polyval(b, 1j*2*pi*f)./polyval(a, 1j*2*pi*f);
                otherwise
            end
        end
        
        function plot_H(obj, fs, N)
            %plot_H(obj, fs) Plots magnitude and phase of frequency
            %response
            % INPUT
            % fs : sampling frequency
            % N  : number of plotting points
            f = linspace(-fs/2, fs/2, N);
            figure();
            subplot(211);
            plot(f/1e9, 20*log10(abs(obj.H(f))), 'LineWidth', 1.5);
            title('Magnitude'); ylabel('|H(f)| (dB)'); xlabel('f (GHz)');
            grid();
            subplot(212);
            plot(f/1e9, angle(obj.H(f)), 'LineWidth', 1.5);
            title('Phase'); ylabel('<H(f) (rad)'); xlabel('f (GHz)');
            grid();
        end

        function y = filter(obj, x, fs, removeGD)
            %filter(obj, x, fs) Filters given signal x with sampling
            %frequency fs. If removeGD = True, input and ouput of filter is
            %aligned. I.e., the group delay is removed.
            N = size(x, 2);                     % number of time points
            f = linspace(-fs/2, fs/2, N);       % frequency vector
            
            X = fftshift(fft(x));               % signal spectrum
            Y = X.*obj.H(f);                    % filtered signal spectrum
            y = real(ifft(ifftshift(Y)));       % filtered signal

            if removeGD
                [c, ind] = xcorr(x, y);
                [~, p] = max(abs(c));
                y = circshift(y, ind(p));
            end
        end
    end
end