// baseado na KFoldCV.m
// nomes de algumas funcoes ainda em ingles pois elas sao de outras equipes, mudaremos no futuro.
function resultado_validacao = ufr_resultadoDaValidacao(X, y, k, fun_train, fun_predict, per_fold, print_debug)
  %%
	%% Realiza uma validação cruzada pelo método k-fold
	%%
	%% There may be a much simpler approach to do a Stratified K-Fold Cross validation, you 
	%% probably want to look at & translate the scikit-learn approach to MATLAB from:
	%% https://github.com/scikit-learn/scikit-learn/blob/master/sklearn/cross_validation.py
	%%
	%% Argumentos:
	%%  X [dim x num_data] Dataset onde a validação cruzada é realizada.
	%%	y	[1 x num_data] Classes correspondentes a observações em x.
	%%  k [1 x 1] numero de dobras
	%%  fun_train [function handle] função que constroi um modelo (__deve__ retornar um modelo)
	%%  fun_predict [function handle] função que obtem uma predição de um modelo.
	%%	per_fold [bool] se for por dobra, então os resultados são dados para cada dobra (default 1). 
	%%  print_debug [bool] print debug (default 0)
	%%
	%% Returns:
	%%  [tp, fp, tn, fn]: resultado da validação cruzada (por dobra ou acumulada)
	%% Example:
	%%  see example.m
	%%
	resultado_validacao = [];

	% set default options
	if ~exist('print_debug')
		print_debug = 0;
	end
	
	if ~exist('per_fold')
		per_fold=0;
	end

	% embaralha o array
	[d idx] = sort(rand(1, size(X,2)));
	X = X(:,idx);
	y = y(idx);
	
	% guarda o resultado da validação cruzada
	tp=0; fp=0; tn=0; fn=0;	

  % encontra as  classes unicas	
	C = max(y); % means y must be {1,2,3,...,C}
  % encontra o numero maximo e minimo de amostras por classe
  nmin = +inf;
  nmax = -inf;
	for i = 1:C
		idx = find(y==i);
		ni = length(idx);
    nmin = min(nmin,ni);
    nmax = max(nmax,ni);
  end
  % build fold indices
  foldIndices = zeros(C, nmax);
  for i = 1:C
    idx = find(y==i);
		foldIndices(i, 1:numel(idx)) = idx;
	end

  % adjust k (means there less than k examples in a class)
	if(nmin<k)
		k=nmin;
	end
	
	% instances per fold
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
		
		% reformata para linearizar o vetor novamente
		testIdx = reshape(testIdx, 1, numel(testIdx));
		trainIdx = reshape(trainIdx, 1, numel(trainIdx));
		
		% treina um modelo
		model = fun_train(X(:,trainIdx), y(:,trainIdx));
		
		% testa o modelo
		for idx=testIdx
			% evaluate model and return prediction structure
			prediction = fun_predict(model, X(:,idx));
			% if you want to count [tn, fn] please add your code here
			if(prediction == y(idx))
				tp = tp + 1;
			else
				fp = fp + 1;
			end
		end
		
		% se você deseja fazer um log de resultados em uma base por dobra
		if(per_fold)
			resultado_validacao = [resultado_validacao; [tp, fp, tn, fn]];
			tp=0; fp=0; tn=0; fn=0;
		end
	end
	
	% ou setar o resultado acumulado
	if(~per_fold)
		resultado_validacao = [tp, fp, tn, fn];
	end
end
