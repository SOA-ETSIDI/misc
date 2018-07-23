## Descarga información de API-UPM
library(jsonlite)
library(data.table)

source('defs.R')

getJSON <- function(codigo)
{
    jsonInfo <- fromJSON(paste0("https://www.upm.es/wapi_upm/estaticos/academico/201718/",
                                codigo,
                                "_asignaturas_v2.json"))
    titulacion <- jsonInfo$codigo_plan
    
    jsonData <- jsonInfo$datos

    datos <- lapply(jsonData, function(x)
    {
        codigo <- x$codigo
        nombre <- x$nombre
        semestre <- names(x$imparticion)
        if (!is.null(semestre))## asignaturas de complementos formativos
        {
            if (semestre == "I") ## TFM y Prácticas
                semestre <- 2
            else 
                semestre <- as.numeric(substring(semestre, 1, 1))
            with(x, cbind(titulacion, codigo, nombre, semestre))
        }

    })

    datos <- do.call(rbind, datos)
    datos <- as.data.frame(datos, stringsAsFactors = FALSE)
    names(datos) <- c("Titulacion", "Codigo", "Asignatura", "Semestre")
    datos$Codigo <- as.numeric(datos$Codigo)
    datos$Semestre <- as.numeric(datos$Semestre)
    datos
}

MUIP <- getJSON("56AD")
MUIE <- getJSON("56AE")
MUIDI <- getJSON("56AC")

infoMasters <- rbind(MUIP, MUIE, MUIDI)


IM <- getJSON("56IM")
IQ <- getJSON("56IQ")
IA <- getJSON("56IA")
IE <- getJSON("56IE")
DD <- getJSON("56DD")

infoGrado <- rbind(IM, IQ, IA, IE, DD)

DM <- getJSON("56DM")
EE <- getJSON("56EE")

infoDobleGrado <- rbind(DM, EE)

infoETSIDI <- rbind(infoGrado, infoDobleGrado, infoMasters)
infoETSIDI <- as.data.table(infoETSIDI)


## Comparo con fichero local
asignaturas <- fread('../misc/asignaturas.csv')
asignaturas[, Codigo := as.numeric(Codigo)]

## Asignaturas que están en el fichero Asignaturas.csv pero no en la web UPM
difETSIDI <- fsetdiff(asignaturas[, .(Titulacion, Codigo)],
                 infoETSIDI[, .(Titulacion, Codigo)])
## Muestro resultados para titulaciones ETSIDI
asignaturas[Titulacion %in% c(grados, masters) &
            Codigo %in% difETSIDI$Codigo]

## Asignaturas que están en la web UPM pero no están en el fichero Asignaturas.csv
difUPM <- fsetdiff(infoETSIDI[, .(Titulacion, Codigo)],
                   asignaturas[, .(Titulacion, Codigo)])
## Muestro resultados para titulaciones ETSIDI
infoETSIDI[Titulacion %in% c(grados, masters) &
           Codigo %in% difUPM$Codigo]

## Genero un fichero por titulación. Deberían contener prácticas en
## empresa, optativas de movilidad, y optativas de otras titulaciones
lapply(c(grados, masters), function(titulo)
    write.csv2(infoETSIDI[Titulacion == titulo &
                          Codigo %in% difUPM$Codigo],
               file = paste0('difAsignaturas_', titulo, '.csv'),
               row.names = FALSE)
    )

## write.csv2(infoMasters, file = 'asignaturasMaster.csv', row.names = FALSE)
## write.csv2(infoGrado, file = 'asignaturasGrado.csv', row.names = FALSE)
## write.csv2(infoDobleGrado, file = 'asignaturasDobleGrado.csv', row.names = FALSE)
## write.csv2(infoETSIDI, file = 'asignaturasETSIDI.csv', row.names = FALSE)
