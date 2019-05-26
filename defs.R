##################################################################
## Curso y Semestre
##################################################################

semestreActual <- 2

cursoActual <- '2018-19'

##################################################################
## Definiciones generales de la ETSIDI
##################################################################


## Días de la semana
dias <- c("Lunes", "Martes", "Miércoles", "Jueves", "Viernes")

## Hora Tuthora y Comedor
tuthoraM <- c("11.30", "12.00")
tuthoraT <- c("17.00", "17.30")

comedorM <- c("14.00", "15.30")
comedorT <- c("13.30", "15.00")


## Tipos de docencia
tipos <- c("Acciones Cooperativas", "Laboratorio", "Teoría y Problemas")
sTipos <- c("AC", "Lab", "TyP")

## Aulas
aulas <- read.csv2('../misc/aulas.csv',
                   stringsAsFactors = FALSE)
aulas <- aulas$Aula

## Código y nombre de departamentos
dptoCode <- c('D180', ## Ingeniería Eléctrica, Electrónica Automática y Física Aplicada
              'D190', ## Ingeniería Mecánica, Química y Diseño Industrial
              'D440', ## Matemáticas del área Industrial
              'D240', ## Lingüística Aplicada a la Ciencia y a la Tecnología
              'D400'  ## Ingeniería de Organización, Administración de Empresas y Estadística
              )

dptoName <- c('Ingeniería Eléctrica, Electrónica Automática y Física Aplicada',
              'Ingeniería Mecánica, Química y Diseño Industrial',
              'Matemática Aplicada a la Ingeniería Industrial',
              'Lingüística Aplicada a la Ciencia y a la Tecnología',
              'Ingeniería de Organización, Administración de Empresas y Estadística')
dptos <- data.frame(codigo = dptoCode,
                    nombre = dptoName,
                    stringsAsFactors = FALSE)

## Titulaciones
grados <- paste0(56, c('IA', 'IE', 'IM', 'IQ', 'DD'))
names(grados) <- paste('Grado en Ingeniería',
                       c('Electrónica Industrial y Automática',
                         'Eléctrica',
                         'Mecánica',
                         'Química',
                         'en Diseño Industrial y Desarrollo de Producto')
                       )

dobleg <- c('56DM', '56EE')
names(dobleg) <- c('Doble Grado en Ingeniería en Diseño Industrial y Desarrollo de Producto y en Ingeniería Mecánica',
                   'Doble Grado en Ingeniería Eléctrica y en Ingeniería Electrónica')

grados <- c(grados, dobleg)

grupos <- c("M101", "D102", "Q103", "A104", "E105", "EE105",
            "M106", "D107", "DM107", "A109", "E100", 
            "M201", "DM201", "D202", "Q203", "A204", "E205",
            "M206", "A207", "E208", "EE208",
            "M301", "A302", "E303", "EE309",
            "M306", "D307", "DM306", "Q308", "A309",
            "M401", "D402", "DM401", "DM406", "Q403", "A404",
            "M406", "E407", "A408",
            "DM502", "EE403", "EE507")

masters <- c('56AD', '56AE', '56AC')
names(masters) <- paste('Máster Universitario en Ingeniería',
                        c('de Producción',
                          'Electromecánica',
                          'en Diseño Industrial')
                        )

otrosMaster <- c('05AX', '06AH', '20AE')
names(otrosMaster) <- c('Máster Universitario en Ingenieria de la Energía',
                        'Máster Universitario en Eficiencia Energética en la Edificación, la Industria y el Transporte',
                        'Máster Universitario en Estrategias y Tecnologías para el Desarrollo')

optativasIS <- c('IS')
names(optativasIS) <- "International Semester"

titulaciones <- c(grados, masters, otrosMaster, optativasIS)

##################################################################
## Logos
##################################################################
logoUPM <- "http://www.upm.es/sfs/Rectorado/Gabinete%20del%20Rector/Logos/UPM/Logotipo/LOGOTIPO%20color%20PNG.png"
logoETSIDI <- "http://www.upm.es/sfs/Rectorado/Gabinete%20del%20Rector/Logos/EUIT_Industrial/Logo_color.png"
