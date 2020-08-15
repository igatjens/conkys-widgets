--this is a lua script for use in conky



--==============================================================================
--                            conky-igatjens.lua
--
--  author  : Isaías Gatjens M - Twitter @igatjens
--  version : v2.0 for Conky Manager
--  license : Distributed under the terms of GNU GPL version 2 or later
--
--
--  notes   : uses conky conf newer >v1.10
--==============================================================================




-- Debe guardar y reiniciar el conky para aplicar los cambios

-- INTERNET ANCHO DE BANDA  -- INTERNET BANDWIDTH --

		-- consulte su ancho de banda en www.speedtest.net
		-- check your bandwidth at www.speedtest.net

		local ancho_banda_descarga	= 10			-- en Mbps -- in Mbps
		local ancho_banda_subida	= 3			-- en Mbps -- in Mbps

-- DISPOSITIVOS DE RED -- NETWORK DEVICES --

		-- consulte con el comando "ip addr"
		-- check with the command "ip addr"

		local WiFi_dev 	= ""		-- vacio ( = "") para autodeteccón - empty to autodetec
		local LAN_dev	= ""		-- vacio ( = "") para autodeteccón - empty to autodetec

-- PARTICIONES -- PARTITIONS --

		local particion01 = "/"				
		local particion02 = "/home"			-- vacio ( = "" ) para ocultar - empty to hide
		local particion03 = ""				-- vacio ( = "" ) para ocultar - empty to hide


-- TEMPERATURA CPU -- TEMPERATURE CPU --
		
		-- requiere instalar y configurar sensors - no funciona en la mayoría de los casos
		-- it requires installing and configuring sensors - it does not work in most cases
		
		local mostrar_temp_cpu = false
		local med_cpu_temp_dev = 1			-- valores entre 1 y 5 - values between 1 and 5


-- CONFIGURACION DE HORAS LABORALES -- CONFIGURATION OF WORK HOURS --
		
		local hora_laboral_inicio 	= 08		-- valores entre 0 y 23 - values between 00 and 23
		local minuto_laboral_inicio	= 00		-- valores entre 0 y 59 - values between 00 and 59

		local hora_laboral_fin 		= 17	-- valores entre 0 y 59 - values between 00 and 59
		local minuto_laboral_fin 	= 00		-- valores entre 0 y 59 - values between 00 and 59



-- MARGENES -- MARGIN --

-- ACCESORIOS

		-- conky-igatjens-acc-hora
		local acc_hora_margen_superior	 		= 15

		-- conky-igatjens-acc-hora
		local acc_hora_margen_izquierdo 		= 105

		-- conky-igatjens-acc-maquina
		local acc_maquina_margen_superior 		= 15

		-- conky-igatjens-acc-maquina
		local acc_maquina_margen_derecho 		= 0

		-- conky-igatjens-acc-pie
		local acc_pie_margen_superior	 		= 10


-- MEDIDORES

		-- conky-igatjens-med-bateria
		local med_bateria_margen_izquierdo 		= 0

		-- conky-igatjens-med-cpu-carga
		local med_cpu_carga_margen_izquierdo 	= 0

		-- conky-igatjens-med-cpu
		local med_cpu_margen_izquierdo 			= 0


		-- conky-igatjens-med-disk
		local med_disk_margen_izquierdo 		= 0


		-- conky-igatjens-med-gpu-nvidia
		local med_gpu_nvidia_margen_izquierdo 	= 0


		-- conky-igatjens-med-internet
		local med_internet_margen_izquierdo 	= 0


		-- conky-igatjens-med-memoria
		local med_memoria_margen_izquierdo 		= 0


-- GRAFICOS

		-- conky-igatjens-graf-cpu
		local graf_cpu_margen_izquierdo 		= 0


		-- conky-igatjens-graf-disk-read
		local graf_disk_read_margen_izquierdo 	= 0


		-- conky-igatjens-graf-disk-write
		local graf_disk_write_margen_izquierdo 	= 0


		-- conky-igatjens-graf-ram
		local graf_ram_margen_izquierdo 		= 0


		-- conky-igatjens-graf-red-down
		local graf_red_down_margen_izquierdo 	= 0


		-- conky-igatjens-graf-red-up
		local graf_red_up_margen_izquierdo 		= 0






