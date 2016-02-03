% set backup handle
backend = CAMP.MWC;

% find length of x and y vector
xv = sortrows(backend.measuredPoints,2);
yv = sortrows(backend.measuredPoints,1);

xl = find(xv(:,2) - min(xv(:,2)),1)  - 1;
yl = find(yv(:,1) - min(yv(:,1)),1)  - 1;
    if ~xl
        xl = 1;
    end

    if ~yl
        yl = 1;
    end
    
% x and y vector
x = xv(1:xl,1);
y = yv(1:yl,2);

% select data
data = backend.measuredLossC; % loss coefficient
%data = backend.measuredAngles(:,2); % pitch angle
%data = backend.measuredAngles(:,1); % yaw angle
%data = backend.measuredVelocity; % velocity of axial compressor
%data = backend.measuredW2w1; % velocity ratio

% plot
figure(10);
surf(x,y,reshape(data,xl,yl)');