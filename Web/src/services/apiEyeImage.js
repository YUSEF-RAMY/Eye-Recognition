export async function postEyeImage(formBody) {
  try {
    const res = await fetch(
      "https://katydid-champion-mutually.ngrok-free.app/api/recognize",
      {
        method: "POST",
        headers: {
          "User-Agent": "Mozilla/5.0",
          Authorization: `Bearer ${localStorage.getItem("token")}`,
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
