#!/bin/bash

#############
# Controles #
#############

# Controle da criacao de pastas + instalacao do programa
control()
{
	# Estrutura de decisao: Verificacao de existencia de pastas
	if [[ ! -e "Nmap_IP" && "Nmap_Rede" ]]
	then
		# Comando
		#echo -e "\033[01;32m Diretorios existentes \033[00;00m"
		clear
		mkdir Nmap_IP && mkdir Nmap_Rede
	
	fi
	
	# Verificador de instalacao
	dpkg -l "nmap"
	
	if [[ $? -ne 0 ]]
	then
		apt-get install -y nmap	
	fi
	
	clear

}

# Controle de relatorio
relatorio()
{
	if [[ $? -eq 0 ]]
	then
		# Mensagem
		echo -e "\033[01;36m\n *** Relatorio Concluido [Press Enter] *** \033[00;00m"
		read
	else
		# Mensagem
		echo -e "\033[01;31m\n *** Relatorio Nao concluido [Press Enter] *** \033[00;00m"
		read
	fi
}

loading()
{
	clear
	for i in 1 2 3 4 5
	do
		echo -e "\033[01;3"$i"m Loading .... $i\033[00;00m"
		sleep 1
		clear
	done
	echo -e "# Processing..."
}

######################
# Metodos de Scanner #
######################

#--------------------------------------------------------------------#
#------------------------------- HOST -------------------------------#
#--------------------------------------------------------------------#

# Analise completa: Comando intenso (risco de paralisia)
fullAnalysis()
{
	# Apresentacao
	clear
	echo -e "\033[01;36m ----------------------- \033[00;00m"
	echo -e "\033[01;32m      Full Analysis      \033[00;00m"
	echo -e "\033[01;36m ----------------------- \033[00;00m"
	echo ""
	echo -n -e "\033[01;35m # Host: \033[00;00m"
	read IP

	# Comandos
	cmd1="-f -A -O -sV -g 53 --open --privileged --randomize-hosts"
	cmd2="--data-length 200 --dns-server 8.8.8.8,4.4.4.4"# --version-intensity 9 
	cmd3="-D $IP,8.8.8.7,8.8.8.6,8.8.8.5,6.8.8.4,8.8.8.3,8.8.8.2,8.8.8.1,177.53.142.217,200.123.45.34,182.45.23.45,192.168.0.1,172.16.0.1 $IP"

	# Concatenacao
	cmd="$cmd1 $cmd2 $cmd3"

	# Scanner
	loading
	nmap $cmd > Nmap_IP/fullAnalysis_$IP.txt

	# Leitura de relatorio + verificacao
	cat Nmap_IP/fullAnalysis_$IP.txt | less
	relatorio
}

