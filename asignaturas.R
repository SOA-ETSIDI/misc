## Descarga información de API-UPM
library(jsonlite)

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
write.csv2(infoMasters, file = 'asignaturasMaster.csv', row.names = FALSE)
