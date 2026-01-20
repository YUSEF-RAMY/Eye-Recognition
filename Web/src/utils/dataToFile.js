export const dataURItoFile = (dataURI, fileName) => {
  const [meta, base64] = dataURI.split(",");
  const mime = meta.match(/:(.*?);/)[1];
  const binary = atob(base64);
  const array = new Uint8Array(binary.length);

  for (let i = 0; i < binary.length; i++) {
    array[i] = binary.charCodeAt(i);
  }

  return new File([array], fileName, { type: mime });
};
