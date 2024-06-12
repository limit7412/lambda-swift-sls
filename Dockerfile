FROM swift:amazonlinux2 as build-image

WORKDIR /work
COPY ./ ./

RUN swift build -c release --static-swift-stdlib
RUN chmod +x .build/release/LambdaSwiftServerless

FROM public.ecr.aws/lambda/provided:latest

COPY --from=build-image /work/.build/release/LambdaSwiftServerless /var/runtime/bootstrap

CMD ["dummyHandler"]