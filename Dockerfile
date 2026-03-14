# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
RUN comfy node install --exit-on-fail comfyui-inpaint-cropandstitch@3.0.1 --mode remote
RUN comfy node install --exit-on-fail comfyui-logicutils@1.7.2
RUN comfy node install --exit-on-fail comfyui-easy-use@1.3.5 --mode remote
RUN comfy node install --exit-on-fail comfyui-kjnodes@1.2.5
RUN comfy node install --exit-on-fail comfyui_essentials@1.1.0
RUN comfy node install --exit-on-fail comfyui-logicutils@1.7.2 --mode remote
RUN comfy node install --exit-on-fail comfyui-rmbg@2.9.6

RUN git clone https://github.com/1038lab/ComfyUI-MiniMax-Remover /comfyui/custom_nodes/ComfyUI-MiniMax-Remover
RUN pip install -r /comfyui/custom_nodes/ComfyUI-MiniMax-Remover/requirements.txt

RUN ls /comfyui
RUN rm -f /comfyui/extra_model_paths.yaml
RUN ls /comfyui
ADD extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors --relative-path models/text_encoders --filename qwen_2.5_vl_7b_fp8_scaled.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2511_fp8mixed.safetensors --relative-path models/diffusion_models --filename qwenImageEdit2511_fp8.safetensors
RUN comfy model download --url https://huggingface.co/lightx2v/Qwen-Image-Edit-2511-Lightning/resolve/main/Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors --relative-path models/loras --filename Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors --relative-path models/vae --filename qwen_image_vae.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
