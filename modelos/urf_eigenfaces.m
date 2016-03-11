function model = urf_eigenfaces(X, y, num_eigenfaces)
  % Faz a extração das eigenfaces das vetores em X
  %
  % espera:
  % |X| sendo a matriz com cada vetor uma imagem
  % |y| sendo as classes correspondentes de cada imagem
  % |num_eigenfaces| o número de eigenfaces para 'armazenar'
  %
  % retorna:
  % uma estrutura |model| com os seguites atributos
  %   .name: o nome do das eigenfaces // acho que não é necessário
  %   .mu: um vetor com a imagem média de |X|
  %   .num_eigenfaces: número de eigenfaces
  %   .W: uma matriz com as eigenfaces retiradas de cada vetor de |X|
  %   .P: a projeção de |X| // não entendi
  
  if(nargin < 3)
    num_eigenfaces=size(X,2)-1;
  end
  % perform pca
  Pca = urf_pca(X, num_eigenfaces);
  % build model
  model.name = 'eigenfaces';
  model.D = Pca.D;
  model.W = Pca.W;
  model.num_eigenfaces = num_eigenfaces;
  model.mu = Pca.mu;
  % project data
  model.P = model.W'*(X - repmat(Pca.mu, 1, size(X,2)));
  % store classes
  model.y = y;
end