#!/bin/sh
##
# script to generate all kinds of nethunter packs
##

# forced binary download (update apps)
if [ "$2" == "-f" ]; then
    ./build.py -f
fi;

case "$1" in

op1)
    # create One Plus 1 packs with branding
    ./build.py -d oneplus1 -m -nk -nf
    ./build.py -d oneplus1 -n -nk -nf
    ./build.py -d oneplus1 -o -nk -nf
    # create One Plus 1 packs without branding
    ./build.py -d oneplus1 -m -nk -nb -nf
    ./build.py -d oneplus1 -n -nk -nb -nf
    ./build.py -d oneplus1 -o -nk -nb -nf
;;

op3)
    # create One Plus 3 packs for oos with branding
    ./build.py -d oneplus3-oos -m -nk -nf
    ./build.py -d oneplus3-oos -n -nk -nf
    ./build.py -d oneplus3-oos -o -nk -nf
    ./build.py -d oneplus3-oos -p -nk -nf
    # create One Plus 3 packs for cm with branding
    ./build.py -d oneplus3-cm -m -nk -nf
    ./build.py -d oneplus3-cm -n -nk -nf
    ./build.py -d oneplus3-cm -o -nk -nf
    ./build.py -d oneplus3-cm -p -nk -nf
    # create One Plus 3 packs for oos without branding
    ./build.py -d oneplus3-oos -m -nk -nb -nf
    ./build.py -d oneplus3-oos -n -nk -nb -nf
    ./build.py -d oneplus3-oos -o -nk -nb -nf
    ./build.py -d oneplus3-oos -p -nk -nb -nf
    # create One Plus 3 packs for cm without branding
    ./build.py -d oneplus3-cm -m -nk -nb -nf
    ./build.py -d oneplus3-cm -n -nk -nb -nf
    ./build.py -d oneplus3-cm -o -nk -nb -nf
    ./build.py -d oneplus3-cm -p -nk -nb -nf
;;

op5)
    # create One Plus 5 packs for oos with branding
    ./build.py -d oneplus5-oos -o -nk -nf
    ./build.py -d oneplus5-oos -p -nk -nf
    # create One Plus 5 packs for cm with branding
    ./build.py -d oneplus5-cm -o -nk -nf
    ./build.py -d oneplus5-cm -p -nk -nf
    # create One Plus 5 packs for oos without branding
    ./build.py -d oneplus5-oos -o -nk -nb -nf
    ./build.py -d oneplus5-oos -p -nk -nb -nf
    # create One Plus 5 packs for cm without branding
    ./build.py -d oneplus5-cm -o -nk -nb -nf
    ./build.py -d oneplus5-cm -p -nk -nb -nf
;;

all)
    $0 op1 && $0 op3 && $0 op5
;;

*)
    echo ""
    echo "A Script to generate Nethunter Installation Packs"
    echo ""
    echo "Syntax: $0 <option1> <option2>" 
    echo ""
    echo "Option1:"
    echo "'op1' for one plus one devices"
    echo "'op3' for One Plus 3 devices"
    echo "'op5' for One Plus 5 devices"
    echo "'all' build all of the above devices"
    echo ""
    echo "Option2:"
    echo "'-f' to force binary download (attention may not work properly due to connection issues!)"
    echo ""
    echo "Some general hints if u face problems:"
    echo ""
    echo "Problems getting your adapter to work? Use proper Kernel + Checkout for a usage example:"
    echo "https://forum.xda-developers.com/showpost.php?p=72681706&postcount=306"
    echo ""
    echo "Any nethunter apps crashing? try to re-install apps manually. apks are in /data/app directory"
    echo "more infos: https://github.com/offensive-security/kali-nethunter/issues/420"
    echo ""
    echo "Problems with wifite and monitor mode? try executing: airmon-ng start wlanX && wifite (X=the actual number of the usb adpater)"
    echo "more infos: https://github.com/offensive-security/kali-nethunter/issues/801"
    echo ""
    echo "Always enable OTG on OOS roms:"
    echo "https://www.xda-developers.com/enable-always-on-otg-oxygenos/"
    echo ""
;;
esac
