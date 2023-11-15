import os
import time

import pytest
from starlette.testclient import TestClient

from api.main import app


@pytest.mark.unit
def test_sanity():
    assert 1 != 0


@pytest.mark.integration
def test_api():
    time.sleep(1)
    client = TestClient(app)
