from io import BytesIO
from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from minio import Minio
import random, string

app = FastAPI()
templates = Jinja2Templates(directory='templates')

client = Minio(
        "127.0.0.1:9000",
        access_key="QDxQNk311LLEzGvF",
        secret_key="mYwL3SBDSAwwG4FkUd2XhTwtXNchncL4",
        secure=False
    )

@app.get("/view/{obj_name}")
async def view_text(obj_name: str, request: Request):
    obj_url="http://"+request.headers.get('Host')+"/view/"+obj_name

    try:
        obj = client.get_object("paste", obj_name)
        return templates.TemplateResponse('view.html', {'request': request, 'obj_data': str(obj.data, 'UTF-8'), 'obj_url': obj_url })
    # Read data from response.
    finally:
        obj.close()
        obj.release_conn()



@app.post("/upload/")
async def upload_text(request: Request , data: str = Form()):
    characters = string.ascii_letters + string.digits 
    obj_name = ''.join(random.choice(characters) for i in range(12))
    obj = BytesIO(str.encode(data))
    client.put_object(
    "paste", obj_name, obj , length=-1, part_size=10*1024*1024, content_type="text/plain",

    )  
    redirect_url = request.url_for('view_text', **{'obj_name': obj_name})
    return RedirectResponse(redirect_url, status_code=303)

@app.get('/', response_class=HTMLResponse)
def main(request: Request):
    return templates.TemplateResponse('index.html', {'request': request})
