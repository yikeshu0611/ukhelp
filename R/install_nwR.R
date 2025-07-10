#' install
#'
#'
#' @return install
#' @export
#'
install_ukR <- function(){

    e <- tryCatch(detach("package:ukR", unload = TRUE),error=function(e) 'e')
    e <- tryCatch(detach("package:ukR", unload = TRUE),error=function(e) 'e')
    # check
    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (dest <- paste0(td,'/',td2))
    dir.create(path = dest,recursive = TRUE,showWarnings = FALSE)
    (tf <- paste0(dest,'/ukR.zip'))

    if (do::is.windows()){
        download.file(url = 'https://codeload.github.com/yikeshu0611/ukR_win/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb')
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }else{
        download.file(url = 'https://codeload.github.com/yikeshu0611/ukR_mac/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb')
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }



    if (do::is.windows()){
        main <- paste0(dest,'/ukR_win-main')
        (ukR <- list.files(main,'ukR_',full.names = TRUE))
        (ukR <- ukR[do::right(ukR,3)=='zip'])
        (k <- do::Replace0(ukR,'.*ukR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max())
        unzip(ukR[k],files = 'ukR/DESCRIPTION',exdir = main)
    }else{
        main <- paste0(dest,'/ukR_mac-main')
        ukR <- list.files(main,'ukR_',full.names = TRUE)
        ukR <- ukR[do::right(ukR,3)=='tgz']
        k <- do::Replace0(ukR,'.*ukR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        untar(ukR[k],files = 'ukR/DESCRIPTION',exdir = main)
    }

    (desc <- paste0(main,'/ukR'))
    ukhelp:::check_package(desc)

    install.packages(pkgs = ukR[k],repos = NULL,quiet = FALSE)
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    if ('..ukRiswait' %in% ls(all.names = T,envir = .GlobalEnv)){
        if (..ukRiswait){
            rstudioapi::sendToConsole('.rs.restartR()')
        }else{
            e = suppressWarnings(require(ukR,warn.conflicts = F,quietly = T))
            if (isFALSE(e)){
                rstudioapi::sendToConsole('.rs.restartR()')
                Sys.sleep(3)
                rstudioapi::sendToConsole('library(ukR)')
            }else{
                e <- tryCatch(detach("package:ukR", unload = TRUE),error=function(e) 'e')
                rstudioapi::sendToConsole('library(ukR)')
            }
        }
    }else{
        rstudioapi::sendToConsole('library(ukR)')
    }

    invisible()
}