# Analise: Vulnerabilidades
vulnerabilities()
{
	clear
	echo -e "\033[01;36m --------------------------- \033[00;00m"
	echo -e "\033[01;36m *     Vulnerabilities     * \033[00;00m"
	echo -e "\033[01;36m --------------------------- \033[00;00m"
	echo ""
	echo -e -n "\033[01;32m # Domain [ex: testphp.vulnweb.com || ex: 127.0.0.1]: \033[00;00m"	
	
	# Entrada de dados
	read IP

	while [[ 1 ]]
	do
		clear
		echo -e "\033[01;36m --------------------------- \033[00;00m"
		echo -e "\033[01;36m *     Vulnerabilities     * \033[00;00m"
		echo -e "\033[01;36m --------------------------- \033[00;00m"
		echo ""
		echo -e "\033[01;31m + Types of Vulnerabilities + \033[01;37m"
		echo -e "\033[01;32m [1] Enumeration 		  \033[01;37m"
		echo -e "\033[01;33m [2] File Upload              \033[01;37m"
		echo -e "\033[01;34m [3] Front Page Login         \033[01;37m"
		echo -e "\033[01;35m [4] HTTP Passwd 		  \033[01;37m"
		echo -e "\033[01;36m [5] Directory Traversal      \033[01;37m"
		echo -e "\033[01;37m [6] Sql Injection 		  \033[01;37m"
		echo -e "\033[01;31m [7] Mysql   		  \033[01;37m"
		echo -e "\033[01;31m [8] Denial of Service 	  \033[01;37m"
		echo -e "\033[01;31m [9] All 			  \033[01;37m"
		echo ""
		echo -e "\033[01;31m [Enter] Back \n\033[00;00m"
		echo -e -n "\033[01;37m # Opc: \033[00;00m"
		read esc

		# Estrutura de decisao: Protecao -> 1 <= esc <= 9 para execucao da funcao 'loading'
		if [[ $esc -ge 1 && $esc -le 9 ]]
		then
			loading
		fi

		# Comandos
		cmd1="-g53 -O -sS -sV"
		cmd2="-D $IP,8.8.8.7,8.8.8.6,8.8.8.5,6.8.8.4,8.8.8.3,8.8.8.2,8.8.8.1,177.53.142.217,200.123.45.34,182.45.23.45,192.168.0.1,172.16.0.1 $IP"
		cmd="$cmd1 $cmd2"
		
		# Estrutura em escolha
		case $esc in

		1) nmap --script="http-enum" $cmd > Nmap_IP/enumeration_$IP.txt && cat Nmap_IP/enumeration_$IP.txt | less;;
		2) nmap --script="http-fileupload-exploiter.nse" $cmd > Nmap_IP/fileUpload_$IP.txt && cat Nmap_IP/fileUpload_$IP.txt | less;;
		3) nmap --script="http-frontpage-login" $cmd > Nmap_IP/frontPage_$IP.txt && cat Nmap_IP/frontPage_$IP.txt | less;;
		4) nmap --script="http-passwd" $cmd > Nmap_IP/httpPasswd_$IP.txt && cat Nmap_IP/httpPasswd_$IP.txt | less;;
		5) nmap --script="http-phpmyadmin-dir-traversal" $cmd > Nmap_IP/directoryTraversal_$IP.txt && cat Nmap_IP/directoryTraversal_$IP.txt | less;;
		6) nmap --script="http-sql-injection" $cmd > Nmap_IP/sqlInjection_$IP.txt && cat Nmap_IP/sqlInjection_$IP.txt | less;;
		7) nmap --script="mysql-brute" $cmd > Nmap_IP/mysqlBrute_$IP.txt && cat Nmap_IP/mysqlBrute_$IP.txt | less;;
		8) nmap --script="ntp-monlist,dns-recursion,snmp-sysdescr" $cmd > Nmap_IP/dos_$IP.txt && cat Nmap_IP/dos_$IP.txt | less;;
		9) nmap --script="vuln" $cmd > Nmap_IP/AllVulns_$IP.txt && cat Nmap_IP/AllVulns_$IP.txt | less;;
		*) break;;

		esac
	done
}

# Analise: Sistema Operacional
operationalSystem()
{
	# Apresentacao
	clear
	echo -e "\033[01;36m ------------------------------ \033[00;00m"
	echo -e "\033[01;32m *     Operational System     * \033[00;00m"
	echo -e "\033[01;36m ------------------------------ \033[00;00m"
	echo ""
	echo -e -n "\033[01;35m # Host: \033[01;37m"
	read IP

	# Comandos
	cmd1="-O -sS -sV --data-length 200 -g 53"
	cmd2="-D $IP,8.8.8.7,8.8.8.6,8.8.8.5,6.8.8.4,8.8.8.3,8.8.8.2,8.8.8.1,177.53.142.217,200.123.45.34,182.45.23.45,192.168.0.1,172.16.0.1 $IP"

	# Concatenacao
	cmd="$cmd1 $cmd2"

	# Scanner
	loading
	nmap $cmd > Nmap_IP/operationalSystem_$IP.txt

	# Relatorio
	cat Nmap_IP/operationalSystem_$IP.txt | less
	relatorio
}

#--------------------------------------------------------------------#
#------------------------------- REDE -------------------------------#
#--------------------------------------------------------------------#

