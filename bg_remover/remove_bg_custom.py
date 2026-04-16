import os
import numpy as np
from rembg import remove, new_session
from PIL import Image, ImageDraw

# 설정: 입력 폴더와 출력 폴더 이름
INPUT_DIR = 'input_images'
OUTPUT_DIR = 'output_images'

# 워터마크 제거 설정 (오른쪽 하단)
WATERMARK_RATIO = 0.0 # 0.15 -> 0.0 (비활성화)

# 세션 초기화 (isnet-general-use 모델 사용)
# 세션 초기화 (isnet-general-use 모델 사용 - 세부 디테일 및 일반 사물에 강함)
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

def clean_green_screen(image):
    """
    HSV 색상 공간을 사용하여 녹색(#00FF00 근처) 영역을 찾아
    [반투명한 갈색]으로 변환합니다.
    Alpha 채널을 보존하여 고스트 현상을 방지하고, Hue 범위를 확장하여 녹색 감지율을 높입니다.
    """
    # RGB 변환 (HSV 변환 전용)
    # 원본 이미지의 Alpha 채널 분리
    r, g, b, a = image.split()
    np_a = np.array(a)

    # HSV로 변환
    hsv_image = image.convert('HSV')
    h, s, v = hsv_image.split()

    np_h = np.array(h)
    np_s = np.array(s)
    np_v = np.array(v)

    # PIL Hue 범위: 0-255
    # 녹색 범위 확장 (45 ~ 135) -> Cyan(127)과 Yellow-Green(42) 사이를 넉넉하게 커버
    lower_h = 45
    upper_h = 135


    # 녹색이면서 유의미한 픽셀 마스크 생성
    # Saturation > 10, Value > 20 (더 어둡고 흐린 녹색도 감지)
    green_mask = (np_a > 0) & \
                 (np_h >= lower_h) & (np_h <= upper_h) & \
                 (np_s > 10) & (np_v > 20)

    # 마스크 영역을 [투명]하게 변경 (Revert to Transparency)
    img_array = np.array(image)

    # 해당 픽셀의 Alpha를 0으로 설정
    img_array[green_mask, 3] = 0

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

        print(f"처리 중 (Smart Cleanup + Blue/Green Filter + Crop Optimization): {filename}")

        try:
            # 1. 이미지 열기
            input_image = Image.open(input_path).convert("RGBA")

            # 2. 배경 제거 수행 (Alpha Matting 활성화)
            no_bg_image = remove(
                input_image,
                session=session,
                alpha_matting=True,
                alpha_matting_foreground_threshold=240,
                alpha_matting_background_threshold=20, # 10 -> 20 (조금 더 공격적으로 배경 제거)
                alpha_matting_erode_size=15 # [NEW] 엣지 부드럽게
            )

            # 3. [Step 1] 내부 회색 잔여물 후처리 제거
            # clean_image_1 = clean_gray_artifacts(no_bg_image, tolerance=10, highlight_threshold=150)
            clean_image_1 = no_bg_image # Pass-through

            # 4. [Step 2] 크로마키 블루 제거
            # clean_image = clean_blue_screen(clean_image_1, threshold=50)
            clean_image_2 = clean_image_1 # Pass-through

            # 4-2. [Step 2-1] 크로마키 그린 제거 [NEW]
            clean_image = clean_green_screen(clean_image_2) # threshold removed

            # 5. 워터마크 영역 강제 삭제 (투명화)
            # w, h = clean_image.size
            # mask_size = int(min(w, h) * WATERMARK_RATIO)

            # draw = ImageDraw.Draw(clean_image)
            # draw.rectangle(
            #     [(w - mask_size, h - mask_size), (w, h)],
            #     fill=(0, 0, 0, 0)
            # )

            # 6. [Step 3] 알파 임계값 적용 (미세 잔여물 제거) 및 크롭
            # 눈에 보이지 않는 흐릿한 픽셀(Alpha < 20)을 제거하여 bbox가 타이트하게 잡히도록 함
            img_array = np.array(clean_image)
            # img_array[:, :, 3] = np.where(img_array[:, :, 3] < 20, 0, img_array[:, :, 3]) # 비활성화 (연한 부분 보존)
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
