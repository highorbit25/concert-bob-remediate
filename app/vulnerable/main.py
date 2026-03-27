from flask import Flask, request

app = Flask(__name__)

@app.route('/')
def index():
    if request.is_xhr:
        return 'This was an AJAX request'
    return 'Status is OK!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)