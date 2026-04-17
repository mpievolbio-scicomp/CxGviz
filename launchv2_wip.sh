#! /bin/bash
#
source /opt/miniconda3/bin/activate VIP

cd ~/CxGviz

first_port=5005 # Port to open for the first launched service, subsequent services will have incremented port number.
wait=30 # Time to sleep during cellxgene launches.


.VIPlight.sh launch --title "all cells"                --port 5005 /data/cellxgene_data/kaucka/adata_all_cells.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "ectoderm final"           --port 5006 /data/cellxgene_data/kaucka/adata_ectoderm_final.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "mesenchyme final"         --port 5007 /data/cellxgene_data/kaucka/adata_mesenchyme_final.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "mesenchyme E8-5"          --port 5008 /data/cellxgene_data/kaucka/adata_mesenchyme_E8-5.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "mesenchyme E9-5"          --port 5009 /data/cellxgene_data/kaucka/adata_mesenchyme_E9-5.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "mesenchyme E10-5"         --port 5010 /data/cellxgene_data/kaucka/adata_mesenchyme_E10-5.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "mesenchyme E11-5"         --port 5011 /data/cellxgene_data/kaucka/adata_mesenchyme_E11-5.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "mesenchyme E12-5"         --port 5012 /data/cellxgene_data/kaucka/adata_mesenchyme_E12-5.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "mesenchyme E13-5"         --port 5013 /data/cellxgene_data/kaucka/adata_mesenchyme_E13-5.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "mesenchyme E14-5"         --port 5014 /data/cellxgene_data/kaucka/adata_mesenchyme_E14-5.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "E11 RNA mouse"            --port 5015 /data/cellxgene_data/Kyomen2026/E11_RNA_mouse.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "HH22 RNA Citrus chicken"  --port 5016 /data/cellxgene_data/Kyomen2026/HH22_RNA_Citrus_chicken.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "E11 ATAC banana mouse"    --port 5017 /data/cellxgene_data/Kyomen2026/E11_ATAC_banana_mouse.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "HH22 ATAC banana chicken" --port 5018 /data/cellxgene_data/Kyomen2026/HH22_ATAC_banana_chicken.h5ad > /dev/null 2>&1 &
.VIPlight.sh launch --title "shark89"                  --port 5019 /data/cellxgene_data/Escamilla2026/shark89_interactive.h5ad > /dev/null 2>&1 &

port=$first_port
for ds in ${datasets[@]}; do
	if [ ! -f $ds ]; then
		echo "Dataset $ds does not exist, please check the path and access rights."
		continue
	fi
	
	ds_name=$(echo $(basename $ds .h5ad) | awk -F"_" '{print $2" "$3}')
	echo "Launching cellxgene on file $ds (named '$ds_name' on port $port..."
 	com="./VIPlight launch $ds --title $(basename $ds) --port $port > /dev/null 2>&1 &"
	echo $com
	eval $com
	echo "...done."
	echo "Waiting $wait seconds..."
	sleep $wait
	port=$(($port+1)) # Update port number.
done
cd ..
systemd-notify --ready --status "Started"
while true; do
	systemd-notify --status "Alive"
	sleep 60
done

