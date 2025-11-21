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
