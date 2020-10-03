% ===================
% Filename: Kohonen.m
% ===================

echo on;

% ===================================
% Kohonen self-organising feature map
% ===================================

% ============================================================================
% Reference: Negnevitsky, M., "Artificial Intelligence: A Guide to Intelligent  
%            Systems", 3rd edn. Addison Wesley, Harlow, England, 2011.
%            Sec. 6.8 Self-organising neural networks
% ============================================================================

% ============================================================================
% Problem: The Kohonen self-organising map is required to classify two-element
%          input vectors occurring in a two-dimensional input space.
% ============================================================================

% Hit any key to create 200 two-dimensional input vectors randomly distributed 
% in a square region.
pause

rand('seed',1234);
p=rands(2,200);
plot(p(1,:),p(2,:),'r.')
title('Input vectors');
xlabel('p(1)');
ylabel('p(2)');

% Hit any key to create and initialise the Kohonen network with 36 neurons
% arranged in the form of a two-dimensional lattice with 6 rows and 6 columns.
pause

s1=6; s2=6;
net=newsom(p,[s1 s2]);
net.iw{1,1}=ones(size(net.iw{1,1}));
plotsom(net.iw{1,1},net.layers{1}.distances)

% Each neuron is represented by a red dot at the location of its two weights. 
% The initiall weights are assigned to zero, so only a single dot appears.  

% Hit any key to train the Kohonen network on the 200 vectors for 5 epochs. 
pause

echo off;

net.trainParam.showWindow = false;
net.trainParam.epochs=1;

for i=1:100
    net=train(net,p);
    delete(findobj(gcf,'color',[1 0 0]));
    delete(findobj(gcf,'color',[0 0 1]));
    plotsom(net.IW{1,1},net.layers{1}.distances);
    title(['Weight vectors, Epoch # ',num2str(net.trainParam.epochs)]);
    pause(0.1)
    net.trainParam.epochs=net.trainParam.epochs + 1;
end

for i=1:(s1*s2);
   text(net.iw{1,1}(i,1)+0.02,net.iw{1,1}(i,2),sprintf('%g',i));
end

echo on;

% After training the Kohonen layer becomes self-organised so that each neuron 
% can now classify a different region of the input space.
%
% Hit any key to apply the Kohonen network for the classification of a randomly
% generated 2-element input vector. The vector is identified by the green marker.
%
% The output denoted by "a" indicates which neuron is responding. 
pause

for i=1:3
   probe=rands(2,1);
   hold on;
   plot(probe(1,1),probe(2,1),'.g','markersize',25);
   a=sim(net,probe);
   a=find(a)
   text(probe(1,1)+0.03,probe(2,1),sprintf('%g',(a)));
   hold off
   % Hit any key to continue.
   if i<3
      pause
   end
end

echo off
disp('end of Kohonen.m')