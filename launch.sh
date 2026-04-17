#! /bin/bash
#
source /opt/miniconda3/bin/activate VIP

cd ~/CxGviz

first_port=5005 # Port to open for the first launched service, subsequent services will have incremented port number.
wait=15 # Time to sleep during cellxgene launches.

datasets=(\
	"/data/cellxgene_data/kaucka/adata_all_cells.h5ad"        \
        "/data/cellxgene_data/kaucka/adata_ectoderm_final.h5ad"   \
        "/data/cellxgene_data/kaucka/adata_mesenchyme_final.h5ad" \
        "/data/cellxgene_data/kaucka/adata_mesenchyme_E8-5.h5ad"   \
        "/data/cellxgene_data/kaucka/adata_mesenchyme_E9-5.h5ad"   \
        "/data/cellxgene_data/kaucka/adata_mesenchyme_E10-5.h5ad"  \
        "/data/cellxgene_data/kaucka/adata_mesenchyme_E11-5.h5ad"  \
        "/data/cellxgene_data/kaucka/adata_mesenchyme_E12-5.h5ad"  \
        "/data/cellxgene_data/kaucka/adata_mesenchyme_E13-5.h5ad"  \
        "/data/cellxgene_data/kaucka/adata_mesenchyme_E14-5.h5ad"  \
	"/data/cellxgene_data/Kyomen2026/E11_RNA_mouse.h5ad" \
	"/data/cellxgene_data/Kyomen2026/HH22_RNA_Citrus_chicken.h5ad" \
	"/data/cellxgene_data/Kyomen2026/E11_ATAC_banana_mouse.h5ad" \
	"/data/cellxgene_data/Kyomen2026/HH22_ATAC_banana_chicken.h5ad" \
	"/data/cellxgene_data/Escamilla2026/shark89_interactive.h5ad" \
)

# Not active yet
shark="/data/cellxgene_data/Escamilla2026/shark89_interactive.h5ad" 

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

