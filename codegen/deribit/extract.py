from codegen.deribit.consts import excluded_urls, matching_engine_endpoints
from codegen.deribit.request import request_table_to_type
from codegen.deribit.response import default_response_type, response_table_to_type
from codegen.utils.name_utils import url_to_type_name
from codegen.models.models import Endpoint, Function


def extract_function_from_section(sibling):
    file_name = '_'.join(sibling.text.split('/')[1:])

    # check if the url is excluded
    if file_name in excluded_urls:
        print(f'{file_name}: skipping due to {excluded_urls[file_name]}')
        return

    print(f'{file_name}: processing')

    parameters_section = sibling.find_next_sibling('h3', text='Parameters')
    request_type = None
    if parameters_section.nextSibling.nextSibling.text == 'This method takes no parameters':
        print('Method has no parameters')
    else:
        parameters_table = parameters_section.find_next_sibling('table')
        request_type = request_table_to_type(sibling.text, parameters_table)

    response_section = sibling.find_next_sibling('h3', text='Response')
    if response_section.nextSibling.nextSibling.text == 'This method has no response body':
        print('Method has no response body')
        root_type = default_response_type(sibling.text)
        response_type = None
        all_types = [root_type]
    else:
        response_table = response_section.find_next_sibling('table')
        root_type, response_type, all_types = response_table_to_type(sibling.text, response_table)

    rate_limiter = None
    if file_name in matching_engine_endpoints:
        rate_limiter = 'matching_engine_request_log_call'
    else:
        rate_limiter = 'non_matching_engine_request_log_call'

    comment = sibling.find_next_sibling('p')
    function = Function(name=url_to_type_name(sibling.text),
                        endpoint=Endpoint(
                            name=file_name,
                            path=sibling.text,
                            request_type=request_type,
                            response_type=root_type,
                            response_types=all_types,
                            rate_limiter=rate_limiter
                        ),
                        comment=comment.text,
                        response_type=response_type
                        )

    return function
