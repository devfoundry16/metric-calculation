module Main

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
