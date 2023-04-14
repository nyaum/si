@echo off

echo Start IIS Setup...
echo Install NetFx3...(1/30)
start /wait /b dism /online /Enable-Feature /FeatureName:NetFx3 /all
echo Install WCF-HTTP-Activation...(2/30)
start /wait /b dism /online /Enable-Feature /FeatureName:WCF-HTTP-Activation /all
echo Install WCF-NonHTTP-Activation...(3/30)
start /wait /b dism /online /Enable-Feature /FeatureName:WCF-NonHTTP-Activation /all
echo Install NetFx4-AdvSrvs...(4/30)
start /wait /b dism /online /Enable-Feature /FeatureName:NetFx4-AdvSrvs /all 
echo Install WCF-TCP-PortSharing45...(5/30)
start /wait /b dism /online /Enable-Feature /FeatureName:WCF-TCP-PortSharing45 /all
echo Install NetFx4Extended-ASPNET45...(6/30)
start /wait /b dism /online /Enable-Feature /FeatureName:NetFx4Extended-ASPNET45 /all
echo Install IIS-WindowsAuthentication...(7/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-WindowsAuthentication /all
echo Install IIS-BasicAuthentication...(8/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-BasicAuthentication /all
echo Install IIS-RequestFiltering...(9/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-RequestFiltering /all
echo Install IIS-HttpLogging...(10/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-HttpLogging /all
echo Install IIS-ODBCLogging...(11/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ODBCLogging /all
echo Install IIS-HttpErrors...(12/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-HttpErrors /all
echo Install IIS-DefaultDocument...(13/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-DefaultDocument /all
echo Install IIS-DirectoryBrowsing...(14/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-DirectoryBrowsing /all
echo Install IIS-StaticContent...(15/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-StaticContent /all
echo Install IIS-IIS6ManagementCompatibility...(16/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-IIS6ManagementCompatibility /all
echo Install IIS-Metabase...(17/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-Metabase /all
echo Install IIS-ManagementService...(18/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ManagementService /all
echo Install IIS-ManagementScriptingTools...(19/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ManagementScriptingTools /all
echo Install IIS-ManagementConsole...(20/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ManagementConsole /all
echo Install IIS-ApplicationDevelopment...(21/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ApplicationDevelopment /all
echo Install IIS-NetFxExtensibility...(22/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-NetFxExtensibility /all
echo Install IIS-NetFxExtensibility45...(23/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-NetFxExtensibility45 /all
echo Install IIS-ASPNET...(24/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ASPNET /all
echo Install IIS-ASPNET45...(25/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ASPNET45 /all
echo Install IIS-ISAPIExtensions...(26/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ISAPIExtensions /all
echo Install IIS-ISAPIFilter...(27/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ISAPIFilter /all
echo Install IIS-ServerSideIncludes...(28/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ServerSideIncludes /all
echo Install IIS-WebSockets...(29/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-WebSockets /all
echo Install IIS-ApplicationInit...(30/30)
start /wait /b dism /online /Enable-Feature /FeatureName:IIS-ApplicationInit /all
echo /wait /b IIS Setup Successed
echo /wait /b IIS Configuration Start...

echo Create Site In IIS...
%systemroot%\system32\inetsrv\appcmd add site /name:"GateAgent" /physicalPath:"C:\GateAgent" /bindings:http/*:6801:
 
echo Create ApplicationPool...
%systemroot%/system32/inetsrv/appcmd add apppool /name:GateAgent
 
%systemroot%/system32/inetsrv/APPCMD set apppool /apppool.name:"GateAgent" /managedPipelineMode:Integrated
 
echo Start ApplicationPool...
%systemroot%/system32/inetsrv/APPCMD start apppool /apppool.name:"GateAgent"
 
echo Change ApplicationPool of Site...
%systemroot%/system32/inetsrv/APPCMD set site /site.name:"GateAgent" /[path='/'].applicationPool:GateAgent
 
echo IIS Configuration Successed
