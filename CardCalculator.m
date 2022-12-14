
elementSize = 256;
cardSize = [ceil( elementSize * (5 + sqrt(2))) 0] + 10;
cardSize(2) = cardSize(1);
backgroundColor = [255, 235, 205]/255;
skin = "Fish";
deck = "deck2";

cards = zeros(uint16(cardSize(1)), uint16(cardSize(2)), 3, 40);
elementPictures = getElementPictures(skin, elementSize);
cardElements = getCardElements();


for cardIndex = 1:40

    thisCardsElements = cardElements(cardIndex,:);
    

    for cardPositionIndex = 0 : 12
        elementIndex = thisCardsElements(cardPositionIndex+1); 
        element = elementPictures(:,:,:,elementIndex);
        rotatedElement = imrotate(element, rand()*360, 'nearest', 'loose');
        rotatedSize = length(rotatedElement);
        halfRotSize = floor(rotatedSize/2);
        center = cardSize/2;
        

        if(cardPositionIndex == 0)
            dx = 0;
            dy = 0;
        else
            if(ismember(cardPositionIndex, 1:6))
                radius = elementSize * 1.5;
                angle = 0;
            else
                radius = elementSize * 2.5;
                angle = 30;
            end
            angle = mod(cardPositionIndex, 6) * 60 + angle;
            
            dx = floor(radius * cosd(angle));
            dy = floor(radius * sind(angle));

        end
        
        startPoint = uint16( center  + [dx dy] - halfRotSize);
        endPoint = uint16(center + [dx dy] + rotatedSize - halfRotSize - 1);
        cards(startPoint(1) : endPoint(1),startPoint(2) : endPoint(2), :, cardIndex) = rotatedElement;

    end 
    
    for i = 1 : cardSize(1)
        for j = 1: cardSize(2)
            if(all(cards(i,j,:,cardIndex)== 0))
                cards(i,j,:,cardIndex) = backgroundColor;
            end
        end
    end

    if(mod(cardIndex,5) == 0)
        disp("Creating cards:" + cardIndex + "/" + 40);
    end
end



folder = "cards\" + skin + "\" + deck;
if ~exist(folder, 'dir')
   mkdir(folder)
end

for cardIndex = 1:40
    card = cards(:,:,:,cardIndex);
    finalisedCard = imresize(card, 4, 'bicubic');
    imwrite(finalisedCard, folder + "\" + num2str(cardIndex) + ".png");
    if(mod(cardIndex,5) == 0)
        disp("Writing cards:" + cardIndex + "/" + 40);
    end
end

subplot(1,3,1), imshow(cards(:,:,:,1))
subplot(1,3,2), imshow(cards(:,:,:,2))
subplot(1,3,3), imshow(cards(:,:,:,3))