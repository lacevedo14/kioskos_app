import 'package:flutter/material.dart';

class ResultItem extends StatelessWidget {
  final String mainText;
  final String subtitleText;

  const ResultItem({
    Key? key,
    required this.mainText,
    required this.subtitleText,
  }) : super(key: key);

  // Lista de subtítulos válidos
  static const List<String> validSubtitles = [
    "Pulse Rate",
    "Respiration Rate",
    "Hemoglobin",
    "Hemoglobin A1C",
    "PNS Zone",
    "SNS Zone",
    "Stress Level",
    "Error",
    "error",
  ];

  // Mapa que traduce el subtítulo al español
  static const Map<String, String> subtitleTranslations = {
    "Pulse Rate": "Frecuencia Cardíaca",
    "Respiration Rate": "Frecuencia Respiratoria",
    "Hemoglobin": "Hemoglobina",
    "Hemoglobin A1C": "Hemoglobina A1C",
    "PNS Zone": "Capacidad de Recuperación",
    "SNS Zone": "Respuesta al Estrés",
    "Stress Level": "Nivel de Estrés",
    "Error": "Error",
  };

  // Función que devuelve la descripción según el resultado
  String getDescription(String key) {
    switch (key) {
      case "Pulse Rate":
        return "El número de veces que el corazón de una persona late por minuto (BPM).";
      case "Respiration Rate":
        return "Cantidad de respiraciones por minuto.";
      case "Hemoglobin":
        return "La hemoglobina es una proteína en los glóbulos rojos que transporta oxígeno a los órganos y tejidos, y lleva dióxido de carbono de vuelta a los pulmones. Se mide en g/dL con una precisión de 0.1 g/dL. Los rangos saludables según el género son: Hombres: 14-18 g/dL; Mujeres: 12-16 g/dL.";
      case "Hemoglobin A1C":
        return "La hemoglobina A1C (HbA1c) representa el promedio de glucosa en sangre de los últimos 2-3 meses. Se mide en porcentaje con una precisión de hasta 0.01%. Rango de HbA1c: Normal: <5.6%, Riesgo de prediabetes: 5.7-6.4%, Riesgo de diabetes: >6.5%.";
      case "PNS Zone":
        return "La Capacidad de Recuperación, o respuesta de 'descanso y digestión', es la habilidad del cuerpo para recuperarse y regularse tras el estrés. Forma parte del sistema autónomo, que incluye el simpático (Estrés) y el parasimpático (Recuperación). La Variabilidad de la Frecuencia Cardíaca muestra el equilibrio entre estos. Hay tres zonas de Recuperación.";
      case "SNS Zone":
        return "La Respuesta al Estrés, o 'lucha o huida', es una reacción que prepara al cuerpo para enfrentar o escapar del peligro. Involucra el sistema simpático (Estrés) y parasimpático (Recuperación). La Variabilidad de la Frecuencia Cardíaca refleja su equilibrio.";
      case "Stress Level":
        return "La reacción del cuerpo ante un desafío o demanda. Hay cinco niveles de estrés. El cuerpo está diseñado para experimentar y reaccionar al estrés. Puede ser positivo, manteniéndonos alerta y motivados, pero se vuelve problemático cuando los factores estresantes persisten sin descanso.";
      default:
        return "";
    }
  }

  // Función que devuelve el footer según el resultado, puede ser texto o imagen
  dynamic getFooter(String key) {
    switch (key) {
      case "Hemoglobin":
        return "Hombres: 14-18 g/dL; Mujeres: 12-16 g/dL.";
      case "Hemoglobin A1C":
        return "Normal: <5.6%.";
      case "Pulse Rate":
        return "60 - 80 LPM.";
      case "Respiration Rate":
        return "12-20 RPM.";
      case "Stress Level":
        return 'assets/images/icons.png'; // Ruta de la imagen
      case "SNS Zone":
        return 'assets/images/sastifacion_I_D.png'; // Ruta de la imagen
      case "PNS Zone":
        return 'assets/images/sastifacion_D_I.png'; // Ruta de la imagen
      default:
        return "";  // Devuelve una cadena vacía si no hay imagen o texto
    }
  }

