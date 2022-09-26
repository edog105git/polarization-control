myFilter = AnalogFilter('bessel', 5, 0.8);

x = randi([-1 1], 1, 100);
x_t = repelem(x, 9);

%% removeGD = false
y_1 = myFilter.filter(x_t, 9, false);

figure(1);
plot(x_t(1:90), 'LineWidth', 1.5, 'DisplayName', 'Original'); hold on;
plot(y_1(1:90), 'LineWidth', 1.5, 'DisplayName', 'Filtered');
xlabel('\itt'); title('removeGD = false'); legend();
%% removeGD = true
y_2 = myFilter.filter(x_t, 9, true);

figure(2);
plot(x_t(1:90), 'LineWidth', 1.5, 'DisplayName', 'Original'); hold on;
plot(y_2(1:90), 'LineWidth', 1.5, 'DisplayName', 'Filtered');
xlabel('\itt'); title('removeGD = true'); legend();