import functions_framework
import requests

@functions_framework.http
def hello_http(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    """
    is_valid_form = request.get_data(as_text=True,parse_form_data=True)
    if is_valid_form != '':
        return "Something is wrong with form data", 500
    error_messages = validateData(request)
    if len(error_messages) > 0:
        return '\n'.join(error_messages), 500
    start_time = request.form['sdate']
    end_time = request.form['edate']
    files = get_subset_files(start_time, end_time)
    outfiles = []
    for _file in files:
        outfiles.append(subset(_file))
    return str(outfiles)

def validateData(request):
    messages = []
    slat = float(request.form['slat'])
    nlat = float(request.form['nlat'])
    elon = float(request.form['elon'])
    wlon = float(request.form['wlon'])
    if slat < -90 or slat > 90:
        messages.append('slat out of range')
    if nlat < -90 or nlat > 90:
        messages.append('nlat out of range')
    if wlon < -180 or wlon > 360:
        messages.append('wlon out of range')
    if elon < -180 or elon > 360:
        messages.append('elon out of range')
    return messages

def get_subset_files(start_time, end_time):

    return []

def subset(in_file):
    return "temp"
