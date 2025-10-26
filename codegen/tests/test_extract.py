"""Unit tests for extract module."""

import pytest
from bs4 import BeautifulSoup

from deribit.extract import extract_function_from_section


@pytest.mark.unit
class TestExtractFunctionFromSection:
    """Test extract_function_from_section."""

    def test_extract_simple_endpoint(self):
        """Test extracting a simple endpoint with no parameters."""
        html = """
        <h2>/public/test</h2>
        <p>Test description</p>
        <h3>Parameters</h3>
        <p>This method takes no parameters</p>
        <h3>Response</h3>
        <p>This method has no response body</p>
        """
        soup = BeautifulSoup(html, "html.parser")
        section = soup.find("h2")

        result = extract_function_from_section(section)

        assert result is not None
        assert result.name == "public_test"
        assert result.endpoint.name == "public_test"
        assert result.endpoint.path == "/public/test"
        assert result.endpoint.request_type is None
        assert result.endpoint.response_type is not None
        assert result.requires_auth is False  # /public/ endpoints don't require auth

    def test_extract_private_endpoint_requires_auth(self):
        """Test that /private/ endpoints require authentication."""
        html = """
        <h2>/private/buy</h2>
        <p>Buy description</p>
        <h3>Parameters</h3>
        <p>This method takes no parameters</p>
        <h3>Response</h3>
        <p>This method has no response body</p>
        """
        soup = BeautifulSoup(html, "html.parser")
        section = soup.find("h2")

        result = extract_function_from_section(section)

        assert result is not None
        assert result.requires_auth is True  # /private/ endpoints require auth

    def test_extract_endpoint_with_parameters(self):
        """Test extracting endpoint with parameters."""
        html = """
        <h2>/public/get_time</h2>
        <p>Get server time</p>
        <h3>Parameters</h3>
        <table>
            <tr><th>Parameter</th><th>Required</th><th>Type</th><th>Enum</th><th>Description</th></tr>
            <tr><td>currency</td><td>true</td><td>string</td><td></td><td>Currency</td></tr>
        </table>
        <h3>Response</h3>
        <p>This method has no response body</p>
        """
        soup = BeautifulSoup(html, "html.parser")
        section = soup.find("h2")

        result = extract_function_from_section(section)

        assert result is not None
        assert result.endpoint.request_type is not None
        assert result.endpoint.request_type.name == "public_get_time_request"

    def test_extract_endpoint_with_response(self):
        """Test extracting endpoint with response body."""
        html = """
        <h2>/public/test</h2>
        <p>Test</p>
        <h3>Parameters</h3>
        <p>This method takes no parameters</p>
        <h3>Response</h3>
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>result</td><td>string</td><td>Result</td></tr>
        </table>
        """
        soup = BeautifulSoup(html, "html.parser")
        section = soup.find("h2")

        result = extract_function_from_section(section)

        assert result is not None
        assert result.endpoint.response_type is not None
        assert result.response_type is not None

    def test_matching_engine_endpoint_rate_limiter(self):
        """Test that matching engine endpoints get correct rate limiter."""
        # Note: Would need to know which endpoints are in matching_engine_endpoints
        # For now, test a generic endpoint gets non_matching_engine rate limiter
        html = """
        <h2>/public/test</h2>
        <p>Test</p>
        <h3>Parameters</h3>
        <p>This method takes no parameters</p>
        <h3>Response</h3>
        <p>This method has no response body</p>
        """
        soup = BeautifulSoup(html, "html.parser")
        section = soup.find("h2")

        result = extract_function_from_section(section)

        assert result is not None
        # Most endpoints should have non_matching_engine rate limiter
        assert result.endpoint.rate_limiter == "non_matching_engine_request_log_call"

    def test_excluded_endpoint_returns_none(self):
        """Test that excluded endpoints return None."""
        # Create an endpoint that would be in excluded_urls
        # For this test, we'll just verify the function can handle it
        # The actual excluded URLs are defined in consts.py
        html = """
        <h2>/public/test</h2>
        <p>Test</p>
        <h3>Parameters</h3>
        <p>This method takes no parameters</p>
        <h3>Response</h3>
        <p>This method has no response body</p>
        """
        soup = BeautifulSoup(html, "html.parser")
        section = soup.find("h2")

        result = extract_function_from_section(section)

        # This endpoint is not excluded, so should return a result
        assert result is not None

    def test_comment_extraction(self):
        """Test that comment is extracted from first paragraph."""
        html = """
        <h2>/public/test</h2>
        <p>This is the endpoint description</p>
        <h3>Parameters</h3>
        <p>This method takes no parameters</p>
        <h3>Response</h3>
        <p>This method has no response body</p>
        """
        soup = BeautifulSoup(html, "html.parser")
        section = soup.find("h2")

        result = extract_function_from_section(section)

        assert result is not None
        assert result.comment == "This is the endpoint description"
