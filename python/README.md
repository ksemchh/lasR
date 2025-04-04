# LASR Python Bindings

This directory contains Python bindings for the LASR library.

## Prerequisites

- Python 3.9 or higher
- CMake 3.18 or higher
- C++ compiler with C++17 support (gcc 7+, clang 5+, or MSVC 2017+)
- GDAL library and development headers

### Installing Prerequisites

#### Automated Setup (Linux, macOS)
We provide a simplified setup script that will install GDAL and other dependencies automatically:

```bash
cd python
chmod +x setup_env.sh
./setup_env.sh
```

This script will detect your OS, install GDAL and other required dependencies, and set up the environment for building the Python bindings.

#### Manual Installation

#### macOS
```bash
brew install gdal
pip install --upgrade pip wheel setuptools cmake pybind11
```

#### Ubuntu/Debian
```bash
sudo apt-get install libgdal-dev
pip install --upgrade pip wheel setuptools cmake pybind11
```

#### Windows
Install GDAL using OSGeo4W installer from https://trac.osgeo.org/osgeo4w/
```bash
pip install --upgrade pip wheel setuptools cmake pybind11
```

## Building and Installing the Python Bindings

After setting up the environment (either manually or using the setup script):

```bash
cd python
pip install -e .
```

This will build the extension module and install it in development mode, so any changes to the source code will be immediately reflected without needing to reinstall.

## Running the Examples

Once the module is installed, you can run the example directly:

```bash
cd python
python example.py advanced_pipeline.json
```

## API Reference

The Python bindings provide the following functions:

### Pipeline Processing

- **pylasr.process(config_file)** - Process a pipeline configuration file
  - Parameters:
    - `config_file` (str): Path to the JSON configuration file
  - Returns:
    - `bool`: True if processing was successful, False otherwise

- **pylasr.get_pipeline_info(config_file)** - Get information about a pipeline configuration
  - Parameters:
    - `config_file` (str): Path to the JSON configuration file
  - Returns:
    - `str`: JSON string containing pipeline information with the following properties:
      - `streamable`: Whether the pipeline can be processed in a stream
      - `read_points`: Whether the pipeline needs to read point data
      - `buffer`: Buffer size needed for processing in spatial units
      - `parallelizable`: Whether the pipeline can be parallelized
      - `parallelized`: Whether the pipeline uses parallelization internally
      - `R_API`: Whether the pipeline uses R API functionality

### System Information

- **pylasr.available_threads()** - Get the number of available threads
  - Returns:
    - `int`: Number of available threads

- **pylasr.has_omp_support()** - Check if OpenMP support is available
  - Returns:
    - `bool`: True if OpenMP support is available, False otherwise

- **pylasr.get_available_ram()** - Get the available RAM in bytes
  - Returns:
    - `int`: Available RAM in bytes

- **pylasr.get_total_ram()** - Get the total RAM in bytes
  - Returns:
    - `int`: Total RAM in bytes

## Usage Example

```python
import pylasr
import json

# Print system information
print(f"Available threads: {pylasr.available_threads()}")
print(f"Has OpenMP support: {pylasr.has_omp_support()}")
print(f"Available RAM: {pylasr.get_available_ram() / (1024**3):.2f} GB")
print(f"Total RAM: {pylasr.get_total_ram() / (1024**3):.2f} GB")

# Get pipeline information
config_file = "path/to/config.json"
info_json = pylasr.get_pipeline_info(config_file)
info = json.loads(info_json)
print(json.dumps(info, indent=2))

# Access specific pipeline properties
print(f"Pipeline is streamable: {info['streamable']}")
print(f"Pipeline needs buffer: {info['buffer']} units")
print(f"Pipeline can be parallelized: {info['parallelizable']}")

# Process the pipeline
result = pylasr.process(config_file)
print(f"Pipeline processing {'successful' if result else 'failed'}")
```

## Troubleshooting

If you encounter any build issues:

1. Make sure CMake is installed and in your PATH
2. Ensure you have a C++ compiler installed with C++17 support
3. Check that all required header files are available
4. Make sure you're using a compatible Python version

### Common Issues

- **C++17 compiler required**: This project needs a compiler supporting C++17 features (gcc 7+, clang 5+, or MSVC 2017+)
- **GDAL not found**: Ensure GDAL is properly installed with development headers. Set the `GDAL_DIR` environment variable to your GDAL installation directory.
- **Header files not found**: Make sure all the LASR header files are in the correct location
- **Linker errors**: You may need to add additional dependencies in CMakeLists.txt
- **CMake errors**: Check that your CMake version is compatible
- **Module not found**: If Python can't find the module, try using one of the methods described in the "Running the Examples" section

For more information, please refer to the main LASR documentation. 

## Command-line Usage

The Python module can also be used from the command line through a Python script. Create a script like this:

```python
#!/usr/bin/env python3
import sys
import pylasr

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <config_file.json>")
        sys.exit(1)
    
    result = pylasr.process(sys.argv[1])
    sys.exit(0 if result else 1)
```

Save this as `lasr_cli.py`, make it executable (`chmod +x lasr_cli.py`), and use it like:

```bash
./lasr_cli.py path/to/config.json
```

This provides a simple command-line interface to process LASR pipelines without having to write Python code. 