## Instructions
1. Install dependencies: `pip install -r requirements.txt`.
2. Run the server: `python main.py`.
   
## Make some changes
The application uses User as the default actor type and Organization as the default resource type. It extracts the actor ID from the username of BasicAuth and the resource ID from the path.

For example, if you visit `http://123:@localhost:8000/456`, the application will read `123` as the actor ID and `456` as the resource ID.

Update the actor and resource types to mirror your policy, and use actor IDs and resource IDs that apply to your use case.