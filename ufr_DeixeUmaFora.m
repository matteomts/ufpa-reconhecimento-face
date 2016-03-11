// baseado na LeaveOneOutCV.m
function idx = ufr_DeixeUmaFora(X, y, fun_train, fun_predict, print_debug)// nomes de algumas funcoes ainda em ingles pois elas sao de outras equipes, mudaremos no futuro.
function  validation_result = LeaveOneOutCV ( X , Y , fun_train , fun_predict , print_debug )
	%% Executa uma validação Leave-One-Out-Cross.
	%%
	%% Args:
	%% Ver KFoldCV.m
	
	if (~ exist ( ' print_debug ' ))  %% aqui a função verifica se há algum erro na verificação do código
		print_debug = 0 ;
	end
	
	dataset% Shuffle   Representa dados em um cache de memória.
	[d idx] = sort ( rand ( 1 , size (X, 2 )));   %% aqui faz uma leitura na matriz
	X = X (:, idx);
	y = y (idx);
	
	tp = 0 ; fp = 0 ; tn = 0 ; fn = 0 ;
	n = length (y);
	for  i = 1 : n
		if (print_debug)
			fprintf ( 1 , ' Processamento dobra % d / % d . \ n ' , i , n);
			if isoctave ()
				fflush (stdout);
			end
		end
		
		Xi = X (:, 1 ); X (:, 1 ) = [];
		yi = y ( 1 ); Y ( 1 ) = [];
	  
		model = fun_train (x, y);
		previsão = fun_predict (modelo, Xi);

		%% Se quiser contar [tn, fn] adicione o seu código aqui
		if (predição == yi)
			tp = tp +  1 ;
		else
			fp = fp +  1 ;
		end
		
		% Adicionar para testar final instância de lista
		X = [X, Xi];
		y = [Y, Yi];
	end
		
	validation_result = [tp fp tn fn];
	
end
