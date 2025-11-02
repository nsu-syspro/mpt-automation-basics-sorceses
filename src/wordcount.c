#include <stdio.h>
#include <ctype.h>
#include <string.h>

// Configuration
#ifndef NAME
#define NAME "wordcount"
#endif
#ifndef VERSION
#define VERSION "1.0.0"
#endif

// Function declarations
long count_words(FILE *stream);
long count_words_file(const char *filename);
void print_help();
void print_version();

int main(int argc, char *argv[]) {
    int show_help = 0;
    int show_version = 0;
    int file_count = 0;
    
    // Parse command line arguments
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            show_help = 1;
        } else if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--version") == 0) {
            show_version = 1;
        } else {
            // Treat as filename
            file_count++;
        }
    }
    
    // Show help if requested
    if (show_help) {
        print_help();
        return 0;
    }
    
    // Show version if requested
    if (show_version) {
        print_version();
        return 0;
    }
    
    // Process files if provided
    if (file_count > 0) {
        long word_count = 0;
        
        for (int i = 1; i < argc; i++) {
            if (strcmp(argv[i], "-h") != 0 && 
                strcmp(argv[i], "--help") != 0 &&
                strcmp(argv[i], "-v") != 0 && 
                strcmp(argv[i], "--version") != 0) {
                
                word_count += count_words_file(argv[i]);
            }
        }

        printf("%ld\n", word_count);
        
        return 0;
    }
    
    // If no files provided, read from stdin
    long word_count = count_words(stdin);
    printf("%ld\n", word_count);
    
    return 0;
}

long count_words(FILE *stream) {
    int c;
    long words = 0;
    int in_word = 0;
    
    while ((c = fgetc(stream)) != EOF) {
        if (isspace(c)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            words++;
        }
    }
    
    return words;
}

long count_words_file(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        fprintf(stderr, "Error: Cannot open file '%s'\n", filename);
        return 0;
    }
    
    long word_count = count_words(file);
    
    fclose(file);

    return word_count;
}

void print_help() {
    printf("Usage: %s [OPTION]... [FILE]...\n", NAME);
    printf("Count words in files or from standard input.\n\n");
    printf("With no FILE, read standard input.\n\n");
    printf("Options:\n");
    printf("  -h, --help     display this help and exit\n");
    printf("  -v, --version  output version information and exit\n\n");
    printf("Examples:\n");
    printf("  %s file.txt       count words in file.txt\n", NAME);
    printf("  %s < file.txt     count words from stdin\n", NAME);
    printf("  %s file1 file2    count words in multiple files\n", NAME);
}

void print_version() {
    printf("%s version %s\n", NAME, VERSION);
}
// test change
