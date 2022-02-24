import unittest

from utils.get_files_and_directories import get_first_line_with_error

# rstcheck checks correct formatting for rst files
import rstcheck


def test_rst_integrity():
    error_line = get_first_line_with_error(["Cursos", "Nomadismo", "Libros"])
    assert error_line == []
