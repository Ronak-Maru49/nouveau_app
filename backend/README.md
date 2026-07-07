# Nouveau App Backend

## Local MongoDB Development

Start a local MongoDB server before running the backend:

```sh
mongod
```

Create a local `.env` file in this `backend` directory using `.env.example` as a template:

```sh
MONGODB_URI=mongodb://localhost:27017/nouveau_app
```

Install dependencies and start the API:

```sh
npm install
npm run dev
```

The backend loads `MONGODB_URI` with `dotenv` and connects to MongoDB through Mongoose. Keep `.env` out of git and commit only `.env.example`.