# Pesquisando: Sistema operacionais dentro da rede
searchOperationalSystem()
{
	# Apresentacao
	clear
	echo -e "\033[01;36m ------------------------------------- \033[00;00m"
	echo -e "\033[01;32m *     Search Operational System     * \033[00;00m"
	echo -e "\033[01;36m ------------------------------------- \033[00;00m"
	echo ""
	echo -e -n "\033[01;35m # Host [ex: 192.168.0.1]: \033[01;37m"
	read IP

	# Comandos
	cmd="-f -sV -O -D $IP,8.8.8.7,8.8.8.6,8.8.8.5,6.8.8.4,8.8.8.3,8.8.8.2,8.8.8.1,177.53.142.217,200.123.45.34,182.45.23.45,192.168.0.1,172.16.0.1 $IP/24"
	
	# Comando
	loading
	nmap $cmd > Nmap_Rede/searchOperationalSystem_$IP.txt

	# Descricoes
	clear
	cat Nmap_Rede/searchOperationalSystem_$IP.txt | grep -i "Nmap scan report for" | cut -d " " -f 5
	hosts=$(cat Nmap_Rede/searchOperationalSystem_$IP.txt | grep -i "Nmap scan report for" | cut -d " " -f 5 | wc -l)
	echo -e "\033[01;36m# Hosts: $hosts \033[00;00m"

	echo -e "\n------------------------------------------------------------------------------------"
	cat Nmap_Rede/searchOperationalSystem_$IP.txt
	#cat Nmap_Rede/searchOperationalSystem_$IP.txt | grep -i -E "Nmap scan report for|Os details:"
	
	# Relatorio
	echo -e "------------------------------------------------------------------------------------"
	relatorio

	# Deteccao de sistemas operacionais Windows
	#windows=$(cat Nmap_Rede/searchOperationalSystem_$IP.txt | grep -i "OS: Windows* | wc -l")
	#echo -e "\n ----- Operational System Microsoft -----"
	#echo -e "* Windows: $windows"

	# Deteccao de sistemas operacionais Linux
	#linux=$(cat Nmap_Rede/searchOperationalSystem_$IP.txt | grep -i "Running: Linux* | wc -l")
	#echo -e "\n ----- Operational System Microsoft -----"
	#echo -e "* Linux: $linux"
}

# Pesquisando: Sistema operacional dentro da rede e suas respectivas portas selecionadas
searchOperationalSystemPorts()
{
	# Apresentacao
	clear
	echo -e "\033[01;36m ------------------------------------------ \033[00;00m"
	echo -e "\033[01;32m *     Search Operational System Ports    * \033[00;00m"
	echo -e "\033[01;36m ------------------------------------------ \033[00;00m"
	echo ""
	echo -e -n "\033[01;35m # Host [ex: 192.168.0.1]: \033[01;37m"
	read IP
	echo ""
	echo -e -n "\033[01;34m # Ports [ex: 21,22,23,80,135,445,3306,1234,666,443,53]: "
	read ports

	# Comandos
	cmd1="-p $ports"
	cmd2="-f -sV -O -D $IP,8.8.8.7,8.8.8.6,8.8.8.5,6.8.8.4,8.8.8.3,8.8.8.2,8.8.8.1,177.53.142.217,200.123.45.34,182.45.23.45,192.168.0.1,172.16.0.1 $IP/24"
	cmd="$cmd1 $cmd2"

	# Comando
	loading
	nmap $cmd > Nmap_Rede/searchOperationalSystemPorts_$IP.txt

	# Descricoes
	clear
	cat Nmap_Rede/searchOperationalSystemPorts_$IP.txt | grep -i "Nmap scan report for" | cut -d " " -f 5
	hosts=$(cat Nmap_Rede/searchOperationalSystemPorts_$IP.txt | grep -i "Nmap scan report for" | cut -d " " -f 5 | wc -l)
	echo -e "\033[01;36m# Hosts: $hosts \033[00;00m"

	echo -e "\n------------------------------------------------------------------------------------"
	cat Nmap_Rede/searchOperationalSystemPorts_$IP.txt
	#cat Nmap_Rede/searchOperationalSystemPorts_$IP.txt | grep -i -E "Nmap scan report for|Os details:"
	
	# Relatorio
	echo -e "------------------------------------------------------------------------------------"
	relatorio

	# Deteccao de sistemas operacionais Windows
	#windows=$(cat Nmap_Rede/searchOperationalSystemPorts_$IP.txt | grep -i "OS: Windows* | wc -l")
	#echo -e "\n ----- Operational System Microsoft -----"
	#echo -e "* Windows: $windows"

	# Deteccao de sistemas operacionais Linux
	#linux=$(cat Nmap_Rede/searchOperationalSystemPorts_$IP.txt | grep -i "Running: Linux* | wc -l")
	#echo -e "\n ----- Operational System Microsoft -----"
	#echo -e "* Linux: $linux"
}

