#include <stdio.h>
#include <stdlib.h>
//#include <tchar.h>
#include <memory.h>
#include <math.h>

typedef struct
{
	int width, height;
	unsigned char* pImg;
	int cX, cY;
	int col;
} imgInfo;

typedef struct
{
	int left, top, right, bottom;
} Rect;

typedef struct
{
	int x, y;
} Point;

typedef struct
{
	unsigned short bfType; 
	unsigned long  bfSize; 
	unsigned short bfReserved1; 
	unsigned short bfReserved2; 
	unsigned long  bfOffBits; 
	unsigned long  biSize; 
	long  biWidth; 
	long  biHeight; 
	short biPlanes; 
	short biBitCount; 
	unsigned long  biCompression; 
	unsigned long  biSizeImage; 
	long biXPelsPerMeter; 
	long biYPelsPerMeter; 
	unsigned long  biClrUsed; 
	unsigned long  biClrImportant;
	unsigned long  RGBQuad_0;
	unsigned long  RGBQuad_1;
} bmpHdr;

void* freeResources(FILE* pFile, void* pFirst, void* pSnd)
{
	if (pFile != 0)
		fclose(pFile);
	if (pFirst != 0)
		free(pFirst);
	if (pSnd !=0)
		free(pSnd);
	return 0;
}

imgInfo* readBMP(const char* fname)
{
	imgInfo* pInfo = 0;
	FILE* fbmp = 0;
	bmpHdr bmpHead;
	int lineBytes, y;
	unsigned char* ptr;

	pInfo = 0;
	fbmp = fopen(fname, "rb");
	if (fbmp == 0)
		return 0;


	fread((void *) &bmpHead, sizeof(bmpHead), 1, fbmp);
	// parê sprawdzeñ
	if (bmpHead.bfType != 0x4D42 || bmpHead.biPlanes != 1 ||
		bmpHead.biBitCount != 1 || bmpHead.biClrUsed != 2 ||
		(pInfo = (imgInfo *) malloc(sizeof(imgInfo))) == 0)
		return (imgInfo*) freeResources(fbmp, pInfo->pImg, pInfo);

	pInfo->width = bmpHead.biWidth;
	pInfo->height = bmpHead.biHeight;
	if ((pInfo->pImg = (unsigned char*) malloc(bmpHead.biSizeImage)) == 0)
		return (imgInfo*) freeResources(fbmp, pInfo->pImg, pInfo);

	// porz¹dki z wysokoœci¹ (mo¿e byæ ujemna)
	ptr = pInfo->pImg;
	lineBytes = ((pInfo->width + 31) >> 5) << 2; // rozmiar linii w bajtach
	if (pInfo->height > 0)
	{
		// "do góry nogami", na pocz¹tku dó³ obrazu
		ptr += lineBytes * (pInfo->height - 1);
		lineBytes = -lineBytes;
	}
	else
		pInfo->height = -pInfo->height;

	// sekwencja odczytu obrazu 
	// przesuniêcie na stosown¹ pozycjê w pliku
	if (fseek(fbmp, bmpHead.bfOffBits, SEEK_SET) != 0)
		return (imgInfo*) freeResources(fbmp, pInfo->pImg, pInfo);

	for (y=0; y<pInfo->height; ++y)
	{
		fread(ptr, 1, abs(lineBytes), fbmp);
		ptr += lineBytes;
	}
	fclose(fbmp);
	return pInfo;
}

int saveBMP(const imgInfo* pInfo, const char* fname)
{
	int lineBytes = ((pInfo->width + 31) >> 5)<<2;
	bmpHdr bmpHead = 
	{
	0x4D42,				// unsigned short bfType; 
	sizeof(bmpHdr),		// unsigned long  bfSize; 
	0, 0,				// unsigned short bfReserved1, bfReserved2; 
	sizeof(bmpHdr),		// unsigned long  bfOffBits; 
	40,					// unsigned long  biSize; 
	pInfo->width,		// long  biWidth; 
	pInfo->height,		// long  biHeight; 
	1,					// short biPlanes; 
	1,					// short biBitCount; 
	0,					// unsigned long  biCompression; 
	lineBytes * pInfo->height,	// unsigned long  biSizeImage; 
	11811,				// long biXPelsPerMeter; = 300 dpi
	11811,				// long biYPelsPerMeter; 
	2,					// unsigned long  biClrUsed; 
	0,					// unsigned long  biClrImportant;
	0x00000000,			// unsigned long  RGBQuad_0;
	0x00FFFFFF			// unsigned long  RGBQuad_1;
	};

	FILE * fbmp;
	unsigned char *ptr;
	int y;

	if ((fbmp = fopen(fname, "wb")) == 0)
		return -1;
	if (fwrite(&bmpHead, sizeof(bmpHdr), 1, fbmp) != 1)
	{\
		fclose(fbmp);
		return -2;
	}

	ptr = pInfo->pImg + lineBytes * (pInfo->height - 1);
	for (y=pInfo->height; y > 0; --y, ptr -= lineBytes)
		if (fwrite(ptr, sizeof(unsigned char), lineBytes, fbmp) != lineBytes)
		{
			fclose(fbmp);
			return -3;
		}
	fclose(fbmp);
	return 0;
}

extern "C" imgInfo* copyrect(imgInfo* pImg, Rect* pSrc, Point* pDest);

