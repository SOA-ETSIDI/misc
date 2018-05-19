## Modifico downloadButton para cambiar icono
downloadButton2 <- function(outputId, label, iconName)
{
    tags$a(id = outputId,
           class = "btn btn-default shiny-download-link",
           href = "",
           target = "_blank",
           icon(iconName),
           label)
}


## ¿A que titulación corresponde cada grupo?
whichDegree <- function(x){
    x <- strsplit(as.character(x), '[[:digit:]]')
    x <- sapply(x, function(y) y[1])
    ifelse(x == 'D', '56DD',
    ifelse(x %in% c('DM', 'EE'), paste0('56', x),
           paste0('56I', x)))
}
## A que curso corresponde cada grupo?
whichCurso <- function(x)
{
    N <- nchar(x)
    as.numeric(substr(x, N - 2, N - 2))
}

## Grupos de matriculacion, mañana o tarde
MoT <- function(x)
{
    N <- nchar(x)
    id <- as.numeric(substr(x, N, N))
    ifelse(id %in% 1:5 | x == "M406", 'M', 'T')
}

## Reduce string de tipo de docencia
abTipo <- function(x)
{
    idx <- charmatch(x, tipos)
    sTipos[idx]
}

## Función para enlazar la Guía de aprendizaje
isEven <- function(x) x %% 2 == 0

GAurl <- function(cod, grado, sem, curso = '2015-16')
{
    mainURL <- "https://www.upm.es/comun_gauss/publico/guias/"
    semString <- paste0(ifelse(isEven(sem), 2, 1), 'S')

    paste0(mainURL,
           curso, '/',
           semString,
           '/GA_', grado,
           '_', cod,
           '_', semString,
           '_', curso, '.pdf')
}

## Extrae el hash del nombre de un fichero docencia_*.csv o tutoria_*.csv
extractHashes <- function(x)
{
    ll <- strsplit(file_path_sans_ext(x), split = '_')
    sapply(ll, function(l) l[2])
}

## Funciones relacionadas con las horas

## Añade un 0 si es necesario a un character que representa una hora
formatHora <- function(x)
{
    format(as.POSIXct(x, format='%H:%M'),
           format = '%H:%M')
}

## A un character (x) que define una hora le suma una cantidad de horas (h), y devuelve de nuevo un character.
sumaHora <- function(x, h)
{
    s <- as.POSIXct(x, format = '%H:%M') + h * 3600
    format(s, format = '%H:%M')
}

## Suma todas las horas de tutoria de un registro completo
sumaHoras <- function(tutoria)
{
    if (nrow(tutoria) > 0)
    sum(apply(tutoria[, c("Desde", "Hasta")], 1,
              function(x)diffHour(x[1],x[2])))
    else 0
}

## Secuencia de horas en formato character
hhSeq <- function(h1 = '08:15', h2 = '20:45', by = '15 min')
{
    h1 <- as.POSIXct(h1, format = '%H:%M')
    h2 = as.POSIXct(h2, format = '%H:%M')
    hh <- seq(h1, h2, by = by)
    ## El último tramo siempre termina en h2. Así garantizo que cuando
    ## by = "1 hour" (p.ej.) y no hay horas completas, el tramo
    ## termina correctamente.
    hh[length(hh)] <- h2
    format(hh, format = '%H:%M')
}

## Función para calcular la diferencia en horas entre dos cadenas de
## caracteres que representan horas
diffHour <- function(h1, h2)
{
    delta <- as.POSIXct(h2, format = '%H:%M') - as.POSIXct(h1, format = '%H:%M')
    as.numeric(delta, units = 'hours')
}

## TITLECASE
# This is a list of words that we generally do not want to capitalize.
special.words = c('a', 'an', 'and', 'as', 'at', 'but', 'by', 'en', 'for',
                  'if', 'in', 'of', 'on', 'or', 'the', 'to', 'v' , 'v.',
                  'via', 'vs',  'vs.',
                  'uno', 'y', 'e', 'u', 'como', 'en', 'pero', 'por', 'para',
                  'si', 'en', 'de', 'del', 'o', 'el', 'la', 'lo', 'los', 'las', 'a')

# We need to know whether a character is part of the alphabet. This function
# decides that using regular expressions.
non.alphabetical.character = function(str)
{
    if (regexpr('[[:alpha:]]', str)[1] == -1)
    {
        return(TRUE)
    }
    else
    {
        return(FALSE)
    }
}
     
