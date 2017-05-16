
tif_Files = dir('*.tif'); 
numfiles = length(tif_Files);
mydata = cell(1, numfiles);

    File_name='Analyzed';
    
   


 for n=1:numfiles;
    
    eriel1a=imread(tif_Files(n).name); 
    if n==1
        
    C=(2^16)*(double(eriel1a)/max(max(double(eriel1a))))-1;
    figure;imshow(uint16(C));
    i=1;
    Handle_Polygon(i)=impoly;
    Mask(:,:,i)=createMask(Handle_Polygon(i));
    Mask_Cell= Mask(:,:,1);
   Mask2=Mask_Cell*0+1;
   jj=find(Mask_Cell==1);
   Mask2(jj)=NaN;
   y1=double(double(eriel1a).*Mask2);
        
        u=size(y1);
        max_X=u(2);
        max_Y=u(1);
        
        for i=1:max_Y
            X4(i,1:max_X)=1:max_X;
        end
        
        for i=1:max_X
            Y4(1:max_Y,i)=1:max_Y;
        end
        X_reshaped=reshape(X4,1,[]);
        Y_reshaped=reshape(Y4,1,[]);
        Image_reshaped = reshape(y1,1,[]);
        
        ft = fittype( 'poly22' );
        opts = fitoptions( ft );
        opts.Robust = 'Bisquare';
        opts.Weights = zeros(1,0);
        
        ok_y = isfinite(Image_reshaped) ;
        
        %%% Find y strain
        [fitresult_Image_reshaped, gof_Image_reshaped] = fit( [X_reshaped(ok_y)', Y_reshaped(ok_y)'], Image_reshaped(ok_y)', ft, opts );
        
        
        for i=1:max_Y
            Corrected(i,1:max_X)=fitresult_Image_reshaped(1:max_X,i);
        end
    
         
    end
    y1=double(eriel1a);
    y2=y1./Corrected -1;
    
    % % smooth/average here before removing noise
    %
    % %# Create the gaussian filter with hsize = [5 5] and sigma = 2
    % G = fspecial('gaussian',[5 5],1.5);
    % %# Filter it
    % Ig = imfilter(y2,G,'same');
    % %%%%%
    % % how do we automate this?
    % figure;hist(reshape(Ig,[],1),251); %find peak of real data and peak of noise
    % gg2a2=find(Ig<0.0305); % mid-way between peak of data andpeak of noise
    % Ig2=Ig;
    % Ig2(gg2a2)=0;
    % %%%%%
    % Ig3=Ig2*255/max2(Ig2);
    % Ig4=uint8(Ig3);
    % imwrite(Ig4,'Ig4.tif','tif');
    imwrite(uint8(255*((y2-min(min(y2)))/(max(max(y2))-min(min(y2))))),[File_name  num2str(n)],'tif')
    n
end
    
    