/****************************************************************************************/
imgInfo* InitScreen (int w, int h)
{
	imgInfo *pImg;
	if ( (pImg = (imgInfo *) malloc(sizeof(imgInfo))) == 0)
		return 0;
	pImg->height = h;
	pImg->width = w;
	pImg->pImg = (unsigned char*) malloc((((w + 31) >> 5) << 2) * h);
	if (pImg->pImg == 0)
	{
		free(pImg);
		return 0;
	}
	memset(pImg->pImg, 0xFF, (((w + 31) >> 5) << 2) * h);
	pImg->cX = 0;
	pImg->cY = 0;
	pImg->col = 0;
	return pImg;
}

void FreeScreen(imgInfo* pInfo)
{
	if (pInfo && pInfo->pImg)
		free(pInfo->pImg);
	if (pInfo)
		free(pInfo);
}

imgInfo* SetColor(imgInfo* pImg, int col)
{
	pImg->col = col != 0;
	return pImg;
}

imgInfo* MoveTo(imgInfo* pImg, int x, int y)
{
	if (x >= 0 && x < pImg->width)
		pImg->cX = x;
	if (y >= 0 && y < pImg->height)
		pImg->cY = y;
	return pImg;
}

void SetPixel(imgInfo* pImg, int x, int y)
{
	unsigned char *pPix = pImg->pImg + (((pImg->width + 31) >> 5) << 2) * y + (x >> 3);
	unsigned char mask = 0x80 >> (x & 0x07);

	if (x < 0 || x >= pImg->width || y < 0 || y >= pImg->height)
		return;

	if (pImg->col)
		*pPix |= mask;
	else
		*pPix &= ~mask;
}

int GetPixel(imgInfo* pImg, int x, int y)
{
	unsigned char *pPix = pImg->pImg + (((pImg->width + 31) >> 5) << 2) * y + (x >> 3);
	unsigned char mask = 0x80 >> (x & 0x07);

	if (x < 0 || x >= pImg->width || y < 0 || y >= pImg->height)
		return 0;

	return *pPix & mask; 
}

imgInfo* CopyRect(imgInfo* pImg, Rect* pSrc, Point* pDst)
{
	// najpierw trzeba posprawdzaæ, czy prostok¹ty Ÿród³owy i docelowy
	// nie maj¹ czêœci wspólnych (istotnych z punktu widzenia kolejnoœci 
	// kopiowania punktów) - warto sobie to rozrysowaæ na karteczce i przemyœleæ!
	// brak sprawdzenia w poni¿szym kodzie mo¿e prowadziæ do nieoczekiwanych wyników
	int i,j;
	for (i=pSrc->top; i < pSrc->bottom; ++i)
		for (j=pSrc->left; j < pSrc->right; ++j)
		{
			int c = GetPixel(pImg, j, i);
			SetColor(pImg, c);
			SetPixel(pImg, pDst->x + (j-pSrc->left), pDst->y + (i-pSrc->top));
		}
	return pImg;
}

/****************************************************************************************/

int main(int argc, char* argv[]){

 printf("%s", "MAIN START\n");

	imgInfo* pInfo;
	int i, j;
	//Rect r = { 0, 0, 6, 6 };
	Rect r = { 200, 211, 457, 322};
	Point pt;

	if (sizeof(bmpHdr) != 62)
	{
	printf("Trzeba zmieniæ opcje kompilacji, tak by rozmiar struktury bmpHdr wynosi³ 62 bajty.\n");
		return 1;
	}
	/*
	if ((pInfo = InitScreen (512, 512)) == 0)
		return 2;

	SetColor(pInfo, 0);
	for (i=0; i<7; ++i){
		for (j = 0; j < 7; ++j){
			if ((i + j) % 3 == 0)
				SetPixel(pInfo, i, j);
		
	 	}
	saveBMP(pInfo, "start.bmp");
	*/
	pInfo = readBMP("start.bmp");
	
 printf("%s", "COPYRECT START\n");
	
	/*//WERSJA C//
	 r.bottom = r.right = 3;
	for (i = 1; i < 8; ++i)
	 {
		 r.bottom *= 2;
		 r.right *= 2;
		 pt.x = r.bottom;
		 pt.y = 0;
	printf("r: %d:%d\n", r.bottom, r.right);
printf("p: %d:%d\n", pt.x, pt.y);
		 CopyRect(pInfo, &r, &pt);
		 pt.y = pt.x;
		 CopyRect(pInfo, &r, &pt);
		 pt.x = 0;
		 CopyRect(pInfo, &r, &pt);
	 }*/


	/* //WERSJA ASEMBLER//
	 r.bottom = r.right = 3;
	pt.y=0;
	 for (i = 1; i < 8; ++i)
	 {
		r.bottom *= 2;
		r.right *= 2;
		pt.x = r.bottom;
		pt.y = 0;
		copyrect(pInfo, &r, &pt);
		pt.y = pt.x;
		copyrect(pInfo, &r, &pt);
		pt.x = 0;
		copyrect(pInfo, &r, &pt);
			
	
	}*/
	
	pt.x=100;
	pt.y=300;

	//CopyRect(pInfo, &r, &pt);
	copyrect(pInfo, &r, &pt);

 printf("%s", "COPYRECT STOP\n");

	saveBMP(pInfo, "result.bmp");
	FreeScreen(pInfo);

 printf("%s", "MAIN STOP\n");

	return 0;
}
