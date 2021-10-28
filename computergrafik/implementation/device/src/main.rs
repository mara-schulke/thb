use anyhow::anyhow;
use async_std::net::TcpListener;
//use async_tungstenite::tungstenite::Message;
use async_std::sync::*;
use futures::prelude::*;
use gstreamer::prelude::*;
use http_types::{Response, StatusCode};

//use gstreamer::{parse_bin_from_description, ElementFlags, MessageType};
use std::io::Read;
//use std::io::Write;
//use std::sync::Arc;
//
//

const WEBRTC_PIPELINE: &str = "webrtcbin name=webrtcbin stun-server=stun://stun.l.google.com:19302 VIDEO_SRC ! videorate ! videoscale \
                              ! video/x-raw,width=640,height=360,framerate=15/1 ! videoconvert ! queue max-size-buffers=1 \
                              ! x264enc bitrate=600 speed-preset=ultrafast tune=zerolatency key-int-max=15 \
                              ! video/x-h264,profile=constrained-baseline ! queue max-size-time=100000000 ! h264parse \
                              ! rtph264pay config-interval=-1 name=payloader aggregate-mode=zero-latency \
                              ! application/x-rtp,media=video,encoding-name=H264,payload=96 \
                              ! webrtcbin. autoaudiosrc is-live=1 ! queue max-size-buffers=1 leaky=downstream \
                              ! audioconvert ! audioresample ! opusenc ! rtpopuspay pt=97 \
                              ! webrtcbin. ";

//const TEST_PIPELINE: &str = "videotestsrc pattern=ball is-live=1 ! video/x-raw,width=320,height=240,framerate=1/1 ! jpegenc ! appsink name=appsink drop=true max-buffers=1";

#[async_std::main]
async fn main() -> anyhow::Result<()> {
    gstreamer::init().unwrap();

    let pipeline = gstreamer::parse_launch(WEBRTC_PIPELINE)
        .unwrap()
        .downcast::<gstreamer::Pipeline>()
        .unwrap();

    let appsink = pipeline.by_name("appsink").unwrap();
    let appsink = appsink.dynamic_cast::<gstreamer_app::AppSink>().unwrap();
    let image_stream = Arc::new(Mutex::new(appsink.stream()));
    pipeline.set_state(gstreamer::State::Playing).unwrap();

    let listener = TcpListener::bind("127.0.0.1:1234").await?;
    let mut incoming = listener.incoming();

    while let Some(Ok(stream)) = incoming.next().await {
        let img_stream_copy = image_stream.clone();

        async_std::task::spawn(async_h1::accept(stream, move |_| async {
            let mut img_stream = img_stream_copy.lock().await;

            if let Some(img) = img_stream.next().fuse().await {
                let mut res = Response::new(StatusCode::Ok);
                res.insert_header("Content-Type", "text/html");

                let mut buffer = Vec::new();
                img.buffer()
                    .unwrap()
                    .as_cursor_readable()
                    .read_to_end(&mut buffer)
                    .unwrap();

                let img_str = base64::encode(&buffer);
                let html = format!(
                        "<!DOCTYPE html><html><body><img src=\"data:image/jpeg;base64, {}\"/><script>setTimeout(() => window.location.reload(), 1000)</script></body></html>",
                        img_str
                    );

                res.set_body(html);
                Ok(res)
            } else {
                Ok(Response::new(StatusCode::NotFound))
            }
        }));
    }

    Ok(())
}
