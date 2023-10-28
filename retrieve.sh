# From the data wizard hrbrmstr using mitproxy ()

curl --silent \
  -H "Referer: https://public.tableau.com/app/profile/ncdhhs.covid19data/viz/NCDHHS_COVID-19_DataDownload_Story_16220681778000/DataBehindtheDashboards?:display_static_image=n&:bootstrapWhenNotified=true&:embed=false&:language=en-US&:embed=y&:showVizHome=n&:apiID=host0#navType=2&navSrc=Parse" \
  "https://public.tableau.com/workbooks/NCDHHS_COVID-19_DataDownload_Story_16220681778000.twb" > \
  input/NCDHHS_COVID.twbx