module Main
import IO;
import String;
import List;
import Set;
import Map;
import util::Math;
import util::FileSystem;
// Data structure for metrics
data Metrics = metrics(
    int linesOfCode,
    int numberOfUnits,
    map[str, real] unitSizeDistribution,
    map[str, real] unitComplexityDistribution,
    real duplicationPercentage,
    str volumeScore,
    str unitSizeScore,
    str unitComplexityScore,
    str duplicationScore,
    str analysabilityScore,
    str changeabilityScore,
    str testabilityScore,
    str overallMaintainabilityScore
);
// Print formatted analysis results
public void printMetrics(Metrics m) {
    println("lines of code: <m.linesOfCode>");
    println("number of units: <m.numberOfUnits>");
    println("unit size:");
    println("* simple: <toInt(m.unitSizeDistribution["simple"])>%");
    println("* moderate: <toInt(m.unitSizeDistribution["moderate"])>%");
    println("* high: <toInt(m.unitSizeDistribution["high"])>%");
    println("* very high: <toInt(m.unitSizeDistribution["very high"])>%");
    println("unit complexity:");
    println("* simple: <toInt(m.unitComplexityDistribution["simple"])>%");
    println("* moderate: <toInt(m.unitComplexityDistribution["moderate"])>%");
    println("* high: <toInt(m.unitComplexityDistribution["high"])>%");
    println("* very high: <toInt(m.unitComplexityDistribution["very high"])>%");
    println("duplication: <toInt(m.duplicationPercentage)>%");
    println("volume score: <m.volumeScore>");
    println("unit size score: <m.unitSizeScore>");
    println("unit complexity score: <m.unitComplexityScore>");
    println("duplication score: <m.duplicationScore>");
    println("analysability score: <m.analysabilityScore>");
    println("changability score: <m.changeabilityScore>");
    println("testability score: <m.testabilityScore>");
    println("overall maintainability score: <m.overallMaintainabilityScore>");
}

// Calculate lines of code for all Java files
public int calculateVolume(set[loc] javaFiles) {
    int totalLines = 0;
    for (file <- javaFiles) {
        try {
            int lineCount = (0 | it + 1 | _ <- readFileLines(file));
            totalLines += lineCount;
        } catch: {
            continue;
        }
    }
    return totalLines;
}

// Classify unit size in lines of code
public str classifyUnitSize(int linesOfCode) {
    if (linesOfCode <= 15) return "simple";
    if (linesOfCode <= 30) return "moderate";
    if (linesOfCode <= 60) return "high";
    return "very high";
}

// Classify complexity level
public str classifyComplexity(int complexity) {
    if (complexity <= 3) return "simple";
    if (complexity <= 7) return "moderate";
    if (complexity <= 10) return "high";
    return "very high";
}

// Calculate cyclomatic complexity for code - simple text-based approach
public int cyclomaticComplexity(str methodCode) {
    int complexity = 1;
    complexity += (0 | it + 1 | /if/ := methodCode);
    complexity += (0 | it + 1 | /else/ := methodCode);
    complexity += (0 | it + 1 | /case/ := methodCode);
    complexity += (0 | it + 1 | /catch/ := methodCode);
    complexity += (0 | it + 1 | /for/ := methodCode);
    complexity += (0 | it + 1 | /while/ := methodCode);
    complexity += (0 | it + 1 | /\?/ := methodCode);
    return complexity;
}

// Calculate distribution of unit sizes
public map[str, real] calculateUnitSizeDistribution(list[str] allLines) {
    map[str, int] distribution = ("simple": 0, "moderate": 0, "high": 0, "very high": 0);
    int totalUnits = 0;
    
    int currentMethodStart = -1;
    for (i <- [0 .. size(allLines)]) {
        str line = trim(allLines[i]);
        if (contains(line, "public") && contains(line, "(")) {
            if (currentMethodStart >= 0) {
                int unitLines = i - currentMethodStart;
                str classification = classifyUnitSize(unitLines);
                distribution[classification] = distribution[classification] + 1;
                totalUnits += 1;
            }
            currentMethodStart = i;
        }
    }
    
    if (currentMethodStart >= 0) {
        int unitLines = size(allLines) - currentMethodStart;
        str classification = classifyUnitSize(unitLines);
        distribution[classification] = distribution[classification] + 1;
        totalUnits += 1;
    }
    
    map[str, real] result = ("simple": 0.0, "moderate": 0.0, "high": 0.0, "very high": 0.0);
    if (totalUnits > 0) {
        for (key <- distribution) {
            result[key] = (toReal(distribution[key]) / toReal(totalUnits)) * 100.0;
        }
    }
    
    return result;
}

// Calculate distribution of complexity levels
public map[str, real] calculateComplexityDistribution(list[str] allLines) {
    map[str, int] distribution = ("simple": 0, "moderate": 0, "high": 0, "very high": 0);
    int totalUnits = 0;
    
    int currentMethodStart = -1;
    str currentMethodCode = "";
    
    for (i <- [0 .. size(allLines)]) {
        str line = allLines[i];
        if (contains(trim(line), "public") && contains(line, "(")) {
            if (currentMethodStart >= 0) {
                int complexity = cyclomaticComplexity(currentMethodCode);
                str classification = classifyComplexity(complexity);
                distribution[classification] = distribution[classification] + 1;
                totalUnits += 1;
            }
            currentMethodStart = i;
            currentMethodCode = "";
        }
        currentMethodCode = currentMethodCode + line + "\n";
    }
    
    if (currentMethodStart >= 0) {
        int complexity = cyclomaticComplexity(currentMethodCode);
        str classification = classifyComplexity(complexity);
        distribution[classification] = distribution[classification] + 1;
        totalUnits += 1;
    }
    
    map[str, real] result = ("simple": 0.0, "moderate": 0.0, "high": 0.0, "very high": 0.0);
    if (totalUnits > 0) {
        for (key <- distribution) {
            result[key] = (toReal(distribution[key]) / toReal(totalUnits)) * 100.0;
        }
    }
    
    return result;
}

public int main() {
    try {
        loc projectRoot = |file:///Users/dev/java_projects|;
        Metrics metrics = analyzeJavaProject(projectRoot);
        printMetrics(metrics);
        return 0;
    } catch err: {
        println("Error analyzing project: <err>");
        return 1;
    }
}
