// baseado na KFoldCV.m
// nomes de algumas funcoes ainda em ingles pois elas sao de outras equipes, mudaremos no futuro.
function idx = ufr_resultadoDaValidacao(X, y, k, fun_train, fun_predict, per_fold, print_debug)
  %%
	%%Realiza uma validação cruzada do tipo k-fold 
	%%
	%% There may be a much simpler approach to do a Stratified K-Fold Cross validation, you 
	%% probably want to look at & translate the scikit-learn approach to MATLAB from:
	%% https://github.com/scikit-learn/scikit-learn/blob/master/sklearn/cross_validation.py
	%%
	%% Args:
	%%  X [dim x num_data] Dataset a k-fold cross validation is performed on.Banco de dados onde a validação cruzada do tipo K-fold é realizada
	%%	y	[1 x num_data] Classes corresponding to observations in X.
	%%  k [1 x 1] number of folds
	%%  fun_train [function handle] função para construir um modelo (__must__ return a model)
	%%  fun_predict [function handle] function to get a prediction from a model.
	%%	per_fold [bool] if per fold, then results are given for each fold (default 1). 
	%%  print_debug [bool] print debug (default 0)
	%%
	%% Retorna:
	%%  [tp, fp, tn, fn]: resultado da validação cruzada (per fold or accumulated)
	%% Exemplo:
	%%  veja exemplo.m
	%%
	resultado_da_validacao = [];
	
	
		% seta as opcoes padrao
	if ~exist('print_debug')
		print_debug = 0;
	end
	
	if ~exist('per_fold')
		per_fold=0;
	end

	% embaralha o array (is there a function for this?)
	[d idx] = sort(rand(1, size(X,2)));
	X = X(:,idx);
	y = y(idx);
	
	% guarda o resultado da validacao cruzada
	tp=0; fp=0; tn=0; fn=0;

  % find the unique classes (TODO make all this independent of any label order)	
	C = max(y); % significa que y deve ser {1,2,3,...,C}
  % encontra o número mínimo e máximo de classes por amostra
  nmin = +inf;
  nmax = -inf;
	for i = 1:C
		idx = find(y==i);
		ni = length(idx);
    nmin = min(nmin,ni);
    nmax = max(nmax,ni);
  end
  % constroi o indice das dobras
  foldIndices = zeros(C, nmax);
  for i = 1:C
    idx = find(y==i);
		foldIndices(i, 1:numel(idx)) = idx;
	end
	
	  % ajuste de k (verifica se há menos de k exemplos em uma classe)
	if(nmin<k)
		k=nmin;
	end
	
	% instâncias por dobra
	foldSize = floor(nmin/k);
	
	% calculate fold indices for Testset A, Trainingset B
	for i = 0:(k-1)
		%
		% Works like this:
		% (1) class1|ABBBBBBBBB| (2) class1|BABBBBBBBB| (k) ...
		%	    class2|ABBBBBBBBB|     class2|BABBBBBBBB|
		%     classN|ABBBBBBBBB|     classN|BABBBBBBBB|
		%
		if(print_debug)
			fprintf(1,'Processing fold %d.\n', i);
			if isoctave()
				fflush(stdout);
			end
		end

		l = i*foldSize+1;
		h = (i+1)*foldSize;
		testIdx = foldIndices(:, l:h);
		trainIdx = foldIndices(:, [1:(l-1), (h+1):nmin]);
		
		% forma vermelha to linearizar o vetor novamente
		testIdx = reshape(testIdx, 1, numel(testIdx));
		trainIdx = reshape(trainIdx, 1, numel(trainIdx));
		
		% treina um modelo
		model = fun_train(X(:,trainIdx), y(:,trainIdx));
		
		% testa um modelo
		for idx=testIdx
			% avalia o modelo e retorna uma estrutura prevista
			prediction = fun_predict(model, X(:,idx));
			% Se você deseja contar [tn, fn] por favor insira seu código aqui
			if(prediction == y(idx))
				tp = tp + 1;
			else
				fp = fp + 1;
			end
		end


		% se você quer salvar os resultados em uma base de dados
		if(per_fold)
			validation_result = [validation_result; [tp, fp, tn, fn]];
			tp=0; fp=0; tn=0; fn=0;
		end
	end
	
	%ou definir um resultado acumulado
	if(~per_fold)
		validation_result = [tp, fp, tn, fn];
	end
end
