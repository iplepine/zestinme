import os
import numpy as np
from rembg import remove, new_session
from PIL import Image, ImageDraw

# 설정: 입력 폴더와 출력 폴더 이름
INPUT_DIR = 'input_images'
OUTPUT_DIR = 'output_images'

# 워터마크 제거 설정 (오른쪽 하단)
WATERMARK_RATIO = 0.15 # 이미지 크기의 약 15% 영역을 마스킹

# 세션 초기화 (isnet-general-use 모델 사용)
session = new_session("isnet-general-use")

def clean_gray_artifacts(image, tolerance=20, highlight_threshold=230):
    """
    이미지 내부의 회색 영역(낮은 채도)을 찾아 투명하게 만듭니다.
    식물(초록색/갈색)은 채도가 높으므로 영향을 덜 받습니다.
    
    tolerance: R, G, B 값의 차이가 이 값보다 작으면 회색으로 간주 (낮을수록 엄격)
    highlight_threshold: 이 값보다 밝은 픽셀(광택/반사광)은 회색이라도 지우지 않음 (보호)
    """
    # NumPy 배열로 변환
    img_array = np.array(image)
    
    # RGB 채널 분리
    r = img_array[:, :, 0].astype(int)
    g = img_array[:, :, 1].astype(int)
    b = img_array[:, :, 2].astype(int)
    a = img_array[:, :, 3]

    # 채도(Saturation) 근사 계산: Max(RGB) - Min(RGB)
    rgb_range = np.max(img_array[:, :, :3], axis=2) - np.min(img_array[:, :, :3], axis=2)
    
    # 밝기(Brightness) 평균
    brightness = np.mean(img_array[:, :, :3], axis=2)
    
    # 배경 제거 조건 (Mask):
    # 1. 불투명한 픽셀 중 (a > 0)
    # 2. 채도가 매우 낮고 (회색 계열) (rgb_range < tolerance)
    # 3. 너무 어둡지 않아야 함 (그림자/줄기 보호) (brightness > 60)
    # 4. [NEW] 너무 밝지 않아야 함 (잎의 광택/반사광 보호) (brightness < highlight_threshold)
    gray_mask = (a > 0) & (rgb_range < tolerance) & (brightness > 60) & (brightness < highlight_threshold)
    
    # 해당 픽셀의 Alpha를 0으로 설정
    img_array[gray_mask, 3] = 0
    
    return Image.fromarray(img_array)

def clean_blue_screen(image, threshold=50):
    """
    크로마키 블루(#0000FF 계열) 영역을 강력하게 제거합니다.
    식물(초록색)과 색상 대비가 확실하여 오검출 확률이 가장 낮습니다.
    """
    img_array = np.array(image)
    
    # RGB 채널 분리
    r = img_array[:, :, 0].astype(int)
    g = img_array[:, :, 1].astype(int)
    b = img_array[:, :, 2].astype(int)
    a = img_array[:, :, 3]
    
    # 크로마키 블루 조건:
    # 1. B가 R보다 월등히 커야 함
    # 2. B가 G보다 월등히 커야 함
    # 3. B가 일정 밝기 이상이어야 함
    
    blue_mask = (a > 0) & (b > r + threshold) & (b > g + threshold) & (b > 100)
    
    # 해당 픽셀 투명화
    img_array[blue_mask, 3] = 0
    
    return Image.fromarray(img_array)

# [NEW] 이미지 처리 설정
TIGHT_CROP = True        # True: 식물 영역에 딱 맞게 저장, False: 1024x1024 캔버스 사용
USE_BOTTOM_ALIGN = True  # False일 경우 중앙 정렬 (캔버스 사용 시에만 적용)
CANVAS_SAFE_RATIO = 0.95 # 캔버스 대비 이미지 크기 비율 (기존 0.90)

