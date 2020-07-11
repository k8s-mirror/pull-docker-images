# image='gcr.io/knative-releases/knative.dev/eventing/cmd/mtbroker/filter@sha256:3b85d745bba2f32f2e60ddca2781969198d8c82434e18706c040b06884a42f8d'
# tag='knativedev/eventing-cmd-mtbroker-filter'
# docker pull $image
# docker tag $image docker.io/$tag
# docker push $tag

for image in $(cat knative-list.txt)
do
# echo ${image}
oldIFS=$IFS
IFS=,
imgArr=(${image})
docker pull ${imgArr[0]}
docker tag ${imgArr[0]} docker.io/${imgArr[1]}
docker push ${imgArr[1]}
# echo ${imgArr[@]}
# for ((i=0;i<${#imgArr[@]};i++))
# do
# echo $i: ${imgArr[$i]}
# done
IFS=$oldIFS
done
