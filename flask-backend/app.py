
from flask import Flask, request, jsonify
from google import genai

app = Flask(__name__)

API_KEY = "AIzaSyAQitp921uWBTx3quBxnCNCf_d7ooCpoYs"

def handle_user_query(user_input):
    prompt = f"""You are a helpful legal chatbot assisting users from underrepresented communities in understanding their rights.

    User query: "{user_input}"

    Provide a brief, concise answer with key points related to the user's potential legal rights. If relevant, suggest specific resources or organizations where the user can learn more or seek further help.

    Prioritize information relevant to underrepresented communities who may face systemic barriers.

    Always state that you are an AI and cannot provide legal advice, and encourage the user to consult with a qualified attorney.

    Please keep everything brief and concisce and do not add too much information , do not let it become overwhelming. 

    Keep everything below 100 words and use bullet points. Make sure to point out what they should do in that situation and in 20 of those words give recources to what they can do.
    Add an extra sentence at the end asking a question to the user to keep the user going such as "Would you look more recources?"
    """

    try:
        client = genai.Client(api_key=API_KEY)
        response = client.models.generate_content(
            model="gemini-2.0-flash", contents=prompt
        )
        return response.text
    except Exception as e:
        return f"An error occurred while processing your request: {e}"

@app.route('/chatbot', methods=['POST'])
def chatbot():
    user_message = request.json.get('message')
    response = handle_user_query(user_message)
    return jsonify({'response': response})

if __name__ == '__main__':
    app.run(debug=True)