function main
    % Créer la figure principale
    fig = uifigure('Name', 'Menu Principal', 'Position', [100, 100, 600, 700]);

   % Liste déroulante pour les options de menu
    menuLabel = uilabel(fig, 'Text', 'Choisissez une option :', 'Position', [50, 650, 200, 20]);
    menuDropdown = uidropdown(fig, ...
        'Items', {'1. Image personnalisée',...
                  '2. Créer une image noire',...
                  '3. Créer une image blanche',...
                  '4. Créer une image noir et blanc',...
                  '5. Calculer la luminance d''une image', ...
                  '6. Calculer le contraste d''une image', ...
                  '7. Trouver la profondeur d''une image', ...
                  '8. Afficher la matrice d''une image', ...
                  '9. Inverser les tons d''une image', ...
                  '10. Symétrie verticale', ...
                  '11. Fusion verticale de deux images', ...
                  '12. Fusion horizontale de deux images', ...
                  '13. Image RGB aléatoire', ...
                  '14. Symétrie personnalisée', ...
                  '15. Convertir en niveaux de gris'}, ...
        'Position', [50, 620, 500, 30]);

    % Bouton d'action
    executeButton = uibutton(fig, 'Text', 'Exécuter', ...
        'Position', [50, 580, 500, 30], ...
        'ButtonPushedFcn', @(btn, event) executeAction(menuDropdown.Value, fig));

    endButton = uibutton(fig, 'Text', 'Quitter', ...
    'Position', [500, 60, 50, 40], ... % [x, y, width, height]
    'ButtonPushedFcn', @(btn, event)  delete(fig));
    


   % Axes pour l'affichage des images
    ax = uiaxes(fig, 'Position', [50, 100, 500, 450]);
    ax.XTick = [];
    ax.YTick = [];
    ax.Box = 'on'; %Affiche un cadre autour des axes graphiques

    fig.UserData = struct('Axes', ax);  %stocker des données personnalisées associées à l'objet, sous n'importe quelle forme
end

