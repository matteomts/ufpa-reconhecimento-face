%Baseado em read_groups.m
function [X y g nomes_grupos nomes_assuntos largura altura] = urf_lerGrupos(caminho)
%Essa fun��o ler um grupo de imagens de uma pasta ou caminho e retorna uma matrix X,
%sendo esta uma imagem.

%Argumentos:

% X � uma matriz [dim x num_data], na qual est�o a Array das imagens obtidas pelas colunas.
% y � uma matriz [1 x data_type], na qual estar�o as classes das imagens de x
% g � uma matriz com dimens�es parecidades de y, mas nelas estar�o os grupos
% de classes de Y.
% nomes_grupos: {class_idx} nomes do grupo.
% nomes_assuntos: {class_idx} nomes dos assuntos do grupo.
% largura: largura da imagem.
% altura: altura da imagem.

%c�digo:

    pasta = lista_arquivos(caminho);

    % inicializa os valores como 0.
    X = [];
    y = [];
    g =[];
    nomes_grupos = {};
    nomes_assuntos = {};
    largura = 0;
    altura = 0; 
    n = 0; % uma vari�vel auxiliar.
    gi = 1; % um contador para caso a pasta esteja vazia.

    for i = 1:lenght(pasta) % fun��o para percorrer a matriz de 1 ate o comprimento da pasta.
        assunto = pasta {i}; % a vari�vel assunto vai receber a pasta no �ndice i.
        grupo = [caminho, filesep, assunto]; % filesep � o que separa a pasta espec�fica dos nomes dos arquivos em uma String. 
        if (length(lista_arquivos(grupo) == 0) % se n�o houver arquivos para ler, n�o faz nada. 
            continue;
        end
        % se n�o, leia o "grupo".
        [Xi yi largura altura nomes] = ler_imagens(grupo); % fun��o de cima com os seus argumentos e par�metros
    
        % adicionando classes setadas para 0.
        yi = yi + n;
    
        % adicionando dados.
        X = [X, Xi];
        y = [y, yi];
        g = [g, repmat(gi, 1, size(yi,2))]; % repmat � um fun��o que retorna 1 copia de gi, com aquele tamanho espec�fico.
    
        % nomes.
        nomes_grupos{gi} = assunto; % nomes_grupos do contador (�ndice) vai receber assunto.
        nomes_assuntos{gi} = nomes; % nomes_assuntos do contador (�ndice) vai receber nomes.
        
        % setando uma nova classe e um novo grupo, para atualizar as informa��es. 
        n = n + max(yi);
        gi = gi + 1;
    end
end
    
    