def remove_backgrounds():
    # 출력 폴더가 없으면 생성
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    # 입력 폴더의 파일들을 순회
    if not os.path.exists(INPUT_DIR):
         os.makedirs(INPUT_DIR)
         print(f"'{INPUT_DIR}' 폴더가 생성되었습니다. 이미지를 넣고 다시 실행해주세요.")
         return

    files = [f for f in os.listdir(INPUT_DIR) if f.lower().endswith(('.png', '.jpg', '.jpeg', '.webp'))]
    
    if not files:
        print(f"'{INPUT_DIR}' 폴더에 처리할 이미지 파일이 없습니다.")
        return

    print(f"총 {len(files)}개의 파일을 처리합니다...")

    for filename in files:
        input_path = os.path.join(INPUT_DIR, filename)
        output_path = os.path.join(OUTPUT_DIR, filename.split('.')[0] + ".png")

        print(f"처리 중 (Smart Cleanup + Blue Filter + Crop Optimization): {filename}")

        try:
            # 1. 이미지 열기
            input_image = Image.open(input_path).convert("RGBA")
            
            # 2. 배경 제거 수행
            no_bg_image = remove(input_image, session=session)
            
            # 3. [Step 1] 내부 회색 잔여물 후처리 제거
            clean_image_1 = clean_gray_artifacts(no_bg_image, tolerance=10, highlight_threshold=150)

            # 4. [Step 2] 크로마키 블루 제거
            clean_image = clean_blue_screen(clean_image_1, threshold=50)

            # 5. 워터마크 영역 강제 삭제 (투명화)
            w, h = clean_image.size
            mask_size = int(min(w, h) * WATERMARK_RATIO)
            
            draw = ImageDraw.Draw(clean_image)
            draw.rectangle(
                [(w - mask_size, h - mask_size), (w, h)], 
                fill=(0, 0, 0, 0) 
            )

            # 6. [Step 3] 알파 임계값 적용 (미세 잔여물 제거) 및 크롭
            # 눈에 보이지 않는 흐릿한 픽셀(Alpha < 20)을 제거하여 bbox가 타이트하게 잡히도록 함
            img_array = np.array(clean_image)
            img_array[:, :, 3] = np.where(img_array[:, :, 3] < 20, 0, img_array[:, :, 3])
            clean_image = Image.fromarray(img_array)

            # 7. 투명한 여백 제거 (Cropping) 및 리사이징
            bbox = clean_image.getbbox()
            
            if bbox:
                # 타이트하게 크롭된 클린 이미지
                cropped_plant = clean_image.crop(bbox)
                
                if TIGHT_CROP:
                    # 옵션 1: 식물 영역에 딱 맞게 저장
                    cropped_plant.save(output_path)
                    print(f"완료 (Tight Crop): {output_path}")
                else:
                    # 옵션 2: 1024x1024 캔버스에 배치
                    target_size = (1024, 1024)
                    final_canvas = Image.new("RGBA", target_size, (0, 0, 0, 0))
                    
                    # 캔버스 크기에 맞춘 리사이즈 (LANCZOS 품질 우선)
                    max_dim = int(1024 * CANVAS_SAFE_RATIO)
                    cropped_plant.thumbnail((max_dim, max_dim), Image.Resampling.LANCZOS)
                    
                    if USE_BOTTOM_ALIGN:
                        # 하단 중앙 정렬 (Pot가 바닥에 붙도록)
                        offset = (
                            (target_size[0] - cropped_plant.width) // 2,
                            (target_size[1] - cropped_plant.height) # y=최하단
                        )
                    else:
                        # 정중앙 정렬
                        offset = (
                            (target_size[0] - cropped_plant.width) // 2,
                            (target_size[1] - cropped_plant.height) // 2
                        )
                    
                    final_canvas.paste(cropped_plant, offset)
                    final_canvas.save(output_path)
                    print(f"완료 (Canvas Refined): {output_path}")
            else:
                clean_image.save(output_path)
                print(f"완료 (빈 이미지): {output_path}")
        except Exception as e:
            print(f"에러 발생 ({filename}): {e}")

if __name__ == "__main__":
    remove_backgrounds()
