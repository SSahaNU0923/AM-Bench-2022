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
%C11 = 243300;%*1.0462;
%C11 = 300500;
%C44 = E/(1+v)/2;
%C44 = 117800;%*1.0462;
%C12 = E*v/(1+v)/(1-2*v);
%C12 = 156700;%*1.0462;
%C22 = C11; C33 = C11;
%C55 = C44; C66 = C44;
%C13 = C12; C23 = C12;
%Props = [C11, C22, C33, C44, C55, C66, C12, C13, C23];
%Props(10) = 252;%g_zero1%p(1)
%Props(11) = 252;%158;%g_zero2%p(1)
%Props(12) = 252;%158;%g_zero3%p(1)
%Props(13) = 252;%158;%g_zero4%p(1)

%Props(14) = 0.00242;%gamma_dot_0
%Props(14) = p(2);%gamma_dot_0
%Props(15) = 58.8;%m
%Props(16) = 50.7437;%Hdir_p(2)
%Props(16) = 428.868900;  %525.5983*1.1*1.22;%505 %497.5983;  %415.5983;
%Props(17) = 0.025;%Hdyn_p(3)
%Props(18) = 1.0;%xLatent
%Props(19) = 1.5;%a0
%Props(20) = 50; %44.9174 %50.0028;%adir_p(4)
%Props(21) = 1.9425; %1.9425;%adyn_p(5)

p = [298.55 0.0024 80.4 299.08 0.00165 0.508];

C11 = 223300;
%C11 = 300000;
%C44 = E/(1+v)/2;
C44 = 117800;
%C12 = E*v/(1+v)/(1-2*v);
C12 = 156700;
C22 = C11; C33 = C11;
C55 = C44; C66 = C44;
C13 = C12; C23 = C12;
Props = [C11, C22, C33, C44, C55, C66, C12, C13, C23];
Props(10) = p(1);%137;%252;%g_zero1%p(1)
Props(11) = p(1);%137;%252;%g_zero2%p(1)
Props(12) = p(1);%137;%252;%g_zero3%p(1)
Props(13) = p(1);%252;%g_zero4%p(1)
%
Props(14) = p(2);%0.002;%gamma_dot_0
%Props(14) = p(2);%gamma_dot_0
Props(15) = p(3); %10;%m
%Props(16) = 50.7437;%Hdir_p(2)
Props(16) = p(4);%1;%395.8689; %428.8689; %running trial for general previ=465.8689
Props(17) = p(5);%0;%Hdyn_p(3) prev=0.0000005
Props(18) = p(6);%1.0; %1.0; %xLatent
Props(19) = 1.5; %a0 originally 0
Props(20) = 50.0;  %50.0028;%adir_p(4) prev = 200 16Pct=0
Props(21) = 1.9425;%adyn_p(5) prev = 1.9425


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


