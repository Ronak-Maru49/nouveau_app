# Nouveau App Backend

## Local MongoDB Development

Start a local MongoDB server before running the backend:

```sh
mongod
```

Create a local `.env` file in this `backend` directory using `.env.example` as a template:

```sh
MONGODB_URI=mongodb://localhost:27017/nouveau_app
PORT=5000

# Optional, only needed for automatic email delivery:
SMTP_HOST=
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=
SMTP_PASS=
SMTP_FROM=
```

Install dependencies and start the API:

```sh
npm install
npm run dev
```

The backend loads `MONGODB_URI` with `dotenv` and connects to MongoDB through Mongoose. Keep `.env` out of git and commit only `.env.example`.

Useful endpoints:

- `POST /api/auth/persons` saves or updates login/person records.
- `GET /api/products` lists products.
- `POST /api/orders` saves checkout orders and emails the owner/customer when SMTP is configured.
- `GET /api/orders` lists saved orders.