-- Funciones para obtener los valores

function get_med_red_ancho_banda_descarga( ) return ancho_banda_descarga end


function get_med_red_ancho_banda_subida( ) return ancho_banda_subida end


function get_red_WiFi_dev( )
	
	if WiFi_dev == "" then
		local wifi = conky_parse( "${exec ip addr | grep \\ w..*: | cut -d \" \" -f2 | sed -e 's/.$//' | sed '2,10d'}" )
		if wifi == "" then 
			wifi = "wlan0"
		end
		return wifi
	end
	return WiFi_dev
end


function get_red_LAN_dev( )
	if LAN_dev == "" then
		local lan = conky_parse( "${exec ip addr | grep \\ e..*: | cut -d \" \" -f2 | sed -e 's/.$//' | sed '2,10d'}" )
		if lan == "" then 
			lan = "eth0"
		end
		return lan
	end
	return LAN_dev
end


-- PARTICIONES


function get_med_disk_paticion01( ) return particion01 end


function get_med_disk_paticion02( ) return particion02 end


function get_med_disk_paticion03( ) return particion03 end



-- TEMPERATURA


function get_med_cpu_mostrar_temp( ) return mostrar_temp_cpu end


function get_med_cpu_temp_dev( ) return med_cpu_temp_dev end



-- HORAS LABORALES

function get_hora_laboral_inicio( ) return hora_laboral_inicio end

function get_minuto_laboral_inicio( ) return minuto_laboral_inicio end

function get_hora_laboral_fin( ) return hora_laboral_fin end

function get_minuto_laboral_fin( ) return minuto_laboral_fin end




-- MARGENES

-- conky-igatjens-acc-hora
function get_acc_hora_margen_superior( ) return acc_hora_margen_superior end


-- conky-igatjens-acc-hora
function get_acc_hora_margen_izquierdo( ) return acc_hora_margen_izquierdo end


-- conky-igatjens-acc-maquina
function get_acc_maquina_margen_superior( ) return acc_maquina_margen_superior end


-- conky-igatjens-acc-maquina
function get_acc_maquina_margen_derecho( ) return acc_maquina_margen_derecho end


-- conky-igatjens-acc-pie
function get_acc_pie_margen_superior( ) return acc_pie_margen_superior end



-- conky-igatjens-med-bateria
function get_med_bateria_margen_izquierdo( ) return med_bateria_margen_izquierdo end


-- conky-igatjens-med-cpu-carga
function get_med_cpu_carga_margen_izquierdo( ) return med_cpu_carga_margen_izquierdo end


-- conky-igatjens-med-cpu
function get_med_cpu_margen_izquierdo( ) return med_cpu_margen_izquierdo end


-- conky-igatjens-med-disk
function get_med_disk_margen_izquierdo( ) return med_disk_margen_izquierdo end


-- conky-igatjens-med-gpu-nvidia
function get_med_gpu_nvidia_margen_izquierdo( ) return med_gpu_nvidia_margen_izquierdo end


-- conky-igatjens-med-internet
function get_med_internet_margen_izquierdo( ) return med_internet_margen_izquierdo end


-- conky-igatjens-med-memoria
function get_med_memoria_margen_izquierdo( ) return med_memoria_margen_izquierdo end







-- conky-igatjens-graf-cpu
function get_graf_cpu_margen_izquierdo( ) return graf_cpu_margen_izquierdo end


-- conky-igatjens-graf-disk-read
function get_graf_disk_read_margen_izquierdo( ) return graf_disk_read_margen_izquierdo end


-- conky-igatjens-graf-disk-write
function get_graf_disk_write_margen_izquierdo( ) return graf_disk_write_margen_izquierdo end


-- conky-igatjens-graf-ram
function get_graf_ram_margen_izquierdo( ) return graf_ram_margen_izquierdo end


-- conky-igatjens-graf-red-down
function get_graf_red_down_margen_izquierdo( ) return graf_red_down_margen_izquierdo end


-- conky-igatjens-graf-red-up
function get_graf_red_up_margen_izquierdo( ) return graf_red_up_margen_izquierdo end