# If we are given a single word, we use this function to capitalize it. We
# assume that the word should be capitalized, so words should be filtered
# before reaching this function.
capitalize = function(str)
{
    # We want to skip any non-alphabetical characters at the start.
    i = 1

    while (non.alphabetical.character(substr(str, i, i)) & nchar(str) > i)
    {
        i = i + 1
    }
    
    sub.word = substr(str, i, nchar(str))

    ## Si hay un caracter no alfabético en medio (un guión), pongo en
    ## mayúsculas la primera letra de la palabra, y la que va justo
    ## después del guión
    idx <- 1 + regexpr('[^[:alpha:]][[:alpha:]]', sub.word)[1]
    if (idx > 0)
    {
        str = tolower(str)
        substr(str, i, i) = toupper(substr(str, i, i))
        substr(str, idx, idx) = toupper(substr(str, idx, idx))
        return(str)
    }
    # Otherwise, we simply make the first alphabetical character uppercase.
    else
    {
        str = tolower(str)
        substr(str, i, i) = toupper(substr(str, i, i))
        return(str)
    }
}

# We'll use this function to capitalize a vector of words.
smart.capitalize = function(words)
{
    output = c()

    for (word in words)
    {
        if (word %in% special.words)
        {
            output = c(output, tolower(word))
        }
        else if (word %in% c('i', 'ii', 'iii', 'iv'))
        {
            output = c(output, toupper(word))
        }
        else
        {
            output = c(output, capitalize(word))
        }
    }
    
    return(output)
}

# We'll use this function to capitalize an entire sentence. In the process,
# we'll capitalize words at the front and at the end, no matter what words
# they are.
titlecase1 <- function(str)
{
    str <- tolower(str)
    # We want to be careful with all of the words as a first pass.
    words = smart.capitalize(strsplit(str, ' ')[[1]])
    N <- length(words)
    # Then we'll blindly capitalize the words at the ends of the sentence.
    words[1] = capitalize(words[1])
    if (!(words[N] %in%  c("I", "II", "III", "IV")))
        words[N] <- capitalize(words[N])

    # Finally, we'll put our string back together again.
    output = words[1]
    for (word in words[-1])
    {
        output = paste(output, word)
    }

    return(output)
}


## Función para usar con un vector
titlecase <- function(x)
{
    TC <- lapply(x, titlecase1)
    do.call(c, TC)
}

## Añade {} a un vector de character
braces <- function(x) paste0("{", x, "}", collapse = "")


## Es un evento de un día, o una secuencia? Empleado en csv2pdf.R y csv2ics.R
isOneDay <- function(inicio, final)
{
    (is.na(final) | inicio == final)
}

## Función para generar un evento de calendario en forma iCal
makeEvent <- function(titulo, descripcion, categoria,
                      inicio, final, lugar = "",
                      UUID)
{
    UID <- paste0('UID:', UUID)
    start <- if (inherits(inicio, 'Date'))
                 format(inicio, 'DTSTART;VALUE=DATE:%Y%m%d')
             else
                 format(inicio, 'DTSTART:%Y%m%dT%H%M%S')
    end <- if (inherits(final, 'Date'))
               format(final, 'DTEND;VALUE=DATE:%Y%m%d')
           else
               format(final, 'DTEND:%Y%m%dT%H%M%S')
    ##sFreq <- 'RRULE:FREQ=WEEKLY;INTERVAL=1'
    titulo <- paste0('SUMMARY:', titulo)
    lugar <- paste0('LOCATION:', lugar)
    descripcion <- paste0('DESCRIPTION:', descripcion)
    categoria <- paste0('CATEGORIES:', categoria)

    sEvent <- paste('BEGIN:VEVENT',
                    UID,
                    start, end, ##sFreq,
                    titulo, lugar, descripcion, categoria,
                    'END:VEVENT',
                    sep = '\n')
    sEvent
}

## Función para generar un calendario completo por cada grupo.
makeCalendar <- function(titulo, descripcion,
                         inicio, final,
                         UUID, calname)
{
    sHead <- paste('BEGIN:VCALENDAR', 'VERSION:2.0', 
                   paste0('X-WR-CALNAME:', calname),
                   'PRODID:Subdirección de Ordenación Académica',
                   'X-WR-TIMEZONE:CET',
                   paste0('X-WR-CALDESC:', calname),
                   'CALSCALE:GREGORIAN',
                   sep = '\n')

    sTail <- 'END:VCALENDAR'

    sEvent <- makeEvent(titulo = titulo,
                        descripcion = descripcion,
                        categoria = calname,
                        inicio = inicio,
                        final = final,
                        UUID = UUID)
    sEvents <- paste(sEvent, collapse = '\n')

    paste(sHead, sEvents, sTail, sep = '\n')
}
