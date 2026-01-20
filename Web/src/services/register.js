export async function register(
  name,
  email,
  image,
  password,
  password_confirmation
) {
  const formBody = new FormData();
  formBody.append("name", name);
  formBody.append("email", email);
  formBody.append("password", password);
  formBody.append("password_confirmation", password_confirmation);
  formBody.append("image", image);

  try {
    const res = await fetch(
      "https://katydid-champion-mutually.ngrok-free.app/api/register",
      {
        method: "POST",
        headers: {
          "User-Agent": "Mozilla/5.0",
        },
        body: formBody,
      }
    );

    const data = await res.json();
    console.log(res);
    console.log(data);

    return data;
  } catch (error) {
    console.log(error);
  }
}
