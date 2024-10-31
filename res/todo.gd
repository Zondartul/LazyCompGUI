extends Node

# Todo for the LazyCompGUI: a compiler-explorer
#  that shows compiler's intermediate data representations
#
# v [todo-done] edit scripts with syntax highlighting
# [todo] input token data from file
# [todo] call into compiler via shell
# [todo] call into compiler via library
# [todo] input token data from library calls
# [todo] cross-view selection of words
# [todo] mouseover info for tokens, words, etc
#

# Thanks to ChatGPT for some suggestions:
#Here are some suggested features for each view in your GUI program that would be useful to a programming language developer:
#
#1. Editor for Source-Code Editing (view_editor)
#	Syntax Highlighting: Support for highlighting keywords, comments, strings, etc., to improve readability.
#	Auto-Completion: Provide suggestions for code completion based on context and existing code.
#	Error Detection: Real-time feedback on syntax errors with line numbers and descriptions.
#	Code Folding: Allow users to collapse and expand code blocks for easier navigation.
#	Version Control Integration: Basic features for saving and tracking code changes, perhaps with Git support.
#
#2. View of Pre-Processed Text (view_preproc)
#	Highlighting Preprocessor Directives: Differentiate between #include, #define, and regular code.
#	Macro Expansion Display: Show how macros are expanded in the pre-processed output.
#	Dependency Graph: Visualize dependencies introduced by includes and defines.
#	Search Functionality: Quick search to locate specific directives or included files.
#
#3. View of Tokenized Code (view_tokens)
#	Token Classification: Color-code tokens based on their type (keywords, identifiers, literals, etc.).
#	Token Details: Display detailed information about each token, such as line number and position.
#	Highlight Errors: Show tokens that caused errors during tokenization with explanations.
#	Filter Options: Allow users to filter tokens by type or value.
#
#4. View of Abstract Syntax Tree (AST) (view_parse)
#	Tree Visualization: A graphical representation of the AST, allowing users to expand/collapse nodes.
#	Node Details: Clicking on a node provides detailed information about its type and associated code.
#	Error Highlighting: Indicate any issues found during parsing directly in the tree.
#	Export Functionality: Option to export the AST to a file for further analysis.
#
#5. View of Semantic Information (view_semantic)
#	Symbol Table Display: Show a detailed symbol table with scopes, types, and memory locations.
#	Scope Navigation: Easily navigate between different scopes and view their associated symbols.
#	Type Checking Results: Highlight any type errors found during semantic analysis.
#	Cross-Referencing: Ability to click on a symbol and see its references and definitions.
#
#6. View of Intermediate Representation (IR) (view_ir)
#	IR Optimization Steps: Display optimization phases that the IR undergoes.
#	Instruction Highlighting: Color-code different types of IR instructions (e.g., arithmetic, control flow).
#	Comparison to Source Code: Show a side-by-side comparison of the source code and IR.
#	Export IR: Option to export the IR to a file for review or further processing.
#
#7. View of Code-Generator Blocks (view_codegen)
#	Symbol and Block Overview: Display a list of symbols and their corresponding code generation blocks.
#	Memory Layout Visualization: Show how variables are allocated in memory.
#	Error Reporting: Highlight issues encountered during code generation with details.
#	Step-by-Step Code Generation View: Allow users to step through the code generation process interactively.
#
#8. View of Final Assembly Code (view_asm)
#	Instruction Set Details: Provide information about the assembly instructions used (e.g., opcode descriptions).
#	Linking Information: Show how different assembly files link together.
#	Performance Analysis: Highlight hotspots or inefficient code sections based on assembly.
#	View in Different Formats: Allow users to switch between different assembly formats (e.g., AT&T vs. Intel syntax).
#
#9. View of Execution Result (view_exec)
#	Real-Time Output Streaming: Display output as it is generated, allowing for real-time feedback.
#	Error Logs: Capture and display runtime errors with stack traces.
#	Input Simulation: Provide a way to simulate input to the program during execution.
#	Performance Metrics: Display execution time, memory usage, and other performance statistics.
#	Implementing these features can significantly enhance the usability and functionality of your GUI program for exploring compiler internals, making it a valuable tool for programming language developers.
