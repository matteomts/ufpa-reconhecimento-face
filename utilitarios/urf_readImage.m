function X = urf_readImage(filename)
    % lê uma imagem e retorna um vetor representando a imagem (já convertida pra escala de cinza)
    %
    % espera:
    % |filename| o nome da imagem pra ler
    %
    % retorna:
    % |X| um vetor representando a imagem
    X = [];
	try
		X = double(imread(filename));
		[height width channels] = size(X);
		% greyscale the image if we have 3 channels
		if(channels == 3)
			X = (X(:,:,1) + X(:,:,2) + X(:,:,3)) / 3;
		end
		X = reshape(X,width*height,1);
	catch
		lerr = lasterror;
		fprintf(1,'Cannot read image %s.\nReason:\n%s\n', filename, lerr);
	end
end