# =====================================================================
# Docker(ECR イメージ)版の Dockerfile【旧構成・参考用にコメントアウト】
# ---------------------------------------------------------------------
# zip(provided.al2)版へ移行したため未使用。
# zip 版では serverless.yml の scripts フックが swift:amazonlinux2 イメージで
# `swift build -c release --static-swift-stdlib` を実行し、生成物を bootstrap に
# コピーするため、この Dockerfile は不要になった。
# ---------------------------------------------------------------------
# FROM swift:amazonlinux2 as build-image
#
# WORKDIR /work
# COPY ./ ./
#
# RUN swift build -c release --static-swift-stdlib
# RUN chmod +x .build/release/LambdaSwiftServerless
#
# FROM public.ecr.aws/lambda/provided:latest
#
# COPY --from=build-image /work/.build/release/LambdaSwiftServerless /var/runtime/bootstrap
#
# CMD ["dummyHandler"]
# =====================================================================
