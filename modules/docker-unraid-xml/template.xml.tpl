<?xml version="1.0"?>
<Container version="2">
  <Name>${container_name}</Name>
  <Repository>${repository}</Repository>
  <Registry>${registry}</Registry>
  <Network>${network}</Network>
  <MyIP/>${myip}<MyIP/>
  <Shell>${shell}</Shell>
  <Privileged>${privileged}</Privileged>
  <Support>${support}</Support>
  <Project>${project}</Project>
  <Overview>${overview}</Overview>
  <Category>${category}</Category>
  <WebUI>${webui}</WebUI>
  <TemplateURL>${template_url}</TemplateURL>
  <Icon>${icon}</Icon>
  <ExtraParams>${extra_params}</ExtraParams>
  <PostArgs/>${postargs}<PostArgs/>
  <CPUset/>${cpuset}<CPUset/>
  <DateInstalled>${date_installed}</DateInstalled>
  <DonateText>${donate_text}</DonateText>
  <DonateLink>${donate_link}</DonateLink>
  <Requires/>${requires}<Requires/>

%{ for config in configs ~}
  <Config Name="${config.name}" Target="${config.target}" Default="${config.default}" Mode="${config.mode}" Description="${config.description}" Type="${config.type}" Display="${config.display}" Required="${config.required}" Mask="${config.mask}">${config.value}</Config>
%{ endfor ~}
  <TailscaleStateDir/>
</Container>
