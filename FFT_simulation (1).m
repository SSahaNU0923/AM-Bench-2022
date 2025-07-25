%=======================================================================================
% This is the main script
% Author: Sourav Saha
% Email: souravsaha@vt.edu
%=======================================================================================
% This is a Crystal Plasticity-FFT running script for uniaxial
% tension/compression
%=======================================================================================
%function []= FFT_simulation(CaseName)
clear all;
addpath('/home/souravsaha/DDMM/PrePost')
%======================================================================
%=============Define Names and Paths====================================
CaseName = 'Size750';
path_abs = pwd;
path_data = [path_abs, '/', CaseName, '/', 'Data'];
%=======================================================================
%====================== FFT Code Specs =================================
ld = 2; % loading direction (1:xx; 2:yy; 3:zz; 4:yz; 5:xz; 6:xy)
strain_amp = 2.e-1;
strain_rate = 1e-3; % strain rate
Nt=9; %total dimesion of deformation gradient
Ncycles = 0.5; % The first step is only half cycle
Ninc0 = 500; % number of increments in the first step
ISOS = 1; % 1: mixed loading; 0: deformation loading
path_fft = [path_abs, '/', CaseName, '/', 'FFT_true','_ld',num2str(ld),'_ISOS',num2str(ISOS)];
path_slip = '/home/souravsaha/DDMM/SlipSystemsLibrary';
CodeName = '/home/souravsaha/DDMM/FiniteStrain/FFT_finite_basic_v1s4_nolocal.exe';

%====================== CPFEM Specs =====================================
p = [298.55 0.0024 80.4 299.08 0.00165 0.508];
C11 = 223300;
C44 = 117800;
C12 = 156700;
C22 = C11; C33 = C11;
C55 = C44; C66 = C44;
C13 = C12; C23 = C12;
Props = [C11, C22, C33, C44, C55, C66, C12, C13, C23];
Props(10) = p(1);
Props(11) = p(1);
Props(12) = p(1);
Props(13) = p(1);
Props(14) = p(2);
Props(15) = p(3); 
Props(16) = p(4);
Props(17) = p(5);
Props(18) = p(6);
Props(19) = 1.5; 
Props(20) = 50.0;  
Props(21) = 1.9425;


PhaseType = 'FCC';
% current time
Timetemp = tic;

%----------------------------------------------------------------------
PrepareFFT_CP(CaseName,path_fft,path_data,path_slip,ld,Ncycles,strain_amp,strain_rate,Ninc0,ISOS,Props,PhaseType)
cd(path_fft)
status = system(CodeName);
cd(path_abs)

T_cur = toc(Timetemp);
T_dns = T_cur;
display(['Time for FFT: ',num2str(T_dns),' seconds...']);
display(['Time elapsed: ',num2str(T_cur),' seconds...']);
%-----------------------------------------------------------------------------
%------------------- Post-processing -----------------------------------------
%nstart=1;
%ngap=1;
%path_vtk = [path_abd,'/',CaseName,'/','VTK'];
%WriteVTK_FFTlocal_Binary(path_data,CaseName,path_vtk,path_fft,Nt);
%WriteVTU_FFTlocal_Binary(path_data,CaseName,path_vtk,path_fft,ngap,nstart);


