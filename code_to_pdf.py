import os
import nbformat
from fpdf import FPDF

# --- Configuration ---
# You can add or remove file extensions here
SUPPORTED_EXTENSIONS = ('.py', '.sh', '.ipynb')
CODE_FONT_SIZE = 10
LINE_HEIGHT = 5  # PDF line height for code

class PDF(FPDF):
    """
    Custom PDF class to add a header and footer for page numbers.
    """
    def header(self):
        # We don't want a header on every page, so we leave this blank.
        pass

    def footer(self):
        # Add a page number to the bottom
        self.set_y(-15)  # Position 1.5 cm from bottom
        self.set_font('Helvetica', 'I', 8)
        self.cell(0, 10, f'Page {self.page_no()}', 0, 0, 'C')

def safe_text(text):
    """
    Encodes text to 'latin-1' with replacements.
    This prevents fpdf from crashing on unsupported Unicode characters
    by replacing them with a '?'.
    """
    return text.encode('latin-1', 'replace').decode('latin-1')

def get_code_from_notebook(file_path):
    """
    Extracts and concatenates code from all code cells in a .ipynb file.
    """
    code = ""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            # Read the notebook using nbformat
            notebook = nbformat.read(f, as_version=nbformat.NO_CONVERT)
        
        code_cells = [cell['source'] for cell in notebook['cells'] if cell['cell_type'] == 'code']
        
        if not code_cells:
            return "# No code cells found in this notebook."
            
        for i, cell_source in enumerate(code_cells):
            code += f"# === Code Cell {i+1} ===\n"
            code += cell_source
            code += "\n\n# === End of Cell ===\n\n"
        
        return code
    except Exception as e:
        print(f"  [!] Error reading notebook {file_path}: {e}")
        return f"# Error reading notebook: {e}"

def get_code_from_text(file_path):
    """
    Reads code from a plain text file (.py, .sh, etc.).
    """
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            return f.read()
    except Exception as e:
        print(f"  [!] Error reading file {file_path}: {e}")
        return f"# Error reading file: {e}"

def create_code_pdf(root_dir, output_pdf_file):
    """
    Main function to walk directories and generate the PDF.
    """
    pdf = PDF('P', 'mm', 'A4')  # Portrait, millimeters, A4 size
    pdf.set_auto_page_break(True, margin=15)
    pdf.add_page()
    
    # Add a main title page
    pdf.set_font('Helvetica', 'B', 24)
    pdf.cell(0, 30, 'Project Code Compilation', 0, 1, 'C')
    pdf.set_font('Helvetica', '', 12)
    pdf.cell(0, 10, f'Source Directory: {os.path.abspath(root_dir)}', 0, 1, 'C')
    pdf.ln(20)

    current_section = None
    
    # We sort the directories and files to ensure a consistent, alphabetical order
    for root, dirs, files in os.walk(root_dir, topdown=True):
        dirs.sort()
        files.sort()
        
        rel_dir = os.path.relpath(root, root_dir)
        
        # --- Add a New Section for Each Subfolder ---
        if rel_dir != current_section:
            current_section = rel_dir
            section_name = "Root Directory" if rel_dir == "." else rel_dir.replace(os.path.sep, " > ")
            
            print(f"\nProcessing section: {section_name}")
            pdf.add_page()
            pdf.set_font('Helvetica', 'B', 20)
            pdf.cell(0, 15, f'Section: {section_name}', 0, 1, 'L')
            pdf.line(pdf.get_x(), pdf.get_y(), pdf.get_x() + 180, pdf.get_y())
            pdf.ln(10)
            
            files_found_in_section = False

        # --- Process each file in the folder ---
        for file in files:
            if file.endswith(SUPPORTED_EXTENSIONS):
                files_found_in_section = True
                file_path = os.path.join(root, file)
                print(f"  Adding file: {file}")
                
                # Add file title
                pdf.set_font('Helvetica', 'B', 14)
                pdf.cell(0, 10, f'File: {file}', 0, 1, 'L')
                pdf.ln(2)
                
                # Get code content
                if file.endswith('.ipynb'):
                    code_content = get_code_from_notebook(file_path)
                else:
                    code_content = get_code_from_text(file_path)
                
                # Add code content
                pdf.set_font('Courier', '', CODE_FONT_SIZE)
                # Use multi_cell for automatic wrapping and page breaks
                pdf.multi_cell(0, LINE_HEIGHT, safe_text(code_content))
                
                pdf.ln(10) # Add a 10mm space before the next file
        
        if not files_found_in_section:
            pdf.set_font('Helvetica', 'I', 12)
            pdf.cell(0, 10, 'No supported scripts found in this directory.', 0, 1, 'L')
            pdf.ln(5)

    # --- Save the PDF ---
    try:
        pdf.output(output_pdf_file)
        print(f"\n✅ Successfully generated PDF: {output_pdf_file}")
    except Exception as e:
        print(f"\n❌ Error saving PDF: {e}")

if __name__ == "__main__":
    print("--- Code-to-PDF Compiler ---")
    
    # Get user input for the directories
    # Note: You can hard-code these paths if you prefer.
    # example: root_directory = r"C:\Users\YourName\Projects\MyProject"
    # example: output_file = r"C:\Users\YourName\Desktop\MyProject_Code.pdf"
    
    root_directory = input("Enter the FULL path to your main code folder: ")
    output_file = input("Enter the FULL path for the output PDF (e.g., C:\\my_code.pdf): ")
    
    # Validate paths
    if not os.path.isdir(root_directory):
        print(f"Error: Directory not found: {root_directory}")
    elif not output_file.lower().endswith('.pdf'):
        print("Error: Output file name must end with .pdf")
    else:
        create_code_pdf(root_directory, output_file)