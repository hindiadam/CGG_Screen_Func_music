using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cggSoundSpetc : MonoBehaviour
{
    public AudioSource audioSource;     // Ses kayna��
    public int resolution = 1920;        // Spectrum ��z�n�rl���
    public RenderTexture renderTexture; // RenderTexture hedefi
    private float[] spectrumData;       // Ses spektrumu verisi
    private Texture2D texture2D;        // Final texture
    public Material material;            // Shader malzemesi
    public float scaleFactor;
    void Start()
    {
        spectrumData = new float[resolution];

        texture2D = new Texture2D(resolution, 1, TextureFormat.RFloat, false);

        if (renderTexture == null)
        {
            renderTexture = new RenderTexture(resolution, 1, 0, RenderTextureFormat.RFloat);
            renderTexture.enableRandomWrite = true;
            renderTexture.Create();
        }
    }

    void Update()
    {
        audioSource.GetSpectrumData(spectrumData, 0, FFTWindow.BlackmanHarris);


        for (int i = 0; i < resolution; i++)
        {
            float value = spectrumData[i] * scaleFactor; // �l�eklendir
            value = Mathf.Clamp(value, 0f, 1f); // 0 ile 1 aras�nda s�n�rla
            texture2D.SetPixel(i, 0, new Color(value, 0, 0, 1));
        }

        texture2D.Apply();

        Graphics.Blit(texture2D, renderTexture);
        material.SetTexture("_MainTex", renderTexture);
    }
}