  // Función que devuelve la imagen según el mainText para los casos específicos
  String? getImageForMainText(String subtitle, String mainText) {
    if (subtitle == "PNS Zone") {
      if (mainText == "medium" || mainText == "mild") {
        return 'assets/images/Normal.png';  // Imagen para PNS Zone con valor "medium"
      } else if (mainText == "low") {
        return 'assets/images/VeryHigh.png';  // Imagen para PNS Zone con valor "low"
      } else if (mainText == "high") {
        return 'assets/images/Low.png';  // Imagen para PNS Zone con valor "high"
      }
    } else if (subtitle == "SNS Zone") {
      if (mainText == "medium" || mainText == "mild") {
        return 'assets/images/Normal.png';  // Imagen para SNS Zone con valor "medium"
      } else if (mainText == "low") {
        return 'assets/images/Low.png';  // Imagen para SNS Zone con valor "low"
      } else if (mainText == "high") {
        return 'assets/images/VeryHigh.png';  // Imagen para SNS Zone con valor "high"
      }
    } else if (subtitle == "Stress Level") {
      if (mainText == "low") {
        return 'assets/images/Low.png';  // Imagen para Stress Level con valor "Low"
      } else if (mainText == "normal") {
        return 'assets/images/Normal.png';  // Imagen para Stress Level con valor "Normal"
      } else if (mainText == "medium" || mainText == "mild") {
        return 'assets/images/Mild.png';  // Imagen para Stress Level con valor "Mild"
      } else if (mainText == "high") {
        return 'assets/images/High.png';  // Imagen para Stress Level con valor "High"
      } else if (mainText == "veryhigh") {
        return 'assets/images/VeryHigh.png';  // Imagen para Stress Level con valor "Very High"
      }
    }
    return null;  // Si no hay imagen disponible para el mainText
  }

  @override
  Widget build(BuildContext context) {
    // Verifica si hay "Error" en el mainText o en el subtitleText
    bool isError = mainText.toLowerCase().contains("error") || subtitleText.toLowerCase().contains("error");

    // Usamos el mapa de traducción para mostrar la etiqueta en español
    String translatedSubtitleText = subtitleTranslations[subtitleText] ?? subtitleText;
    String description = getDescription(subtitleText);
    var footer = getFooter(subtitleText);
    String? mainTextImage = getImageForMainText(subtitleText, mainText);

    // Estilos condicionales para el mainText y el subtitleText en caso de "Error"
    TextStyle mainTextStyle = TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: isError ? 28 : 48, // Fuente más grande si es error
      color: isError ? Colors.red : Colors.black, // Cambiar color si es error
    );

    TextStyle subtitleTextStyle = TextStyle(
      color: isError ? Colors.grey : const Color(0xFF3A598F), // Color gris si es error, de lo contrario toma el color 0xFFF6F6F6
      fontWeight: FontWeight.w500,
      fontSize: isError ? 17 : 21, // Fuente más pequeña si es error
    );

    TextStyle descriptionTextStyle = TextStyle(
      fontSize: 15,
      color: Colors.black87,
    );

    // Modificar la validación para permitir mostrar si hay "Error" o "error"
    if (validSubtitles.contains(subtitleText) || mainText.toLowerCase().contains("error")) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),  // Limitar el ancho máximo
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                mainTextImage != null  // Mostrar la imagen si hay una disponible para mainText
                    ? Image.asset(
                  mainTextImage,
                  width: double.infinity,  // Ancho 100% del contenedor
                  height: 100,  // Puedes ajustar la altura de la imagen
                  fit: BoxFit.contain,  // Ajusta la imagen para que ocupe el 100% del ancho
                )
                    : Text(
                  mainText,
                  style: mainTextStyle,  // Usar el estilo condicional para el mainText
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  translatedSubtitleText,  // Mostrar el subtitleText traducido
                  style: subtitleTextStyle,  // Usar el estilo condicional para el subtitleText
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,  // Descripción centrada
                  style: descriptionTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Divider(
                  thickness: 1,
                  color: Color(0xFFF6F6F6),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  // Si footer es una ruta de imagen, muestra la imagen, de lo contrario muestra el texto
                  child: footer is String && footer.endsWith('.png')
                      ? Image.asset(
                    footer,  // Mostrar la imagen si hay una ruta
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.contain,
                  )
                      : footer.isNotEmpty
                      ? Text(
                    footer,  // Mostrar el texto del footer
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A598F),
                    ),
                    textAlign: TextAlign.center,
                  )
                      : const SizedBox.shrink(),  // Si footer está vacío, no mostrar nada
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();  // No renderizamos nada si no es válido
    }
  }
}