function executeAction(selectedOption, fig)
    % Accéder aux axes
    ax = fig.UserData.Axes;

    switch selectedOption
        case '1. Image personnalisée' 
           % Boîte de dialogue de sélection de fichier
            [file, path] = uigetfile({'*.jpg;*.bmp', 'Image Files'});
            if isequal(file, 0)% Si l'utilisateur annule
                return; 
            end
            img = imread(fullfile(path, file));
            imshow(img, 'Parent', ax);

        case '2. Créer une image noire'
            dims = inputdlg({'Entrez la hauteur de l''image :', 'Entrez la largeur de l''image :'}, ...
                             'Dimensions de l''image', [1 50], {'256', '256'});
            if isempty(dims), return; end % Si l'utilisateur annule
            h = str2double(dims{1});
            l = str2double(dims{2});
            noire = zeros(h,l);
            imshow(noire, 'Parent', ax);

        case '3. Créer une image blanche'
            dims = inputdlg({'Entrez la hauteur de l''image :', 'Entrez la largeur de l''image :'}, ...
                              'Dimensions de l''image', [1 50], {'256', '256'});
            if isempty(dims), return; end % Si l'utilisateur annule
            h = str2double(dims{1});
            l = str2double(dims{2});
            blanche = ones(h,l) * 255;
            imshow(blanche, 'Parent', ax);

        case '4. Créer une image noir et blanc'
           % Boîte de dialogue de saisie des dimensions de l'image
            dims = inputdlg({'Entrez la hauteur de l''image :', 'Entrez la largeur de l''image :'}, ...
                            'Dimensions de l''image', [1 50], {'256', '256'});
            if isempty(dims), return; end 
            h = str2double(dims{1});
            l = str2double(dims{2});
            noirblanc = creerImgBlancNoir(h, l); % Fonction personnalisée
            negatifImg = negatif(noirblanc);
            imshow(noirblanc, [], 'Parent', ax);
            bx = uiaxes(fig, 'Position', [550, 100, 500, 450]);
            bx.XTick = [];
            bx.YTick = [];
            bx.Box = 'on';

            imshow(negatifImg, [], 'Parent', bx);
            pause(10)
            cla(bx);
           
        case '5. Calculer la luminance d''une image'
            % Boîte de dialogue de saisie des dimensions de l'image
            [file, path] = uigetfile({'*.jpg;*.bmp', 'Image Files'});
            if isequal(file, 0), return; end 
            img = lectureImage(fullfile(path, file));% Fonction personnalisée
            lum = luminance(img); % Fonction personnalisée
            imshow(img, [], 'Parent', ax);
            txtHandle = uicontrol(fig,'Style', 'text', ...
                      'String', 'Default Text', ...
                      'Position', [20, 40, 200, 70], ... % [x, y, width, height]
                      'FontSize', 12, ...
                      'HorizontalAlignment', 'left');
            set(txtHandle, 'String', sprintf('La luminance est : %f',lum));
            pause(10)
            set(txtHandle, 'String', '');

        case '6. Calculer le contraste d''une image'
            [file, path] = uigetfile({'*.jpg;*.bmp', 'Image Files'});
            if isequal(file, 0), return; end
            img = lectureImage(fullfile(path, file));
            cont = my_constrast(img); % Fonction personnalisée
            txtHandle = uicontrol(fig,'Style', 'text', ...
                      'String', 'Default Text', ...
                      'Position', [20, 40, 200, 70], ... % [x, y, width, height]
                      'FontSize', 12, ...
                      'HorizontalAlignment', 'left');
            set(txtHandle, 'String', sprintf('le contraste est : %.2f',cont));
            imshow(img, [], 'Parent', ax);
            pause(10)
            set(txtHandle, 'String', '');

        case '7. Trouver la profondeur d''une image'
            [file, path] = uigetfile({'*.jpg;*.bmp', 'Image Files'});
            if isequal(file, 0), return; end
            img = lectureImage(fullfile(path, file));
            depth = profondeur(img); % Fonction personnalisée
            txtHandle = uicontrol(fig,'Style', 'text', ...
                      'String', 'Default Text', ...
                      'Position', [20, 40, 200, 70], ... % [x, y, width, height]
                      'FontSize', 12, ...
                      'HorizontalAlignment', 'left');
            set(txtHandle, 'String', sprintf('La profondeur est : %.2f',depth));
            imshow(img, [], 'Parent', ax);
            pause(10)
            set(txtHandle, 'String', '');

        case '8. Afficher la matrice d''une image'
            [file, path] = uigetfile({'*.jpg;*.bmp', 'Image Files'});
            if isequal(file, 0), return; end
            img = ouvrir(fullfile(path, file)); 
            save_path = uigetdir;
            imshow(img, [], 'Parent', ax);
            % Ouvrir le fichier pour l'écriture
            fid = fopen(save_path + "/matrix2.txt", 'w');
            
            % Écrire la matrice dans le fichier ligne par ligne
            for i = 1:size(img, 1)
                fprintf(fid, '%d ', img(i, :)); % Écrivez chaque ligne avec des valeurs séparées par des espaces
                fprintf(fid, '\n');            % Nouvelle ligne après chaque ligne
            end
            
            % Fermer le fichier
            fclose(fid);

        case '9. Inverser les tons d''une image'
            [file, path] = uigetfile({'*.jpg;*.bmp', 'Image Files'});
            if isequal(file, 0), return; end
            img = lectureImage(fullfile(path, file));
            imgInverse = inverser(img); 
            imshow(imgInverse, [], 'Parent', ax);

        case '10. Symétrie verticale'
            [file, path] = uigetfile({'*.jpg;*.bmp', 'Image Files'});
            if isequal(file, 0), return; end
            img = lectureImage(fullfile(path, file));
            imgFlip = flipH(img); 
            imshow(imgFlip, [], 'Parent', ax);

        case '11. Fusion verticale de deux images'
            % Select two images
            [file1, path1] = uigetfile({'*.jpg;*.bmp', 'Image Files'}, 'Select First Image');
            if isequal(file1, 0), return; end
            img1 = lectureImage(fullfile(path1, file1));

            [file2, path2] = uigetfile({'*.jpg;*.bmp', 'Image Files'}, 'Select Second Image');
            if isequal(file2, 0), return; end
            img2 = lectureImage(fullfile(path2, file2));
            [a1,b1]=size(img1);
            [a2,b2]=size(img2);
            if a1==a2 && b1==b2 
                fusion = poserV(img1, img2);
                imshow(fusion, [], 'Parent', ax);  
            else
                uialert(fig, 'Une erreur (les deux image de taille différente) .', 'Erreur', ...
                      'Icon', 'error', ...
                    'CloseFcn', @(src, event) disp('Fenêtre fermée'));
            end

        case '12. Fusion horizontale de deux images'
            [file1, path1] = uigetfile({'*.jpg;*.bmp', 'Image Files'}, 'Select First Image');
            if isequal(file1, 0), return; end
            img1 = lectureImage(fullfile(path1, file1));

            [file2, path2] = uigetfile({'*.jpg;*.bmp', 'Image Files'}, 'Select Second Image');
            if isequal(file2, 0), return; end
            img2 = lectureImage(fullfile(path2, file2));
            [a1,b1]=size(img1);
            [a2,b2]=size(img2);
            if a1==a2 && b1==b2 
                fusion = poseH(img1, img2); 
                imshow(fusion, [], 'Parent', ax);
 
            else
                uialert(fig, 'Une erreur (les deux image de taille différente) .', 'Erreur', ...
                      'Icon', 'error', ...
                    'CloseFcn', @(src, event) disp('Fenêtre fermée'));
            end
            
        case '13. Image RGB aléatoire'
            dims = inputdlg({'Entrez la hauteur :', 'Entrez la largeur :'}, 'Dimensions', [1 50], {'256', '256'});
            if isempty(dims), return; end
            h = str2double(dims{1});
            l = str2double(dims{2});
            rgb = initImageRGB(h, l); 
            imshow(rgb, [], 'Parent', ax);

        case '14. Symétrie personnalisée'
            [file, path] = uigetfile({'*.jpg;*.bmp', 'Image Files'});
            if isequal(file, 0), return; end
            img = lectureImage(fullfile(path, file));
            axe = questdlg('Choisissez l''axe  de symetrie :','Symetrie personnalisee' ,'horizontal', 'verticale', 'horizontal');
            if isempty(axe), return; end
            imgSym = symetrie(img, axe); 
            imshow(imgSym, [], 'Parent', ax);

        case '15. Convertir en niveaux de gris'
            [file, path] = uigetfile({'*.jpg;*.bmp', 'Image Files'});
            if isequal(file, 0), return; end
            rgb = lectureImage(fullfile(path, file));
            imggris = grayscale(rgb); 
            imshow(imggris, [], 'Parent', ax);
    end
end
