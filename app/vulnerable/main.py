from flask import Flask, request

app = Flask(__name__)

@app.route('/')
def index():
    # Flask 3.x removed request.is_xhr, check X-Requested-With header instead
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return 'This was an AJAX request'
    return 'Status is OK!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)