# Pesquisando: Analise Avancada
advancedAnalytics()
{
	# Apresentacao
	clear
	echo -e "\033[01;36m ------------------------------ \033[00;00m"
	echo -e "\033[01;32m *     Advanced Analytivs     * \033[00;00m"
	echo -e "\033[01;36m ------------------------------ \033[00;00m"
	echo ""
	echo -e -n "\033[01;35m # Host [ex: 192.168.0.1]: \033[01;37m"
	read IP

	# Comandos
	cmd1="-f -sV -O -A"
	cmd2="-D $IP,8.8.8.7,8.8.8.6,8.8.8.5,6.8.8.4,8.8.8.3,8.8.8.2,8.8.8.1,177.53.142.217,200.123.45.34,182.45.23.45,192.168.0.1,172.16.0.1 $IP/24"
        cmd="$cmd1 $cmd2"

	# Comando
	loading
	nmap $cmd > Nmap_Rede/advancedAnalytics_$IP.txt

	# Descricoes
	clear
	cat Nmap_Rede/advancedAnalytics_$IP.txt | grep -i "Nmap scan report for" | cut -d " " -f 5
	hosts=$(cat Nmap_Rede/advancedAnalytics_$IP.txt | grep -i "Nmap scan report for" | cut -d " " -f 5 | wc -l)
	echo -e "\033[01;36m# Hosts: $hosts \033[00;00m"

	echo -e "\n------------------------------------------------------------------------------------"
	cat Nmap_Rede/advancedAnalytics_$IP.txt
	#cat Nmap_Rede/advancedAnalytics_$IP.txt | grep -i -E "Nmap scan report for|Os details:"

	# Relatorio
	echo -e "------------------------------------------------------------------------------------"
	relatorio

	# Deteccao de sistemas operacionais Windows
	#windows=$(cat Nmap_Rede/advancedAnalytics_$IP.txt | grep -i "OS: Windows* | wc -l")
	#echo -e "\n ----- Operational System Microsoft -----"
	#echo -e "* Windows: $windows"

	# Deteccao de sistemas operacionais Linux
	#linux=$(cat NNmap_Rede/advancedAnalytics_$IP.tx | grep -i "Running: Linux* | wc -l")
	#echo -e "\n ----- Operational System Microsoft -----"
	#echo -e "* Linux: $linux"
}

#--------------------------------------#
#          Estrutura de MENU           #
#--------------------------------------#

# Sub Menu: Host
hostMenu()
{
	clear
	echo -e "\033[01;31m ---------------- \033[00;00m"
	echo -e "\033[01;32m +     HOST     + \033[00;00m"
	echo -e "\033[01;31m ---------------- \033[00;00m "
	echo ""
	echo -e "\033[01;33m [1] Full Analysis	    \033[00;00m"
	echo -e "\033[01;34m [2] Vulnerabilites	    \033[00;00m"
	echo -e "\033[01;35m [3] Operational System \033[00;00m"
	echo -e "\033[01;36m\n [enter] Back 	    \033[00;00m"
	echo ""
	echo -e -n "\033[01;37m # Opc: \033[00;00m"
	read resp
	
	# Estrutura de escolha
	case $resp in

	1)	fullAnalysis;;
	2)	vulnerabilities;;
	3)	operationalSystem;;
	0)	;;

	esac
}

# Sub Menu: Rede
netMenu()
{
	clear
	echo -e "\033[01;31m ---------------- \033[00;00m"
	echo -e "\033[01;32m +     REDE     + \033[00;00m"
	echo -e "\033[01;31m ---------------- \033[00;00m "
	echo ""
	echo -e "\033[01;33m [1] Search Operational System 	 \033[00;00m"
	echo -e "\033[01;34m [2] Search Operational System Ports \033[00;00m"
	echo -e "\033[01;35m [3] Advanced Analytics		 \033[00;00m"
	echo -e "\033[01;36m\n [enter] Back			 \033[00;00m"
	echo ""
	echo -e -n "\033[01;37m # Opc: \033[00;00m"
	read resp
	
	# Estrutura de escolha
	case $resp in

	1)	searchOperationalSystem;;
	2)	searchOperationalSystemPorts;;
	3)	advancedAnalytics;;
	0)	;;

	esac
}

# Menu: Principal
mainMenu()
{
	# Chamada de metodo
	control
	
	# Estrutura em loop
	while [[ 1 ]]
	do
		clear
		echo -e "\033[01;31m ======================== \033[00;00m"
		echo -e "\033[01;32m +         NMAP         + \033[00;00m"
		echo -e "\033[01;31m ======================== \033[00;00m"
		echo ""
		echo -e "\033[01;33m [1] HOST \033[00;00m"
		echo -e "\033[01;34m [2] REDE \033[00;00m"
		echo -e "\033[01;35m [0] Exit \033[00;00m"
		echo ""
		echo -e -n "\033[01;36m # Opc: \033[00;00m"
		read esc

		# Estrutura em loop
		case $esc in

		1)	hostMenu;;
		2)	netMenu;;
		0)	exit 1;;
		*)	;;
	
		esac
	done
}

################################
#     Execucao do programa     #
################################
mainMenu
