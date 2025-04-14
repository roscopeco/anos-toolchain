#!/bin/bash

component_dirs='anos-binutils-2.42 anos-gcc anos-newlib-4.5.0.20241231'
unified_src=srcw

mkdir -p ${unified_src}
cd ${unified_src}
ignore_list=". .. CVS .svn .git"
    
for srcdir in ${component_dirs}
do
    echo "Component: $srcdir"
    case srcdir
        in
        /* | [A-Za-z]:[\\/]*)
            ;;
            
        *)
            srcdir="../${srcdir}"
            ;;
    esac
        
    files=`ls -a ${srcdir}`
        
    for f in ${files}
    do
        found=
            
        for i in ${ignore_list}
        do
            if [ "$f" = "$i" ]
            then
                found=yes
            fi
        done
            
        if [ -z "${found}" ]
        then
            echo "$f            ..linked"
            ln -s ${srcdir}/$f .
        fi
    done

    ignore_list="${ignore_list} ${files}"
done

cd ..
