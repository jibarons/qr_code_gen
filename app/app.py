
import streamlit as st #...
from base64 import b64encode
import codecs
import json
import segno
import zlib
import io
import re

# Define fun for QR code
def set_qr(user, pwd, edit = True, project = "Project", icon = "P", color = "#ff0000"):
  settings = {
    "general": {
      "server_url": "https://kc.kobotoolbox.org",
      "protocol": "odk_default",
      "username": user,
      "password": pwd
    },
    "admin": {
      "edit_saved": edit
    },
    "project": {
      "name": project,
      "icon": icon,
      "color": color
    }
  }
  qr_data = b64encode(zlib.compress(json.dumps(settings).encode("utf-8")))
  code = segno.make(qr_data, micro=False)
  return code
  
st.set_page_config(layout="wide")
# Page Title
st.title("QR Code Generator")
st.subheader("QR codes for user set-up in ODK Collect App")

placeholder = st.empty()
with placeholder.container():

  credential, qr = st.columns(2) 

  with credential:
    # input parameter for QR code
    user = st.text_input("Enter username", placeholder = "Enter the username (e.g. 'myusername')")
    pwd = st.text_input("Enter password", type="password", placeholder = "Enter the ODK key")
    edit = st.checkbox("Will user edit the data?", value=True)
    project = st.text_input("Enter project name", value="My Project")
    icon = st.text_input("Enter icon (one letter) for the project", value="P")
    color = st.text_input("Enter color for the icon", value="#ff0000")
                          
  with qr:
    # Create 3 columsn to center image
    left, center, right = st.columns([1, 3, 1], gap="small") 
  
    with left:
      st.write("")

    with center:
      if st.button('Generate QR', ):
        # Set Project name as title for the QR
        html_title = f"""<h2 style='text-align: center; color: {color};'>{project}({icon})</h2>"""
        st.markdown(html_title, unsafe_allow_html=True)  
        # Create QR code and save image
        qr_code = set_qr(user, pwd, edit = edit, project = project, 
                        icon = icon, color = color)
        out = io.BytesIO()
        qr_code.save(out, kind='png', light=None, scale=7)
        # Output QR image
        st.image(out)
        # Output QR id to track changes
        qr_id = re.sub("^.+\sat\s(.+).$", "\\1", str(qr_code)) # shortened string
        html_id = f"""<h6 style='text-align: center;'>{qr_id}</h6>"""
        st.markdown(html_id, unsafe_allow_html=True) 
      else:
        st.write("")

    with right:
      st.write("")
