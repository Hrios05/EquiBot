from flask import Flask, request, jsonify
from google import genai

app = Flask(__name__)

API_KEY = "AIzaSyAQitp921uWBTx3quBxnCNCf_d7ooCpoYs"

def handle_user_query(user_input, address="California"):
    
    prompt = f"""You are an impact-driven chatbot for underserved communities in California. Be empathetic and provide direct, actionable advice.

User query: "{user_input}"
User location: California

GOAL: Help the user understand relevant California laws and connect with impactful organizations.

RESPONSE STRATEGY:

1. Identify the core need.
2. Identify 2-3 key California laws related to this need. Explain them briefly in plain language (2-3 sentences each).
3. Prioritize California-based non-profit organizations that offer direct assistance (legal aid, advocacy, etc.) for this issue.
4. For each organization, provide:
    * Name (hyperlinked)
    * A brief description of their services (1 sentence)
    * A direct call to action (e.g., "Visit their website to apply for legal help" or "Call their helpline at...")
5. Only include resources that directly serve underserved communities in California. Do not include federal resources unless absolutely necessary and clearly state that they are federal.
Here are some important California civil rights laws that might be relevant:
Example of a good response format:
"It sounds like you're having an issue with [user's issue]. Here are a couple of important California laws to know:
* [Law 1 Name]: [Simple explanation].
* [Law 2 Name]: [Simple explanation].
MAKE SURE THAT THE NAME OF THE ORGANIZATION NAME IS FOLLOWED IMMEDIATELY WITH HYPERLINKED
Here are some California organizations that can help:
* [[Organization A Name](link)] offers free legal aid for [issue]. Call them at [phone number].
* [[Organization B Name](link)] advocates for [issue] in California. Visit their website to learn more: [link]."
Only include disclaimer at the end of the response.
Also if it has something to do work do include contacting HR or telling a trusted individual.
Disclaimer: "I am an AI and cannot provide legal advice..."
KEEP EVERYTHING LESS THAN 250 WORDS.
Targeted Follow-Up: "To help me find the most relevant California-specific resources, could you tell me if your issue is related to [list of potential categories]?"
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
    user_address = request.json.get('address')
    response = handle_user_query(user_message, user_address)
    return jsonify({'response': response})

if __name__ == '__main__':
    app.run(debug=True)