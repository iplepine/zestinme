
import os
from rembg import remove
from PIL import Image, ImageDraw

# 설정: 입력 폴더와 출력 폴더 이름
INPUT_DIR = 'input_images'
OUTPUT_DIR = 'output_images'

# 워터마크 제거 설정 (오른쪽 하단)
WATERMARK_RATIO = 0.15 # 이미지 크기의 약 15% 영역을 마스킹

def remove_backgrounds():
    # 출력 폴더가 없으면 생성
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    # 입력 폴더의 파일들을 순회
    if not os.path.exists(INPUT_DIR):
         os.makedirs(INPUT_DIR)
         print(f"'{INPUT_DIR}' 폴더가 생성되었습니다. 이미지를 넣고 다시 실행해주세요.")
         return

    files = os.listdir(INPUT_DIR)
    
    print(f"총 {len(files)}개의 파일을 처리합니다...")

    for filename in files:
        if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.webp')):
            input_path = os.path.join(INPUT_DIR, filename)
            output_path = os.path.join(OUTPUT_DIR, filename.split('.')[0] + ".png")

            print(f"처리 중: {filename}")

            try:
                # 1. 이미지 열기
                input_image = Image.open(input_path).convert("RGBA")
                
                # 2. 배경 제거 수행
                no_bg_image = remove(input_image)

                # 3. 워터마크 영역 강제 삭제 (투명화)
                # Bounding Box를 구하기 전에, 우측 하단 워터마크 영역을 완전히 지움(Alpha=0)
                w, h = no_bg_image.size
                mask_size = int(min(w, h) * WATERMARK_RATIO)
                
                draw = ImageDraw.Draw(no_bg_image)
                # 'Eraser' 모드처럼 동작시키기 위해 투명색(0,0,0,0)으로 덮어씀
                # 주의: PIL Draw에서 Alpha 합성은 기존 픽셀을 덮어쓰는 모드가 기본임 (RGBA image)
                draw.rectangle(
                    [(w - mask_size, h - mask_size), (w, h)], 
                    fill=(0, 0, 0, 0) 
                )

                # 4. 투명한 여백 제거 (Cropping) 및 사이즈 통일
                # 내용물이 있는 영역(Bounding Box)을 구함
                bbox = no_bg_image.getbbox()
                
                if bbox:
                    # a. 타이트하게 크롭
                    cropped_image = no_bg_image.crop(bbox)
                    
                    # b. 1024x1024 캔버스에 중앙 정렬 (Resize & Pad)
                    target_size = (1024, 1024)
                    final_image = Image.new("RGBA", target_size, (0, 0, 0, 0))
                    
                    # 원본 비율 유지하면서 리사이징 (여백 확보를 위해 90% 크기 적용)
                    # max_dim = 900 (약 90% of 1024)
                    safe_zone = 900
                    cropped_image.thumbnail((safe_zone, safe_zone), Image.Resampling.LANCZOS)
                    
                    # 중앙 좌표 계산
                    offset = (
                        (target_size[0] - cropped_image.width) // 2,
                        (target_size[1] - cropped_image.height) // 2
                    )
                    
                    final_image.paste(cropped_image, offset)
                    
                    final_image.save(output_path)
                    print(f"완료 (사이즈 통일 1024px): {output_path}")
                else:
                    # 이미지가 완전히 투명한 경우 그냥 저장
                    no_bg_image.save(output_path)
                    print(f"완료 (빈 이미지): {output_path}")
            
            except Exception as e:
                print(f"에러 발생 ({filename}): {e}")

if __name__ == "__main__":
    remove_backgrounds()
