###############################################################################
###############################################################################
###############################################################################

## instaluji a loaduji balíčky ------------------------------------------------

for(my_package in c(
    
    "Cairo"    # není nutné (v dalším skriptu ho nakonec nepoužíváme)
    
)){
    
    if(
        !(my_package %in% rownames(installed.packages()))
    ){
        
        install.packages(
            my_package,
            dependencies = TRUE,
            repos = "http://cran.us.r-project.org"
        )
        
    }
    
    library(my_package, character.only = TRUE)
    
}


## ----------------------------------------------------------------------------

###############################################################################

## nastavuji pracovní složku --------------------------------------------------

while(!"_script_.R" %in% dir()){
    setwd(choose.dir())
}

mother_working_directory <- getwd()

## ----------------------------------------------------------------------------

###############################################################################

## tabulka s pravděpodobnostmi, že při hodu dvěma laplaceovými kostkami
## bude součet ok obou kostek roven číslu $x$ ---------------------------------

my_table <- list(
    "x" = as.numeric(1:12),
    "pravdepodobnost_x" = unlist(
        lapply(
            1:12,
            function(x){
                sum(outer(1:6, 1:6, "+") == x) / 36
            }
        )
    )
)


## diagram součet $x$ vs. pravděpodobnost, že obě hozené kostky mají součet
## ok roven číslu $x$ ---------------------------------------------------------

cairo_ps(
    file = "pravdepodobnost_souctu_x.eps",
    width = 8,
    height = 5.4,
    pointsize = 16,
    family = "serif"     # patkový font, vhodný kvůli matematické notaci
)

par(mar = c(4.1, 4.1, 0.1, 0.1))

plot(
    x = my_table[["x"]],
    y = my_table[["pravdepodobnost_x"]],
    xlab = expression(italic(x)),
    ylab = "",
    xaxt = "n",    # zakazuji vykreslení vodorovné osy
    yaxt = "n",    # zakazuji vykreslení svislé osy
    pch = 19
)

## všimněme si, že má-li popisek osy obsahovat současně písmeno (či písmena)
## s diakritikou (ě ve slově pravděpodobnost) a matematickou notaci
## ($P(\textrm{součet ok obou kostek} = x)$), není možné použít
## obvyklý xlab či ylab, ale popisek se musí sestavit pomocí
## funkce pro text kopírující osu diagramu mtext();
## ani engine cairo_pdf() či cairo_ps() oboje najednou neumí ------------------

mtext(
    text = "pravděpodobnost     (součet ok obou kostek =   )",
    side = 2,
    line = 3
)   # počet mezer jsem prostě jen odhadl metodou error-trial, celkem "fishy",
    # není to moc elegantní a zabere to čas, ale dle mě a mnohých fór asi
    # jediné řešení pro češtinu & matematiku současně v diagramech v R

mtext(
    text = expression(italic(P)),
    side = 2,      # side = 2 pro svislou osu
    line = 3,      # vzdálenost od canvasu diagramu v jednotkách vodorovné osy
    at = 0.0655    # opět, pozici dle jednotky svislé osy odhaduji od oka
)

mtext(
    text = expression(italic(x)),
    side = 2,
    line = 3,
    at = 0.168     # same story here
)

axis(
    side = 1,
    at = 1:12,
    labels = as.character(1:12)
)

axis(
    side = 2,
    at = seq(0, 0.15, 0.05),
    labels = gsub(
        "\\.",
        ",",
        format(
            round(
                seq(0, 0.15, 0.05),
                digits = 2
            ),
            nsmall = 2
        )
    )   # nahrazuju desetinnou tečku za čárku, must-do v česky
        # mluvících diagramech
)

dev.off()


# -----------------------------------------------------------------------------

## stejný diagram, ale pro cvičné účely tentokrát v popiscích použijeme
## jen matematickou notaci, tvorba popisku se tím zjednoduší ------------------

cairo_ps(
    file = "pravdepodobnost_souctu_x_formalneji.eps",
    width = 8,
    height = 5.4,
    pointsize = 16,
    family = "serif"     # patkový font, vhodný kvůli matematické notaci
)

par(mar = c(4.1, 4.1, 0.1, 0.1))

plot(
    x = my_table[["x"]],
    y = my_table[["pravdepodobnost_x"]],
    xlab = expression(italic(x)),
    ylab = expression(
        paste(
            italic(P)[italic(X)],
            "(",
            italic(x),
            ") = ",
            italic(P),
            "(",
            italic(X),
            " = ",
            italic(x),
            ")",
            sep = ""
        )
    ),
    xaxt = "n",    # zakazuji vykreslení vodorovné osy
    yaxt = "n",    # zakazuji vykreslení svislé osy
    pch = 19
)

axis(
    side = 1,
    at = 1:12,
    labels = as.character(1:12)
)

axis(
    side = 2,
    at = seq(0, 0.15, 0.05),
    labels = gsub(
        "\\.",
        ",",
        format(
            round(
                seq(0, 0.15, 0.05),
                digits = 2
            ),
            nsmall = 2
        )
    )   # nahrazuju desetinnou tečku za čárku, must-do v česky
        # mluvících diagramech
)

dev.off()


# -----------------------------------------------------------------------------

## do třetice stejný diagram, ale bez matematické notace v popiscích ----------

cairo_ps(
    file = "pravdepodobnost_souctu_x_neformalne.eps",
    width = 8,
    height = 5.4,
    pointsize = 16,
    family = "serif"     # patkový font, vhodný kvůli matematické notaci
)

par(mar = c(4.1, 4.1, 0.1, 0.1))

plot(
    x = my_table[["x"]],
    y = my_table[["pravdepodobnost_x"]],
    xlab = "možná hodnota součtu ok obou kostek",
    ylab = "pravděpodobnost dané hodnoty součtu ok kostek",
    xaxt = "n",    # zakazuji vykreslení vodorovné osy
    yaxt = "n",    # zakazuji vykreslení svislé osy
    pch = 19
)

axis(
    side = 1,
    at = 1:12,
    labels = as.character(1:12)
)

axis(
    side = 2,
    at = seq(0, 0.15, 0.05),
    labels = gsub(
        "\\.",
        ",",
        format(
            round(
                seq(0, 0.15, 0.05),
                digits = 2
            ),
            nsmall = 2
        )
    )   # nahrazuju desetinnou tečku za čárku, must-do v česky
        # mluvících diagramech
)

dev.off()


## ----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################





